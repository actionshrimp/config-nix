---
name: devteam
description: Spawn a dev team (planner, developer, QE, reviewer, researcher) to implement a milestone
user_invocable: true
argument-hint: "<milestone, e.g. M1, M2>"
---

# Dev Team Skill

Spawn a five-agent team to implement a milestone.

## Instructions

When the user invokes `/devteam <milestone>`, do the following:

### 1. Read the milestone spec

Read `PLAN.md` (or equivalent project plan) and find the details for the requested milestone. Extract:
- What needs to be implemented
- What tests are expected
- The verification criteria

Derive a branch name from the milestone (kebab-case, e.g. `m1-pty-passthrough`, `m2-chrome-mode`).

### 2. Read project conventions

Read `CLAUDE.md` and/or `README.md` to understand:
- Build commands
- Lint/format commands
- Test commands
- Code style conventions
- Any other checks that must pass

These will be used by the QE and reviewer to verify the work.

### 3. Create the team

Use `TeamCreate` with `team_name: sesh-milestones`.

### 4. Create six tasks

**Task 1 — Planner (runs first, no dependencies):**
- Explore the codebase thoroughly to understand the current state and what needs to change
- Design a detailed implementation plan for the milestone, considering existing patterns, architecture, and conventions
- Write the plan to a file that other team members can reference
- Stay active after planning — the planner retains the full planning context and is the go-to resource for any teammate who needs details about the plan, architectural context, or design rationale
- Answer questions from other team members about the plan throughout the milestone
- Mark task complete only when all other tasks are complete (i.e., when the milestone is done)

**Task 2 — QE acceptance criteria (blocked by task 1):**
- Read the planner's implementation plan and the milestone spec
- Define a clear, numbered list of acceptance criteria that the milestone must satisfy
- For each criterion, include ideas for how it could be tested (unit test, E2E test, snapshot test, etc.)
- Write the acceptance criteria to a file that other team members can reference
- Follow testing conventions from project docs (CLAUDE.md / README.md)
- If uncertain about testing strategy or tooling, message the researcher for guidance
- If uncertain about requirements, message the planner for clarification
- Mark task complete when the acceptance criteria document is written

**Task 3 — Developer implementation (blocked by tasks 1 and 2):**
- Describe what to implement based on the milestone spec
- Specify the branch name to create
- Read the acceptance criteria document and keep them in mind throughout implementation
- Write both implementation code AND tests (unit tests, E2E tests) — the developer owns all code on the branch
- Use the acceptance criteria to guide what tests to write
- If QE or reviewer sends feedback during verification, fix issues and notify them
- **Commit changes after each iteration** — don't leave uncommitted work on the branch
- If uncertain about an approach, message the researcher for guidance before proceeding
- If uncertain about the plan, requirements, or architectural decisions, message the planner — they have the deepest context on the design and can clarify intent

**Task 4 — QE verification (blocked by task 3):**
- Read the implementation and tests on the feature branch
- Verify every acceptance criterion (from the acceptance criteria document) is met by the implementation
- Verify every acceptance criterion is represented by at least one automated test
- If any criterion is not met or not tested, message the developer with specific feedback and wait for them to iterate
- Continue iterating with the developer until ALL acceptance criteria are satisfied and tested
- **Own the "green build" gate**: before creating the PR, ensure ALL project checks pass (build, lint, format, tests — whatever the project specifies in CLAUDE.md / README.md)
- If any check fails, fix it or message the developer to fix it before proceeding
- Once all acceptance criteria are met AND all checks are green, create the PR from the feature branch to `main`
- After creating the PR, message the developer to see if they want to collaborate on or add to the PR description
- **Own the "CI green" gate**: after the PR is created, use `gh pr checks <PR_NUMBER> --watch` to verify all GitHub workflow checks pass. If any CI check fails, investigate the failure and either fix it directly or collaborate with the developer to resolve it. Do NOT notify the reviewer until all CI checks are green.
- Mark task complete and message the reviewer only after CI is green

**Task 5 — Review (blocked by tasks 3 and 4):**
- Review the PR against the milestone spec, acceptance criteria, and project conventions
- Verify all project checks pass locally (build, lint, format, tests)
- Use `gh pr checks <PR_NUMBER> --watch` to ensure all CI checks are passing on the PR. If any CI checks fail, investigate the failure, message developer/QE with actionable feedback, and wait for fixes. Do not consider the review complete until all CI checks are green.
- If issues found, message developer/QE with actionable feedback — iterate until satisfied
- Report back to team lead with PR URL when done. Do NOT merge.

**Task 6 — Researcher (ongoing, no blocking dependencies):**
- Available throughout the milestone to help other team members research the best approach for their tasks
- Does NOT write code or tests — provides research, recommendations, and guidance only
- Other team members can message the researcher at any time to ask questions like:
  - "What's the best crate/library to use for X?"
  - "What are the trade-offs between approach A and approach B?"
  - "How do other projects handle X?"
  - "What does the Rust/tokio/etc. documentation say about X?"
- Responds with clear, actionable recommendations backed by documentation, web research, and codebase analysis
- Marks task complete when all other tasks are complete (i.e., when the milestone is done)

Set dependencies: task 2 blocked by 1, task 3 blocked by 1 and 2, task 4 blocked by 3, task 5 blocked by 3 and 4. Tasks 1 and 6 have no blocking dependencies (available immediately).

### 5. Spawn five agents

All agents use:
- `team_name: sesh-milestones`
- `subagent_type: general-purpose`
- `mode: bypassPermissions`
- `run_in_background: true`

**Planner** (`name: planner`):
- Prompt should include: explore the codebase thoroughly, read PLAN.md and CLAUDE.md/README.md, then design a detailed implementation plan for the milestone. Write the plan to a file. After planning, stay active — you are the team's primary resource for plan context. Other teammates will message you with questions about the plan, design rationale, and architectural decisions. Answer them with the full context you gathered during planning. Mark your task complete only when all other tasks are done.
- Include key context: project root path, milestone spec, tell them to read CLAUDE.md/README.md and PLAN.md.
- Include: "Read the team config at `~/.claude/teams/{team-name}/config.json` to discover your teammates' actual names. Always use these names when messaging."

**Developer** (`name: developer`):
- Prompt should include: wait for the planner and QE acceptance criteria tasks to complete, then read the plan file AND the acceptance criteria document. Create the branch and implement the milestone, writing both implementation code AND tests (unit + E2E). Use the acceptance criteria to guide what tests to write. Mark task complete when done, message the QE to start verification. If QE or reviewer sends feedback, fix issues and notify them. **Commit changes after each iteration** — don't leave uncommitted work on the branch. If uncertain about an approach, message the researcher for guidance. If uncertain about the plan, requirements, or design decisions, message the planner — they have the deepest context on the overall design and can clarify intent.
- Include key context: project root path, tell them to read CLAUDE.md/README.md and PLAN.md.
- Include: "Read the team config at `~/.claude/teams/{team-name}/config.json` to discover your teammates' actual names. Always use these names when messaging."

**QE** (`name: qe`):
- Prompt should include: you have TWO tasks to complete sequentially.
  - **Task 2 (acceptance criteria)**: wait for the planner to complete, then read the plan and milestone spec. Define a numbered list of acceptance criteria with test ideas for each. Write them to a file. Mark task 2 complete.
  - **Task 4 (verification)**: wait for the developer to complete implementation, then verify every acceptance criterion is met and represented by automated tests. If anything is missing, message the developer with specific feedback and iterate until satisfied. Own the "green build" gate — read CLAUDE.md/README.md for all required checks (build, lint, format, tests) and ensure they all pass before creating the PR. Fix issues or message the developer to fix them. Only create the PR when all acceptance criteria are met AND everything is green. After creating the PR, message the developer to see if they want to collaborate on or add to the PR description. Then own the "CI green" gate — use `gh pr checks <PR_NUMBER> --watch` to verify all GitHub Actions workflow checks pass on the PR. If any CI check fails, investigate the failure and either fix it directly or collaborate with the developer to resolve it. Do NOT message the reviewer until all CI checks are green. Mark task 4 complete, message the reviewer only after CI is green.
  - **After completing task 2, check TaskList for your next task (task 4).**
  - If uncertain about testing strategy or tooling, message the researcher for guidance. If uncertain about the plan or requirements, message the planner for clarification.
- Include key context: tell them to read CLAUDE.md/README.md for testing conventions and required checks.
- Include: "Read the team config at `~/.claude/teams/{team-name}/config.json` to discover your teammates' actual names. Always use these names when messaging."

**Reviewer** (`name: reviewer`):
- Prompt should include: wait for developer and QE tasks, review the PR, verify all project checks pass locally, then use `gh pr checks <PR_NUMBER> --watch` to verify all CI checks are passing on the PR. If CI checks fail, investigate and message developer/QE with actionable feedback. Do not consider review complete until all CI checks are green. Review against milestone spec, acceptance criteria, and project conventions (CLAUDE.md/README.md), message developer/QE with actionable feedback if issues found, iterate until satisfied, mark task complete and report PR URL to team lead. If uncertain about the plan or design intent, message the planner for clarification.
- Include key context: tell them to read CLAUDE.md/README.md for project conventions and checks.
- Include: "Read the team config at `~/.claude/teams/{team-name}/config.json` to discover your teammates' actual names. Always use these names when messaging."

**Researcher** (`name: researcher`):
- Prompt should include: you are a research specialist available to help the team throughout the milestone. Your role is to answer questions from other team members about the best approach for their tasks. You do NOT write code or tests — you provide research, recommendations, and guidance. Use web search, documentation, and codebase analysis to give clear, actionable answers. When idle, wait for messages from teammates. Mark your task complete when all other team members have completed their tasks.
- Include key context: project root path, tell them to read CLAUDE.md/README.md and PLAN.md for project context.
- Include: "Read the team config at `~/.claude/teams/{team-name}/config.json` to discover your teammates' actual names. Always use these names when messaging."

### 6. Discover actual agent names

**CRITICAL**: After spawning all agents, the system may assign different names than requested (e.g., `qe-2` instead of `qe` if `qe` was already taken from a previous team). You MUST read the team config to discover the actual names:

1. Read `~/.claude/teams/{team-name}/config.json` to get the `members` array
2. Note each member's actual `name` — this is what you MUST use for all `SendMessage` calls
3. Store a mental mapping: role → actual name (e.g., "QE agent is actually `qe-2`")

**All subsequent communication MUST use the actual names from the config file, NOT the names you originally requested.** Messaging the wrong name means messages are silently lost.

Also include in each agent's prompt: "After starting, read the team config at `~/.claude/teams/{team-name}/config.json` to discover your teammates' actual names. Always use these names when sending messages — do NOT guess or assume names."

### 7. Report status

Show the user a summary table of the team (with actual agent names), tasks, and current status. Let them know the team will report back with a PR URL when the milestone is ready for their review.

## Context Recovery (Low Context Protocol)

A global `PostToolUse` hook (`~/.claude/hooks/context-monitor.sh`) automatically monitors context usage and injects a system warning when usage exceeds 85%. Agents do not need to self-monitor — the hook will tell them when to act.

When an agent receives the context warning, they should:

1. **Send a summary to the team lead** with:
   - What they've accomplished so far
   - What remains to be done
   - Current state of their work (branch, files changed, test results, blockers)
   - Any important context or decisions made during their work
2. The team lead will then **spawn a fresh replacement agent** with the same name (appending `-2`, `-3`, etc. as needed) and an updated prompt that includes:
   - The original task description
   - The summary from the previous agent (what's done, what's left, key decisions)
   - Overall team progress (which tasks are complete, which are in progress)
   - Any relevant file paths, branch names, or PR numbers
3. The team lead will **broadcast the name change** to the rest of the team so they message the correct agent name going forward.

**All agents should include this instruction in their prompts**: "A system hook monitors your context usage. If you receive a CONTEXT WARNING system message, immediately send a detailed progress summary to the team lead (not a teammate) so they can spawn a fresh replacement for you. Include: what you've done, what's left, current state, and key decisions."

## Key Rules

- The team does NOT merge the PR — they report back and wait for user confirmation
- The planner is the team's primary resource for plan context — teammates should message the planner (not the team lead) for questions about the plan, design rationale, and architectural decisions
- The QE defines acceptance criteria BEFORE the developer starts, then verifies them AFTER implementation
- The developer writes both implementation AND tests, guided by the acceptance criteria
- The QE and developer iterate until both are satisfied that all acceptance criteria are met and tested
- The reviewer sends actionable feedback that the team acts on
- The researcher provides guidance only — does NOT write code or tests
- Any team member can message the researcher at any time for research help
- Any team member can message the planner at any time for plan context and design clarification
- All iteration happens within the team before reporting back
- Always read project plan and conventions fresh for each milestone
