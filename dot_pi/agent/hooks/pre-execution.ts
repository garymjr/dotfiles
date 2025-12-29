/**
 * Pre-execution hook that prevents the agent from running `git push`
 * 
 * This hook intercepts any command execution attempt and blocks git push commands.
 */

export default {
  /**
   * Hook name
   */
  name: 'prevent-git-push',

  /**
   * Hook execution point
   */
  hookPoint: 'preExecution',

  /**
   * The hook function that runs before command execution
   * 
   * @param params - The parameters passed to the hook
   * @param params.command - The command about to be executed
   * @returns Response object with allow flag and optional message
   */
  execute: async ({ command }: { command: string }) => {
    // Check if the command is git push
    const commandLower = command.trim().toLowerCase();
    
    if (commandLower.startsWith('git push')) {
      return {
        allow: false,
        message: `⛔ The command "git push" has been blocked by a hook.

To push changes, please run the command manually in your terminal.`
      };
    }

    // Allow all other commands
    return {
      allow: true
    };
  }
};
