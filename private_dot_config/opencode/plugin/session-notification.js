export const SessionNotificationPlugin = async ({ project, client, $, directory, worktree }) => {
  return {
    event: async ({ event }) => {
      // Send notification on session completion
      if (event.type === "session.idle") {
        await $`printf "\\033]777;notify;OpenCode Session;Session completed successfully\\007"`
      }
      
      // Send notification when permissions are requested
      if (event.type === "permission.updated") {
        await $`printf "\\033]777;notify;OpenCode Permission;Permission requested: ${event.properties.title}\\007"`
      }
    },
  }
}