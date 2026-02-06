---
name: send-notification
description: Send the user a system notification to get their attention if explicitly requested
---
# Send Notification

Send a system notification to the user mid-run when they explicitly request it.

## Usage

When the user asks you to notify them about something (e.g., "notify me when the build finishes", "send me a notification when you're done"), use terminal-notifier directly:

```bash
terminal-notifier -title "Claude Code" -message "Your message here" -sound Submarine
```

## Examples

- User: "Let me know when tests are done" → `terminal-notifier -title "Claude Code" -message "Tests completed!" -sound Submarine`
- User: "Notify me if there are errors" → `terminal-notifier -title "Claude Code" -message "Found 3 errors in the build" -sound Submarine`
- User: "Send a notification when you finish" → `terminal-notifier -title "Claude Code" -message "Task completed" -sound Submarine`

## Important

Only use this when the user explicitly requests a notification. The notification appears as a native macOS system notification.
