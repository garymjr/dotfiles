#!/usr/bin/env node

/**
 * Gmail CLI Script
 * 
 * Usage:
 *   gmail.js auth              - Authenticate with Gmail API
 *   gmail.js list [--max N] [--query "query"] - List emails
 *   gmail.js read <message_id> - Read email content
 *   gmail.js archive <message_id> - Archive email (remove from inbox)
 *   gmail.js trash <message_id> - Move email to trash
 *   gmail.js label <message_id> <label> - Add label to email
 *   gmail.js labels            - List all labels
 */

const { google } = require('googleapis');
const fs = require('fs');
const path = require('path');
const readline = require('readline');

const CONFIG_DIR = path.join(process.env.HOME || process.env.USERPROFILE, '.config', 'zigbot', 'google');
const CREDENTIALS_PATH = path.join(CONFIG_DIR, 'credentials.json');
const TOKEN_PATH = path.join(CONFIG_DIR, 'token.json');

// SCOPES for Google APIs (Gmail + Calendar combined)
const SCOPES = [
  // Gmail scopes
  'https://www.googleapis.com/auth/gmail.readonly',
  'https://www.googleapis.com/auth/gmail.modify',
  // Calendar scopes
  'https://www.googleapis.com/auth/calendar.events',
  'https://www.googleapis.com/auth/calendar.readonly',
];

/**
 * Load or create OAuth2 client
 */
async function getOAuth2Client() {
  const credentials = require(CREDENTIALS_PATH);
  const { client_secret, client_id, redirect_uris } = credentials.web || credentials.installed;
  
  const oAuth2Client = new google.auth.OAuth2(client_id, client_secret, redirect_uris[0]);
  
  // Check if we have a stored token
  if (fs.existsSync(TOKEN_PATH)) {
    const token = JSON.parse(fs.readFileSync(TOKEN_PATH, 'utf8'));
    oAuth2Client.setCredentials(token);
    
    // Check if token needs refresh
    oAuth2Client.on('tokens', (tokens) => {
      if (tokens.refresh_token) {
        const currentToken = JSON.parse(fs.readFileSync(TOKEN_PATH, 'utf8'));
        const newToken = { ...currentToken, ...tokens };
        fs.writeFileSync(TOKEN_PATH, JSON.stringify(newToken, null, 2));
      }
    });
    
    return oAuth2Client;
  }
  
  return getNewToken(oAuth2Client);
}

/**
 * Get new token via OAuth flow
 */
function getNewToken(oAuth2Client) {
  const authUrl = oAuth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: SCOPES,
  });
  
  console.log('Authorize this app by visiting this url:', authUrl);
  
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });
  
  return new Promise((resolve, reject) => {
    rl.question('\nEnter the code from that page here: ', (code) => {
      rl.close();
      oAuth2Client.getToken(code, (err, token) => {
        if (err) {
          reject(err);
          return;
        }
        fs.writeFileSync(TOKEN_PATH, JSON.stringify(token, null, 2));
        console.log('Token stored to', TOKEN_PATH);
        resolve(oAuth2Client);
      });
    });
  });
}

/**
 * List emails
 */
async function listEmails(maxResults = 10, query = 'is:inbox') {
  const auth = await getOAuth2Client();
  const gmail = google.gmail({ version: 'v1', auth });
  
  const res = await gmail.users.messages.list({
    userId: 'me',
    maxResults,
    q: query,
  });
  
  const messages = res.data.messages || [];
  
  if (messages.length === 0) {
    console.log('No emails found.');
    return;
  }
  
  console.log(`\nFound ${messages.length} emails:\n`);
  
  // Get details for each message
  for (const msg of messages) {
    const detail = await gmail.users.messages.get({
      userId: 'me',
      id: msg.id,
      format: 'metadata',
      metadataHeaders: ['Subject', 'From', 'Date', 'Snippet'],
    });
    
    const headers = detail.data.payload.headers;
    const getHeader = (name) => headers.find(h => h.name.toLowerCase() === name.toLowerCase())?.value || '(No subject)';
    
    console.log(`ID: ${msg.id}`);
    console.log(`  From: ${getHeader('From')}`);
    console.log(`  Subject: ${getHeader('Subject')}`);
    console.log(`  Date: ${getHeader('Date')}`);
    console.log(`  Preview: ${getHeader('Snippet').substring(0, 80)}...`);
    console.log('');
  }
}

/**
 * Read email content
 */
async function readEmail(messageId) {
  const auth = await getOAuth2Client();
  const gmail = google.gmail({ version: 'v1', auth });
  
  const detail = await gmail.users.messages.get({
    userId: 'me',
    id: messageId,
    format: 'full',
  });
  
  const headers = detail.data.payload.headers;
  const getHeader = (name) => headers.find(h => h.name.toLowerCase() === name.toLowerCase())?.value || '';
  
  console.log('\n=== Email Details ===\n');
  console.log(`From: ${getHeader('From')}`);
  console.log(`To: ${getHeader('To')}`);
  console.log(`Subject: ${getHeader('Subject')}`);
  console.log(`Date: ${getHeader('Date')}`);
  console.log(`Message-ID: ${getHeader('Message-ID')}`);
  console.log('');
  
  // Get body content
  const body = getBody(detail.data.payload);
  console.log('=== Body ===\n');
  console.log(body);
  console.log('');
  
  // Show labels
  if (detail.data.labelIds && detail.data.labelIds.length > 0) {
    console.log(`Labels: ${detail.data.labelIds.join(', ')}`);
  }
}

/**
 * Extract body from payload
 */
function getBody(payload) {
  if (!payload) return '';
  
  if (payload.parts) {
    // Multi-part message
    for (const part of payload.parts) {
      if (part.mimeType === 'text/plain' && part.body && part.body.data) {
        return Buffer.from(part.body.data, 'base64').toString('utf8');
      }
      // Recurse into nested parts
      if (part.parts) {
        const nested = getBody(part);
        if (nested) return nested;
      }
    }
  }
  
  if (payload.body && payload.body.data) {
    return Buffer.from(payload.body.data, 'base64').toString('utf8');
  }
  
  return '';
}

/**
 * Archive email (remove from inbox)
 */
async function archiveEmail(messageId) {
  const auth = await getOAuth2Client();
  const gmail = google.gmail({ version: 'v1', auth });
  
  // Get current labels
  const detail = await gmail.users.messages.get({
    userId: 'me',
    id: messageId,
    format: 'minimal',
  });
  
  const labelIds = detail.data.labelIds || [];
  const inboxIndex = labelIds.indexOf('INBOX');
  
  if (inboxIndex > -1) {
    labelIds.splice(inboxIndex, 1);
  }
  
  await gmail.users.messages.modify({
    userId: 'me',
    id: messageId,
    requestBody: {
      removeLabelIds: ['INBOX'],
    },
  });
  
  console.log(`Email ${messageId} archived (removed from Inbox).`);
}

/**
 * Trash email
 */
async function trashEmail(messageId) {
  const auth = await getOAuth2Client();
  const gmail = google.gmail({ version: 'v1', auth });
  
  await gmail.users.messages.trash({
    userId: 'me',
    id: messageId,
  });
  
  console.log(`Email ${messageId} moved to Trash.`);
}

/**
 * Add label to email
 */
async function labelEmail(messageId, labelName) {
  const auth = await getOAuth2Client();
  const gmail = google.gmail({ version: 'v1', auth });
  
  // First, get or create the label
  let labelId;
  
  // Try to find existing label
  const labelsRes = await gmail.users.labels.list({ userId: 'me' });
  const existingLabel = labelsRes.data.labels.find(
    l => l.name.toLowerCase() === labelName.toLowerCase()
  );
  
  if (existingLabel) {
    labelId = existingLabel.id;
  } else {
    // Create new label
    const createRes = await gmail.users.labels.create({
      userId: 'me',
      requestBody: {
        name: labelName,
        labelListVisibility: 'labelShow',
        messageListVisibility: 'show',
      },
    });
    labelId = createRes.data.id;
    console.log(`Created new label: ${labelName}`);
  }
  
  // Add label to message
  await gmail.users.messages.modify({
    userId: 'me',
    id: messageId,
    requestBody: {
      addLabelIds: [labelId],
    },
  });
  
  console.log(`Label "${labelName}" added to email ${messageId}.`);
}

/**
 * Remove label from email
 */
async function unlabelEmail(messageId, labelName) {
  const auth = await getOAuth2Client();
  const gmail = google.gmail({ version: 'v1', auth });
  
  // Find the label
  const labelsRes = await gmail.users.labels.list({ userId: 'me' });
  const existingLabel = labelsRes.data.labels.find(
    l => l.name.toLowerCase() === labelName.toLowerCase()
  );
  
  if (!existingLabel) {
    console.log(`Label "${labelName}" not found.`);
    return;
  }
  
  // Remove label from message
  await gmail.users.messages.modify({
    userId: 'me',
    id: messageId,
    requestBody: {
      removeLabelIds: [existingLabel.id],
    },
  });
  
  console.log(`Label "${labelName}" removed from email ${messageId}.`);
}

/**
 * List all labels
 */
async function listLabels() {
  const auth = await getOAuth2Client();
  const gmail = google.gmail({ version: 'v1', auth });
  
  const res = await gmail.users.labels.list({ userId: 'me' });
  const labels = res.data.labels || [];
  
  console.log('\n=== Gmail Labels ===\n');
  
  const systemLabels = labels.filter(l => l.type === 'system');
  const userLabels = labels.filter(l => l.type === 'user');
  
  console.log('System Labels:');
  for (const label of systemLabels) {
    console.log(`  ${label.name} (${label.messagesTotal} messages)`);
  }
  
  console.log('\nUser Labels:');
  if (userLabels.length === 0) {
    console.log('  (none)');
  } else {
    for (const label of userLabels) {
      console.log(`  ${label.name} (${label.messagesTotal} messages)`);
    }
  }
  console.log('');
}

/**
 * Main CLI
 */
async function main() {
  const args = process.argv.slice(2);
  const command = args[0];
  
  // Check if credentials exist
  if (!fs.existsSync(CREDENTIALS_PATH)) {
    console.error(`ERROR: Credentials not found at ${CREDENTIALS_PATH}`);
    console.error('\nPlease follow the setup instructions in SKILL.md:');
    console.error('1. Go to Google Cloud Console → Enable Gmail API and Google Calendar API');
    console.error('2. Create OAuth credentials → Download JSON');
    console.error('3. Save as ~/.config/zigbot/google/credentials.json');
    process.exit(1);
  }
  
  try {
    switch (command) {
      case 'auth':
        await getOAuth2Client();
        console.log('Authentication complete!');
        break;
        
      case 'list': {
        let maxResults = 10;
        let query = 'is:inbox';
        
        for (let i = 1; i < args.length; i++) {
          if ((args[i] === '--max' || args[i] === '-m') && args[i + 1]) {
            maxResults = parseInt(args[i + 1], 10);
            i++;
          } else if ((args[i] === '--query' || args[i] === '-q') && args[i + 1]) {
            query = args[i + 1];
            i++;
          }
        }
        
        await listEmails(maxResults, query);
        break;
      }
      
      case 'read':
        if (!args[1]) {
          console.error('Usage: gmail.js read <message_id>');
          process.exit(1);
        }
        await readEmail(args[1]);
        break;
        
      case 'archive':
        if (!args[1]) {
          console.error('Usage: gmail.js archive <message_id>');
          process.exit(1);
        }
        await archiveEmail(args[1]);
        break;
        
      case 'trash':
        if (!args[1]) {
          console.error('Usage: gmail.js trash <message_id>');
          process.exit(1);
        }
        await trashEmail(args[1]);
        break;
        
      case 'label':
        if (!args[1] || !args[2]) {
          console.error('Usage: gmail.js label <message_id> <label_name>');
          process.exit(1);
        }
        await labelEmail(args[1], args[2]);
        break;
        
      case 'unlabel':
        if (!args[1] || !args[2]) {
          console.error('Usage: gmail.js unlabel <message_id> <label_name>');
          process.exit(1);
        }
        await unlabelEmail(args[1], args[2]);
        break;
        
      case 'labels':
        await listLabels();
        break;
        
      default:
        console.log(`
Gmail CLI - Available commands:

  auth              Authenticate with Gmail API
  list [--max N] [--query "query"]  List emails (default: last 10 inbox)
  read <id>         Read email content by message ID
  archive <id>     Archive email (remove from inbox)
  trash <id>        Move email to trash
  label <id> <name> Add label to email
  unlabel <id> <name> Remove label from email
  labels            List all available labels

Examples:
  gmail.js list --max 20 --query "is:unread"
  gmail.js read 123abc456def789
  gmail.js label 123abc456def789 "Work"
  gmail.js unlabel 123abc456def789 "review"
  gmail.js labels
`);
        process.exit(command ? 1 : 0);
    }
  } catch (error) {
    console.error('Error:', error.message);
    if (error.response) {
      console.error('Details:', error.response.data?.error || error.message);
    }
    process.exit(1);
  }
}

main();
