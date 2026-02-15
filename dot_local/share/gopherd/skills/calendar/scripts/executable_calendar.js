#!/usr/bin/env node

/**
 * Google Calendar CLI Script
 * 
 * Usage:
 *   calendar.js auth                    - Authenticate with Google Calendar API
 *   calendar.js list [--days N]         - List upcoming events
 *   calendar.js create <title> <start> <end> - Create new event
 *   calendar.js read <event_id>         - Get event details
 *   calendar.js update <event_id> [title] - Update event
 *   calendar.js delete <event_id>      - Delete event
 *   calendar.js calendars               - List all calendars
 * 
 * DateTime format: ISO 8601 (e.g., "2026-02-15T14:00:00")
 */

const { google } = require('googleapis');
const fs = require('fs');
const path = require('path');
const readline = require('readline');

const SKILL_DIR = path.resolve(path.dirname(__filename), '..');
const BASE_DIR = path.resolve(SKILL_DIR, '..', '..');
const CONFIG_ROOT = process.env.GOOGLE_CONFIG_DIR
  ? path.resolve(process.env.GOOGLE_CONFIG_DIR)
  : path.join(BASE_DIR, 'google');

const CREDENTIALS_PATH = process.env.GOOGLE_CREDENTIALS_PATH
  ? path.resolve(process.env.GOOGLE_CREDENTIALS_PATH)
  : path.join(CONFIG_ROOT, 'credentials.json');

const TOKEN_PATH = process.env.GOOGLE_TOKEN_PATH
  ? path.resolve(process.env.GOOGLE_TOKEN_PATH)
  : path.join(CONFIG_ROOT, 'token.json');

function ensureParentDirectory(filePath) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
}

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
        ensureParentDirectory(TOKEN_PATH);
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
        ensureParentDirectory(TOKEN_PATH);
        fs.writeFileSync(TOKEN_PATH, JSON.stringify(token, null, 2));
        console.log('Token stored to', TOKEN_PATH);
        resolve(oAuth2Client);
      });
    });
  });
}

/**
 * List upcoming events
 */
async function listEvents(days = 7, calendarId = 'primary') {
  const auth = await getOAuth2Client();
  const calendar = google.calendar({ version: 'v3', auth });
  
  const now = new Date();
  const endDate = new Date();
  endDate.setDate(now.getDate() + days);
  
  const res = await calendar.events.list({
    calendarId,
    timeMin: now.toISOString(),
    timeMax: endDate.toISOString(),
    singleEvents: true,
    orderBy: 'startTime',
  });
  
  const events = res.data.items || [];
  
  if (events.length === 0) {
    console.log('No upcoming events found.');
    return;
  }
  
  console.log(`\nUpcoming events (next ${days} days):\n`);
  
  for (const event of events) {
    const start = event.start.dateTime || event.start.date;
    const end = event.end.dateTime || event.end.date;
    console.log(`ID: ${event.id}`);
    console.log(`  Title: ${event.summary || '(No title)'}`);
    console.log(`  Start: ${start}`);
    console.log(`  End: ${end}`);
    if (event.location) {
      console.log(`  Location: ${event.location}`);
    }
    if (event.description) {
      const desc = event.description.length > 60 ? event.description.substring(0, 60) + '...' : event.description;
      console.log(`  Description: ${desc}`);
    }
    console.log('');
  }
}

/**
 * Create a new event
 */
async function createEvent(title, startTime, endTime, options = {}) {
  const auth = await getOAuth2Client();
  const calendar = google.calendar({ version: 'v3', auth });
  
  const event = {
    summary: title,
    start: {
      dateTime: startTime,
      timeZone: 'America/Phoenix',
    },
    end: {
      dateTime: endTime,
      timeZone: 'America/Phoenix',
    },
  };
  
  if (options.description) {
    event.description = options.description;
  }
  
  if (options.location) {
    event.location = options.location;
  }
  
  const res = await calendar.events.insert({
    calendarId: options.calendarId || 'primary',
    resource: event,
  });
  
  console.log(`Event created: ${res.data.id}`);
  console.log(`  Title: ${res.data.summary}`);
  console.log(`  Link: ${res.data.htmlLink}`);
}

/**
 * Read event details
 */
async function readEvent(eventId, calendarId = 'primary') {
  const auth = await getOAuth2Client();
  const calendar = google.calendar({ version: 'v3', auth });
  
  const res = await calendar.events.get({
    calendarId,
    eventId,
  });
  
  const event = res.data;
  
  console.log('\n=== Event Details ===\n');
  console.log(`ID: ${event.id}`);
  console.log(`Title: ${event.summary || '(No title)'}`);
  console.log(`Start: ${event.start.dateTime || event.start.date}`);
  console.log(`End: ${event.end.dateTime || event.end.date}`);
  
  if (event.location) {
    console.log(`Location: ${event.location}`);
  }
  
  if (event.description) {
    console.log(`\nDescription:\n${event.description}`);
  }
  
  if (event.attendees) {
    console.log(`\nAttendees (${event.attendees.length}):`);
    for (const attendee of event.attendees) {
      console.log(`  - ${attendee.email} (${attendee.responseStatus})`);
    }
  }
  
  console.log(`\nLink: ${event.htmlLink}`);
  console.log('');
}

/**
 * Update an event
 */
async function updateEvent(eventId, newTitle, options = {}, calendarId = 'primary') {
  const auth = await getOAuth2Client();
  const calendar = google.calendar({ version: 'v3', auth });
  
  // First get the current event
  const current = await calendar.events.get({
    calendarId,
    eventId,
  });
  
  const event = {};
  
  // Only update fields that are provided
  if (newTitle) {
    event.summary = newTitle;
  }
  
  if (options.start) {
    event.start = {
      dateTime: options.start,
      timeZone: 'America/Phoenix',
    };
  }
  
  if (options.end) {
    event.end = {
      dateTime: options.end,
      timeZone: 'America/Phoenix',
    };
  }
  
  if (options.description !== undefined) {
    event.description = options.description;
  }
  
  if (options.location !== undefined) {
    event.location = options.location;
  }
  
  const res = await calendar.events.patch({
    calendarId,
    eventId,
    resource: event,
  });
  
  console.log(`Event updated: ${res.data.id}`);
  console.log(`  Title: ${res.data.summary}`);
  console.log(`  Link: ${res.data.htmlLink}`);
}

/**
 * Delete an event
 */
async function deleteEvent(eventId, calendarId = 'primary') {
  const auth = await getOAuth2Client();
  const calendar = google.calendar({ version: 'v3', auth });
  
  await calendar.events.delete({
    calendarId,
    eventId,
  });
  
  console.log(`Event ${eventId} deleted.`);
}

/**
 * List calendars
 */
async function listCalendars() {
  const auth = await getOAuth2Client();
  const calendar = google.calendar({ version: 'v3', auth });
  
  const res = await calendar.calendarList.list();
  const calendars = res.data.items || [];
  
  console.log('\n=== Your Calendars ===\n');
  
  for (const cal of calendars) {
    const primary = cal.primary ? ' (primary)' : '';
    console.log(`ID: ${cal.id}`);
    console.log(`  Summary: ${cal.summary}${primary}`);
    console.log(`  Background Color: ${cal.backgroundColor}`);
    console.log('');
  }
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
    console.error(`3. Save credentials JSON to ${CREDENTIALS_PATH}`);
    console.error('   Override with GOOGLE_CREDENTIALS_PATH, GOOGLE_TOKEN_PATH, or GOOGLE_CONFIG_DIR if needed.');
    process.exit(1);
  }
  
  try {
    switch (command) {
      case 'auth':
        await getOAuth2Client();
        console.log('Authentication complete!');
        break;
        
      case 'list': {
        let days = 7;
        let calendarId = 'primary';
        
        for (let i = 1; i < args.length; i++) {
          if ((args[i] === '--days' || args[i] === '-d') && args[i + 1]) {
            days = parseInt(args[i + 1], 10);
            i++;
          } else if ((args[i] === '--cal' || args[i] === '-c') && args[i + 1]) {
            calendarId = args[i + 1];
            i++;
          }
        }
        
        await listEvents(days, calendarId);
        break;
      }
      
      case 'create': {
        if (!args[1] || !args[2] || !args[3]) {
          console.error('Usage: calendar.js create <title> <start_time> <end_time>');
          console.error('Example: calendar.js create "Meeting" "2026-02-15T14:00:00" "2026-02-15T15:00:00"');
          process.exit(1);
        }
        
        const title = args[1];
        const startTime = args[2];
        const endTime = args[3];
        
        const options = {
          calendarId: 'primary',
        };
        
        // Parse optional flags
        for (let i = 4; i < args.length; i++) {
          if ((args[i] === '--description' || args[i] === '-m') && args[i + 1]) {
            options.description = args[i + 1];
            i++;
          } else if ((args[i] === '--location' || args[i] === '-l') && args[i + 1]) {
            options.location = args[i + 1];
            i++;
          } else if ((args[i] === '--cal' || args[i] === '-c') && args[i + 1]) {
            options.calendarId = args[i + 1];
            i++;
          }
        }
        
        await createEvent(title, startTime, endTime, options);
        break;
      }
      
      case 'read':
        if (!args[1]) {
          console.error('Usage: calendar.js read <event_id>');
          process.exit(1);
        }
        
        let readCalId = 'primary';
        for (let i = 2; i < args.length; i++) {
          if ((args[i] === '--cal' || args[i] === '-c') && args[i + 1]) {
            readCalId = args[i + 1];
            i++;
          }
        }
        
        await readEvent(args[1], readCalId);
        break;
        
      case 'update': {
        if (!args[1]) {
          console.error('Usage: calendar.js update <event_id> [new_title]');
          process.exit(1);
        }
        
        const eventId = args[1];
        const newTitle = args[2] || '';
        
        const options = {};
        let calendarId = 'primary';
        
        // Parse optional flags
        for (let i = 3; i < args.length; i++) {
          if (args[i] === '--start' && args[i + 1]) {
            options.start = args[i + 1];
            i++;
          } else if (args[i] === '--end' && args[i + 1]) {
            options.end = args[i + 1];
            i++;
          } else if ((args[i] === '--description' || args[i] === '-m') && args[i + 1]) {
            options.description = args[i + 1];
            i++;
          } else if ((args[i] === '--location' || args[i] === '-l') && args[i + 1]) {
            options.location = args[i + 1];
            i++;
          } else if ((args[i] === '--cal' || args[i] === '-c') && args[i + 1]) {
            calendarId = args[i + 1];
            i++;
          }
        }
        
        await updateEvent(eventId, newTitle, options, calendarId);
        break;
      }
        
      case 'delete':
        if (!args[1]) {
          console.error('Usage: calendar.js delete <event_id>');
          process.exit(1);
        }
        
        let deleteCalId = 'primary';
        for (let i = 2; i < args.length; i++) {
          if ((args[i] === '--cal' || args[i] === '-c') && args[i + 1]) {
            deleteCalId = args[i + 1];
            i++;
          }
        }
        
        await deleteEvent(args[1], deleteCalId);
        break;
        
      case 'calendars':
        await listCalendars();
        break;
        
      default:
        console.log(`
Google Calendar CLI - Available commands:

  auth                         Authenticate with Google Calendar API
  list [--days N]             List upcoming events (default: next 7 days)
  create <title> <start> <end>  Create new event
  read <event_id>              Get event details
  update <event_id> [title]   Update event
  delete <event_id>            Delete event
  calendars                    List all calendars

DateTime format: ISO 8601 (e.g., "2026-02-15T14:00:00")

Examples:
  calendar.js list --days 30
  calendar.js create "Team Meeting" "2026-02-15T14:00:00" "2026-02-15T15:00:00" --location "Conference Room"
  calendar.js read abc123xyz
  calendar.js update abc123xyz "New Title"
  calendar.js delete abc123xyz
  calendar.js calendars
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
