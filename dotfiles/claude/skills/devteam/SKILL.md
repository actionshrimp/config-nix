---
name: devteam
description: Spawn a dev team (developer, QE, reviewer) to implement a milestone
user_invocable: true
argument-hint: "<milestone, e.g. M1, M2>"
---

# Dev Team Skill

Spawn a three-agent team to implement a milestone.

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

### 4. Create three tasks

**Task 1 — Developer implementation:**
- Describe what to implement based on the milestone spec
- Specify the branch name to create
- Emphasize: do NOT write tests, focus on implementation only

**Task 2 — QE testing (blocked by task 1):**
- Describe the unit tests and E2E tests needed based on the milestone spec
- Emphasize: test from the **spec**, not just what was implemented
- If the implementation is missing specified behavior, push back on the developer before writing tests
- Follow testing conventions from project docs (CLAUDE.md / README.md)
- Manual testing is encouraged where useful, but any manual test that validates important behavior should be encoded as an automated E2E test so it can be reused in future iterations
- **Own the "green build" gate**: before creating the PR, ensure ALL project checks pass (build, lint, format, tests — whatever the project specifies in CLAUDE.md / README.md)
- If any check fails, fix it or message the developer to fix it before proceeding
- Once all checks are green, create the PR from the feature branch to `main`

**Task 3 — Review (blocked by tasks 1 and 2):**
- Review the PR against the milestone spec and project conventions
- Verify all project checks pass (build, lint, format, tests)
- If issues found, message developer/QE with actionable feedback — iterate until satisfied
- Report back to team lead with PR URL when done. Do NOT merge.

Set dependencies: task 2 blocked by 1, task 3 blocked by 1 and 2.

### 5. Spawn three agents

All agents use:
- `team_name: sesh-milestones`
- `subagent_type: general-purpose`
- `mode: bypassPermissions`
- `run_in_background: true`

**Developer** (`name: developer`):
- Prompt should include: read task, create branch, implement the milestone, mark task complete when done, message the QE to start. If QE or reviewer sends feedback, fix issues and notify them.
- Include key context: project root path, tell them to read CLAUDE.md/README.md and PLAN.md.

**QE** (`name: qe`):
- Prompt should include: wait for developer task to complete, then read the implementation, write tests driven by the milestone spec (not just what was implemented), push back on developer if anything is missing. Own the "green build" gate — read CLAUDE.md/README.md for all required checks (build, lint, format, tests) and ensure they all pass before creating the PR. Fix issues or message the developer to fix them. Only create the PR when everything is green. Mark task complete, message the reviewer.
- Include key context: tell them to read CLAUDE.md/README.md for testing conventions and required checks.

**Reviewer** (`name: reviewer`):
- Prompt should include: wait for developer and QE tasks, review the PR, verify all project checks pass, review against milestone spec and project conventions (CLAUDE.md/README.md), message developer/QE with actionable feedback if issues found, iterate until satisfied, mark task complete and report PR URL to team lead.
- Include key context: tell them to read CLAUDE.md/README.md for project conventions and checks.

### 6. Report status

Show the user a summary table of the team, tasks, and current status. Let them know the team will report back with a PR URL when the milestone is ready for their review.

## Key Rules

- The team does NOT merge the PR — they report back and wait for user confirmation
- The QE tests against the spec, not just the implementation
- The reviewer sends actionable feedback that the team acts on
- All iteration happens within the team before reporting back
- Always read project plan and conventions fresh for each milestone
