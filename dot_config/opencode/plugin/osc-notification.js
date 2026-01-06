export const OSCNotificationPlugin = async ({ project, client, $, directory, worktree }) => {
  return {
    event: async ({ event }) => {
      // Send notification when session becomes idle (finished)
      if (event.type === "session.idle") {
        // Use OSC 777 for notification
        // Format: \033]777;notify;title;message\007
        const title = "OpenCode"
        const message = "Task completed!"
        const oscNotification = "\x1b]777;notify;" + title + ";" + message + "\x07"
        
        // Print the OSC sequence directly to stdout
        process.stdout.write(oscNotification)
      }
      
      // Send notification when a permission is requested
      if (event.type === "permission.updated") {
        // Use OSC 777 for notification
        // Format: \033]777;notify;title;message\007
        const title = "OpenCode Permission Request"
        const message = `Permission requested: ${event.properties.title}`
        const oscNotification = "\x1b]777;notify;" + title + ";" + message + "\x07"
        
        // Print the OSC sequence directly to stdout
        process.stdout.write(oscNotification)
      }
    },
  }
}
