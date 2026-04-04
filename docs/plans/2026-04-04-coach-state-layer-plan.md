# Founder Coach v1.1 — State Layer Implementation Plan

> **For Claude:** REQUIRED: Follow this plan phase-by-phase. Each phase has explicit files, steps, and exit criteria.
> **Design:** See `docs/plans/2026-04-04-coach-state-layer-design.md` for full specification.

**Goal:** Add 3-layer memory (context.md, patterns.md, progress.md), hooks (SessionStart, Stop), session evidence, cron mode, and git sync to the founder-coach plugin while keeping total state layer overhead under 6 seconds and full sessions under 2 minutes.

**Architecture:** Extend the existing SKILL.md routing engine with a new Step 0 (memory load) and Step N (memory write). Add hooks via Claude Code convention (`hooks/hooks.json` at plugin root, sibling to `.claude-plugin/`). Memory files live in `state/` alongside existing streak.json, scoreboard.md, and decisions.md. Cron mode is a new routing path in SKILL.md. Git sync is opt-in via `GIT_SYNC` setting in `state/context.md`.

**Tech Stack:** Markdown state files (SKILL.md prompt-as-code), shell scripts for hooks, JSON for hook definitions. No external dependencies.

**Prerequisites:** v1 build complete (12/12 acceptance checks passing). Existing files: `skills/coach/SKILL.md` (602 lines), `.claude-plugin/plugin.json`, `agents/coach.md`, 7 templates, 2 references.

**Durable Decisions:**
- Memory files at `state/context.md`, `state/patterns.md`, `state/progress.md` (co-located with existing state files)
- Hook format: `hooks/hooks.json` at plugin root (sibling to `.claude-plugin/`), following verified Claude Code convention (cc10x, ralph-loop)
- Hook events: `SessionStart` (pre-load context.md) and `Stop` (git commit+push) — note: `Stop` is inferred, not proven from all plugins
- Pattern promotion threshold: 3+ observations before promoting to patterns.md
- Git sync: pull-on-start, push-on-stop, controlled by `GIT_SYNC` setting
- Cron mode: detected via "cron" argument or `CRON_MODE: true` in context.md
- Backward compatible: missing memory files are created on first session end, not on first run
- Templates for memory files at `templates/context.md`, `templates/patterns.md`, `templates/progress.md`
- Version bump to 1.1.0 in plugin.json

---

## Human Layer

### Executive Summary
- Add cc10x-style 3-layer memory to the coaching engine so the coach compounds knowledge across sessions
- This approach fits the existing codebase because SKILL.md is prompt-as-code that already reads/writes state files — memory is just 3 more files with structured load/write steps
- Hooks use the real Claude Code plugin hook format (verified from cc10x and superpowers plugins)

### What I Verified vs What Still Needs Confirmation
- **Confident because:** Verified hook format from cc10x and ralph-loop plugins (`hooks/hooks.json` at plugin root with `SessionStart`, `Stop` events). Hook discovery is automatic (no `"hooks"` field needed in plugin.json — verified: cc10x and ralph-loop have none). SKILL.md routing is first-match-wins, adding cron detection before existing rules is safe. State files live in `state/` already.
- **Still needs confirmation:** None — all design decisions are user-approved via the design document.
- **Key risks:** Hook `SessionStart` cat command assumes `state/context.md` exists (mitigated by `2>/dev/null || echo 'NO_CONTEXT'`). Git push in `Stop` hook could add latency if remote is slow (mitigated by `--quiet` and `|| true` fallback). `Stop` event may not fire in all scenarios (only `SessionStart` is proven from multiple plugins).

### Request Summary
Add compounding memory, lifecycle hooks, session evidence, cron mode, and git sync to the founder-coach plugin while maintaining sub-2-minute sessions.

### Requirements Snapshot
1. Coach reads memory at session start automatically
2. Memory compounds: patterns promoted after 3+ observations
3. Session evidence captured in progress.md
4. Hooks auto-detect context and auto-save state
5. Full session under 2 minutes
6. State survives session restarts
7. Cron mode runs passive updates
8. Git sync works cross-computer

### Constraints Snapshot
- Total state layer overhead under 6 seconds
- Backward compatible with v1 (missing memory files handled gracefully)
- No external services
- No multi-agent routing
- Plugin hooks at `hooks/` (plugin root, sibling to `.claude-plugin/`)
- Speed is #1 constraint

### In Scope
- 3 new state files: `state/context.md`, `state/patterns.md`, `state/progress.md`
- 3 new templates: `templates/context.md`, `templates/patterns.md`, `templates/progress.md`
- Hook definitions: `hooks/hooks.json` (plugin root)
- SKILL.md updates: Step 0 (memory load), Step N (memory write), cron mode routing, git sync Step 0
- Plugin.json updates: version bump, updated description (no hooks field)
- `.gitignore` entry for `config/` directory (personal data protection)
- agents/coach.md updates: memory writing rules for the new 3-layer format

### Out Of Scope
- Multi-agent routing (specialist agents)
- Landing page or marketing
- Knowledge base / wiki
- Quarterly strategy reset (acknowledged as deferred from SPEC)
- README architecture diagram update (advisory only)

### Planning Mode
- Plan mode: `execution_plan`
- Verification rigor: `standard`

### Open Decisions
- None

### Differences From Agreement
- None

### Recommended Defaults
- None (all decisions resolved in design)

---

## Execution Contract Layer

### Codebase Reality Check
- **Verified files / surfaces:**
  - `skills/coach/SKILL.md` (602 lines) — routing engine with Step 1 (read context), Step 2 (session detection), session flows, error handling
  - `.claude-plugin/plugin.json` — manifest, no hooks field currently
  - `agents/coach.md` — persona + memory writing rules (4 types: user/feedback/project/reference)
  - `templates/` — 7 files (5 config + 2 state templates)
  - `state/` — runtime directory with streak.json, scoreboard.md, decisions.md
- **Existing patterns / constraints:**
  - SKILL.md uses ordered steps (Step 1, Step 2, etc.) and first-match-wins routing
  - State files are created by FIRST_RUN flow, not by hooks
  - Native Claude Code memory is currently the pattern learning layer (Steps 6/9 in morning/evening)
  - Config files are user-editable, state files are auto-managed
  - Hook format: `hooks/hooks.json` at plugin root (NOT inside `.claude-plugin/`) with event keys mapping to arrays of hook configs with `type`, `command`, `timeout`, `statusMessage`. No `"hooks"` field in plugin.json — Claude Code discovers hooks automatically.
- **Pressure points / contradictions:**
  - Design says "Hook: SessionStart — pre-loads state/context.md into session" but SessionStart hook outputs go to hook system, not directly into the LLM context. The hook CAN inject text that Claude sees as system context. Verified from cc10x: the command stdout is injected.
  - SKILL.md Step 1 (Morning) already reads "Read ALL context" — adding Step 0 memory load must come BEFORE this, not duplicate it
  - Evening flow Step 2 tries to recover morning actions from native memory — with the new state layer, actions could be stored in context.md instead, making recovery more reliable
  - agents/coach.md has native memory writing rules (4 types) — these should be KEPT alongside the new 3-layer state (native memory is fuzzy/cross-conversation, state layer is structured/exact)

### Plan-vs-Code Gaps
| Current code / behavior | Planned change | Gap / risk | Plan response |
|-------------------------|----------------|------------|---------------|
| SKILL.md starts at Step 1 (read config) | Add Step 0 before Step 1 (memory load + git sync) | Step numbering shift | Renumber: new Step 0 goes before existing Step 1. No changes to existing step content. |
| Morning Step 6 writes to native memory | Add Step N writing to state/context.md + patterns.md + progress.md | Dual write: native memory AND state files | Keep both. Native memory = fuzzy cross-conversation. State files = exact structured. Different purposes. |
| Evening Step 2 recovers morning actions from native memory | context.md `## Last Session` stores actions given | Better recovery source | Update Evening Step 2 to read from context.md first, fall back to native memory, then ask user. |
| No hook system exists | Add `hooks/hooks.json` at plugin root | New directory + file | Phase 1 creates hooks infrastructure. No plugin.json change needed (auto-discovered). |
| No cron mode | Add cron routing before existing session detection | New routing path | Insert cron detection as first check in Step 2, before existing rules 1-6. |
| FIRST_RUN creates state/ with 3 files | Add 3 memory file templates | FIRST_RUN should NOT create memory files (backward compat) | Memory files created on first session END, not FIRST_RUN. Templates exist for reference only. |
| plugin.json version 1.0.0 | Bump to 1.1.0, update description | Manifest change | Phase 5 updates manifest. No hooks field needed. |
| config/ contains personal data (identity.md, linkedin.md) | Add .gitignore for config/ | Data exposure risk if git-synced to public repo | Phase 5 adds .gitignore entry. |

### Assumption Ledger
- **Proven by code:** Hook format uses `hooks/hooks.json` at plugin root (verified from cc10x and ralph-loop plugins). `SessionStart` is a valid event (proven from cc10x). No `"hooks"` field needed in plugin.json (proven: cc10x and ralph-loop have none). SKILL.md uses ordered steps. State files at `state/`. Templates at `templates/`.
- **Inferred:** `Stop` is a valid hook event (used by ralph-loop, but not verified to fire in all scenarios). SessionStart hook stdout is injected as context visible to Claude (inferred from cc10x's similar pattern of injecting workflow context). Shell commands in hooks run from the plugin root (inferred from `${CLAUDE_PLUGIN_ROOT}` usage in cc10x).
- **Needs user confirmation:** None — design document is approved.

### Fresh Review Resolution

**Accepted findings:**
1. **BLOCKING - Hook file location (Finding 1):** Accepted. Moved hooks from `.claude-plugin/hooks/hooks.json` to `hooks/hooks.json` at plugin root. Verified from cc10x and ralph-loop installed plugins.
2. **plugin.json "hooks" field (Finding 2):** Accepted. Removed all references to adding `"hooks": "./hooks/hooks.json"` to plugin.json. No working plugin uses this pattern.
3. **"Stop" hook event unverified (Finding 3):** Accepted. Moved Stop from proven to inferred in Assumption Ledger. Added risk (Score 9) with mitigation: SKILL.md also runs git sync at session end as safety net.
4. **Action text storage (Finding 4):** Accepted. Clarified that morning memory write stores FULL ACTION TEXT (not just count) so evening session can reference exact wording.
5. **Config files exposed via git sync (Finding 5):** Accepted. Added `.gitignore` creation for `config/` directory in Phase 5. Added risk (Score 8) with mitigation.

**Rejected findings:** None

### Critical-Path Verification Design
- Behavior contract: Not required (standard rigor)
- Edge-case catalog: Missing memory files (skip gracefully), git conflicts (warn and continue), cron with no state (create initial), patterns.md promotion logic edge cases
- Provable properties: None
- Purity boundary map: Not required
- Verification strategy: Manual testing of each session type (morning/evening/weekly/cron) with and without memory files present

### Phase Dependency Map
- **Phase 1 (Hook Infrastructure):** depends on [plugin root directory], creates [`hooks/hooks.json`], enables [Phase 3 git sync, Phase 5 integration]
- **Phase 2 (Memory Templates + FIRST_RUN):** depends on [existing templates/], creates [3 memory templates, updated FIRST_RUN], enables [Phase 3 SKILL.md memory operations]
- **Phase 3 (SKILL.md Memory Operations + Git Sync):** depends on [Phase 2 templates], creates [Step 0 memory load, Step N memory write, git sync, pattern promotion], enables [Phase 4 cron, Phase 5 integration]
- **Phase 4 (Cron Mode):** depends on [Phase 3 memory ops], creates [cron routing path in SKILL.md], enables [Phase 5 integration]
- **Phase 5 (Polish + Integration):** depends on [Phases 1-4], creates [updated agents/coach.md, version bump, error handling updates], enables [final verification]

---

## Phase Plan

### Phase 1: Hook Infrastructure

**Objective:** Create the hook system so SessionStart pre-loads context and Stop auto-commits+pushes.

**Files:**
- Create: `hooks/hooks.json` (at plugin root, sibling to `.claude-plugin/`)

**Step 1: Create hooks directory and hooks.json**

Create `hooks/hooks.json` at plugin root:
```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|compact",
        "hooks": [
          {
            "type": "command",
            "command": "cat state/context.md 2>/dev/null || echo '# Coach Context\nNo memory yet. First session will create it.'",
            "timeout": 3,
            "statusMessage": "Loading coaching context"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "if grep -q 'GIT_SYNC: true' state/context.md 2>/dev/null; then cd \"$(git rev-parse --show-toplevel 2>/dev/null)\" && git add state/ && git commit -m \"coach session $(date '+%Y-%m-%d %H:%M')\" --quiet 2>/dev/null && git push --quiet 2>/dev/null; fi; true",
            "timeout": 10,
            "async": true,
            "statusMessage": "Syncing coaching state"
          }
        ]
      }
    ]
  }
}
```

Design notes:
- SessionStart uses `matcher: "startup|resume|compact"` to fire on all session starts (matches cc10x pattern)
- Stop hook checks for `GIT_SYNC: true` before attempting git operations
- Stop hook is `async: true` so it doesn't block session exit
- Both hooks have `|| true` / trailing `true` to never fail the session
- Timeout: 3s for SessionStart (just a cat), 10s for Stop (git push might be slow)

Note: No `"hooks"` field is added to plugin.json. Claude Code discovers `hooks/hooks.json` automatically at plugin root (verified from cc10x and ralph-loop — neither has a "hooks" field in plugin.json).

**Exit Criteria:**
- `hooks/hooks.json` exists at plugin root with valid JSON
- `cat hooks/hooks.json | python3 -m json.tool` returns valid JSON
- No `"hooks"` field in `.claude-plugin/plugin.json`

**Required checks:** JSON validation of hooks.json
**Checkpoint type:** none
**Allowed scope:** Only `hooks/` directory
**Out-of-scope drift:** Do NOT modify SKILL.md, templates, or plugin.json in this phase

---

### Phase 2: Memory Templates and FIRST_RUN Update

**Objective:** Create the 3 memory file templates and update FIRST_RUN to inform users about the new memory layer (but NOT create memory files on first run — backward compat).

**Files:**
- Create: `templates/context.md`
- Create: `templates/patterns.md`
- Create: `templates/progress.md`
- Modify: `skills/coach/SKILL.md` (FIRST_RUN section only)

**Step 1: Create templates/context.md**

```markdown
# Coach Context
<!-- Read at session start. Write at session end. -->

## Current Focus
[What the founder is working toward right now]

## Last Session
- Date: none
- Type: none
- Actions given: []
- Actions completed: []
- Decisions logged: []
- Key observation: First session

## Next Session Priority
[Derived from gaps, patterns, urgency]

## Active Decisions
[Decisions that are still live and should be reviewed weekly]

## Founder Profile
- Strengths: [observed from completions]
- Avoidance patterns: [observed from skips]
- Best time for deep work: [inferred]
- Communication style: [observed]

## Session Settings
# CRON_MODE: false
# GIT_SYNC: false
# CALENDAR_MCP: false
```

**Step 2: Create templates/patterns.md**

```markdown
# Coaching Patterns
<!-- Accumulated learnings. Promotes from context.md when repeated 3+ times. -->

## What Works
- [Pattern]: [Evidence from sessions]

## What Doesn't Work
- [Anti-pattern]: [What happened when tried]

## Avoidance Behaviors
- [Behavior]: [How often observed] - [Best coaching response]

## Action Effectiveness
- [Action type]: [Completion rate] - [When it works best]

## Voice Preferences
- [How the founder responds to different coaching styles]

## Scheduling Patterns
- [Best days for different session types]
```

**Step 3: Create templates/progress.md**

```markdown
# Progress Evidence
<!-- Hard data. Not opinions. -->

## Weekly History
[Rolling 8-week summary]

## Session Log (Last 14 days)
| Date | Type | Actions Given | Completed | Key Insight |
|------|------|---------------|-----------|-------------|

## Verification
- No sessions yet
```

**Step 4: Update FIRST_RUN in SKILL.md**

In the FIRST_RUN flow, after "### Step 2: Create state directory and initialize state files", the state files list stays the same (streak.json, scoreboard.md, decisions.md). Do NOT create memory files here.

Update the welcome message in "### Step 3: Display the welcome message" to add one line about memory:

Find this text in SKILL.md:
```
  config/calendar.md   — if you want meeting-aware coaching
```

Add after it:
```

Memory will build automatically after your first session.
The coach gets smarter the more you use it.
```

This is the ONLY change to FIRST_RUN. Memory files (context.md, patterns.md, progress.md) are created at the END of the first real session, not during FIRST_RUN.

**Exit Criteria:**
- `templates/context.md` exists with `# Coach Context` header and all 6 sections
- `templates/patterns.md` exists with `# Coaching Patterns` header and all 6 sections
- `templates/progress.md` exists with `# Progress Evidence` header and 3 sections
- SKILL.md FIRST_RUN welcome message mentions memory
- SKILL.md FIRST_RUN does NOT create state/context.md, state/patterns.md, or state/progress.md

**Required checks:** Verify templates have correct headers. Verify FIRST_RUN step 2 still only creates streak.json, scoreboard.md, decisions.md.
**Checkpoint type:** none
**Allowed scope:** Templates and FIRST_RUN section of SKILL.md only
**Out-of-scope drift:** Do NOT modify session flows (morning/evening/weekly) yet

---

### Phase 3: SKILL.md Memory Operations + Git Sync

**Objective:** Add Step 0 (memory load + git sync) before existing session logic, and Step N (memory write + pattern promotion) after each session type. This is the core of the state layer.

**Files:**
- Modify: `skills/coach/SKILL.md` (multiple sections)

**Step 1: Add Step 0 — Memory Load + Git Sync (before Session Detection)**

Insert a new section BEFORE "## Session Detection" in SKILL.md:

```markdown
## Step 0: Memory Load and Sync

Before any session detection, load the coaching memory layer.

### 0a: Git Sync (if configured)

Read `state/context.md`. If it contains an uncommented line `GIT_SYNC: true` in the `## Session Settings` section:
1. Run `git pull --rebase --quiet` to get latest state from other machines
2. If the pull fails or has conflicts: warn the user "State sync had a conflict. Using local state." and continue
3. Do NOT block the session on sync failure

If `state/context.md` does not exist or `GIT_SYNC` is not set: skip this step silently.

### 0b: Load Memory

Read these files if they exist. If any file does not exist, skip it silently — they will be created at the end of the first session.

1. `state/context.md` — working memory: current focus, last session, next priority, active decisions, founder profile
2. `state/patterns.md` — coaching patterns: what works, avoidance behaviors, scheduling patterns

Use this context to inform ALL coaching decisions this session. Specifically:
- `## Last Session` tells you what happened last time (what was assigned, what was completed)
- `## Next Session Priority` tells you what to focus on today
- `## Active Decisions` tells you which decisions are still live
- `## Founder Profile` tells you the founder's strengths, avoidance patterns, and preferences
- `state/patterns.md` tells you what coaching approaches work and which don't

Do NOT read `state/progress.md` at session start — it's evidence-only, written at session end. Reading it would add overhead without improving coaching quality.

**Speed budget: Step 0 total < 3 seconds** (git pull ~2s if configured, file reads ~1s)
```

**Step 2: Update Morning Session — Add memory-informed coaching**

In the MORNING Session "### Step 1: Read ALL context" section, ADD to the file list:

After the line `- Claude Code native memory — patterns, learnings from past sessions`, add:
```
- `state/context.md` — (already loaded in Step 0) current focus, last session details, founder profile
- `state/patterns.md` — (already loaded in Step 0) coaching patterns and avoidance behaviors
```

In "### Step 3: Generate 3 SPECIFIC actions", update **Action 2 — Gap detection / weakness** to add this reference:

After the line `- Patterns from Claude Code native memory if known ("Third week in a row you skipped Y")`, add:
```
- `state/patterns.md` ## Avoidance Behaviors for known patterns ("You've avoided outreach 4 times — today we tackle it")
- `state/context.md` ## Founder Profile for strengths and avoidance patterns
```

**Step 3: Update Evening Session — Better action recovery**

In the EVENING Session "### Step 2: Reference today's morning actions", replace the note about action recovery:

Find:
```
Note: The specific action text is not stored in streak.json (only `actions_given: 3`). To recover the morning actions, try in this order:
1. Read Claude Code native memory for the actions given this morning.
2. If memory is unavailable, ask the founder directly: "What were your 3 actions this morning?"
Do NOT reconstruct actions from goals and context — this produces plausible-but-wrong actions that confuse the founder.
```

Replace with:
```
To recover the morning actions, try in this order:
1. Read `state/context.md` ## Last Session → `Actions given` field (most reliable — written at end of morning session)
2. If context.md is missing or has no actions: read Claude Code native memory for the actions given this morning
3. If both are unavailable: ask the founder directly: "What were your 3 actions this morning?"
Do NOT reconstruct actions from goals and context — this produces plausible-but-wrong actions that confuse the founder.
```

**Step 4: Add Step N — Memory Write (after each session type)**

Add a new section BEFORE "## Streak Edge Cases" in SKILL.md:

```markdown
## Memory Write (runs at end of every session)

After completing the session-specific steps (morning/evening/weekly) and updating streak.json, write memory updates. If memory files don't exist yet, create them from `templates/context.md`, `templates/patterns.md`, `templates/progress.md`.

### Write 1: Update state/context.md

**After MORNING session:**
- `## Current Focus`: keep existing (from config/goals.md)
- `## Last Session`: update with today's date, type "morning", the 3 actions given as FULL TEXT (not just count — evening session needs the exact wording to ask about completions), "actions_completed: pending", any key observation
- `## Next Session Priority`: set to "Evening check-in: report on today's 3 actions"
- `## Active Decisions`: no change (morning doesn't log decisions)
- `## Founder Profile`: update if new pattern observed this session

**After EVENING session:**
- `## Last Session`: update with today's date, type "evening", actions completed count and list, any decisions logged, key observation
- `## Next Session Priority`: derived from today's gaps — what was missed becomes tomorrow's priority
- `## Active Decisions`: add any new decisions logged, update reviewed ones
- `## Founder Profile`: update if new pattern observed (e.g., "avoids outreach" detected again)

**After WEEKLY session:**
- `## Last Session`: update with today's date, type "weekly", weekly score, top win, biggest gap
- `## Next Session Priority`: next week's top priority from the weekly review
- `## Active Decisions`: update status of reviewed decisions (holding/revisited/changed)
- `## Founder Profile`: update with weekly pattern observations

### Write 2: Check for pattern promotion to state/patterns.md

After updating context.md, check if any observation should be promoted:

**Promotion rule:** If an observation appears in `## Last Session → Key observation` across 3 or more sessions (check state/progress.md session log), promote it to state/patterns.md.

Promotion examples:
- "avoided outreach" appears 3x in session log → add to `## Avoidance Behaviors`: "Outreach avoidance: observed 3+ times — push outreach to Tuesday mornings"
- "completed morning actions but not evening" 3x → add to `## Scheduling Patterns`: "Morning execution strong, evening follow-through weak"
- "responds well to direct challenges" 3x → add to `## Voice Preferences`: "Direct challenges drive action better than gentle suggestions"

If no promotion criteria met, skip this step.

### Write 3: Update state/progress.md

Add a row to the `## Session Log` table:
```
| YYYY-MM-DD | morning/evening/weekly | N | N/N or pending | [one-line insight] |
```

If weekly session: also add an entry to `## Weekly History`:
```
### Week N (Date Range)
- Score: X%
- Top metric: [what]
- Gap metric: [what]
- Streak: X days
- Decisions: N logged, N reviewed
- Pattern: [one-line observation]
```

Trim `## Session Log` to keep only the last 14 days of entries.
Trim `## Weekly History` to keep only the last 8 weeks.

**Speed budget: Memory Write total < 3 seconds** (3 small file writes)
```

**Step 5: Add git sync to Stop sequence**

After the Memory Write section, add:

```markdown
### Git Sync at Session End

If `state/context.md` has `GIT_SYNC: true`:
1. The Stop hook (defined in `hooks/hooks.json`) should automatically run `git add state/ && git commit && git push`
2. However, the `Stop` event may not fire in all scenarios (it is inferred, not proven from all plugins). As a safety net, SKILL.md should also run git sync at session end:
   - `git add state/ && git commit -m "coach session $(date '+%Y-%m-%d %H:%M')" --quiet 2>/dev/null && git push --quiet 2>/dev/null || true`
3. The dual approach (hook + SKILL.md) is safe — if both fire, the second git commit is a no-op (nothing to commit)
```

**Exit Criteria:**
- SKILL.md has Step 0 with Memory Load + Git Sync before Session Detection
- SKILL.md Morning Step 1 references state/context.md and state/patterns.md
- SKILL.md Evening Step 2 tries context.md first for action recovery
- SKILL.md has Memory Write section with Write 1 (context.md), Write 2 (pattern promotion), Write 3 (progress.md)
- SKILL.md has Git Sync at Session End section
- No existing v1 functionality broken (all original steps preserved)

**Required checks:** Read full SKILL.md and verify Step 0 comes before Session Detection. Verify Memory Write comes after session flows but before Streak Edge Cases. Verify morning/evening/weekly flows still have all their original steps.
**Checkpoint type:** none
**Allowed scope:** SKILL.md only
**Out-of-scope drift:** Do NOT modify hooks.json, plugin.json, or templates in this phase

---

### Phase 4: Cron Mode

**Objective:** Add cron mode as a new routing path — passive updates without user interaction.

**Files:**
- Modify: `skills/coach/SKILL.md` (Session Detection + new CRON section)

**Step 1: Add cron detection to routing**

In "### Step 2: Session type detection", add a new rule BEFORE the existing rules 1-6. Insert as the very first check:

Find in SKILL.md:
```
Apply these routing rules **in order** (first match wins). Evaluate EVERY rule from 1 to 6 sequentially
```

Replace with:
```
Apply these routing rules **in order** (first match wins). Evaluate EVERY rule from 0 to 6 sequentially
```

Then insert before rule 1:

```markdown
0. If the user's message contains "cron" (case-insensitive), OR `state/context.md` has an uncommented `CRON_MODE: true` line in `## Session Settings` → **CRON**
```

**Step 2: Add CRON session flow**

Add a new section after "## SETUP_INCOMPLETE Flow" and before "## MORNING Session":

```markdown
## CRON Session

This flow runs in unattended mode — no user interaction, no actions generated. Used for passive state updates (e.g., via scheduled runs).

### Step 1: Read state

Read:
- `state/context.md` — current coaching context (if exists)
- `state/streak.json` — session counter and history
- `state/scoreboard.md` — current week section

If `state/context.md` does not exist: create it from `templates/context.md`.

### Step 2: Increment session count

Add an entry to `state/streak.json` history:
```json
{
  "date": "YYYY-MM-DD",
  "type": "cron",
  "timestamp": "ISO8601 timestamp",
  "actions_given": 0,
  "actions_completed": null
}
```

Cron sessions count toward `total_sessions` but do NOT count toward `current_streak`. The streak only counts morning sessions where the founder actively shows up.

### Step 3: Gap detection (passive)

Analyze state without user interaction:
- Read scoreboard: identify metrics behind target
- Read context.md: identify how many days since last active session
- Read decisions.md: identify decisions older than 7 days without review

### Step 4: Update state/context.md

- `## Last Session`: update with "CRON SESSION" + date
- `## Next Session Priority`: set based on gap detection from Step 3

### Step 5: Update state/progress.md

Add a session log entry with type "cron" and key insight from gap detection.

### Step 6: Git sync

If `GIT_SYNC: true` in context.md:
- `git add state/ && git commit -m "coach cron $(date '+%Y-%m-%d %H:%M')" --quiet && git push --quiet`
- If any step fails: continue silently

### Step 7: Output and STOP

Output a single-line summary to stdout:
```
[CRON] YYYY-MM-DD: [gap summary or "all on track"]. Next priority: [priority].
```

Do NOT generate actions. Do NOT ask questions. STOP.
```

**Exit Criteria:**
- SKILL.md routing rule 0 detects "cron" keyword or `CRON_MODE: true`
- CRON session flow exists between SETUP_INCOMPLETE and MORNING
- CRON flow reads state, increments total_sessions (not streak), updates context.md + progress.md, outputs one line
- CRON flow does NOT generate actions or ask questions
- Running `/coach cron` routes to CRON flow

**Required checks:** Verify routing rules are numbered 0-6 with cron as rule 0. Verify CRON flow has 7 steps. Verify cron does NOT modify `current_streak`.
**Checkpoint type:** none
**Allowed scope:** SKILL.md only (routing + new CRON section)
**Out-of-scope drift:** Do NOT modify morning/evening/weekly flows in this phase

---

### Phase 5: Polish and Integration

**Objective:** Update supporting files, add error handling for memory, verify backward compatibility.

**Files:**
- Modify: `agents/coach.md` (add memory layer rules)
- Modify: `skills/coach/SKILL.md` (error handling section)
- Modify: `.claude-plugin/plugin.json` (version, description — no hooks field)
- Create: `.gitignore` (config/ exclusion for personal data protection)

**Step 1: Update agents/coach.md — Add memory layer rules**

After the existing "## Memory Writing Rules" section, add:

```markdown
## State Layer Memory (v1.1)

In addition to native Claude Code memory, the coach maintains a 3-layer state:

### Layer 1: state/context.md (Working Memory)
- Read at session start (Step 0)
- Write at session end (Memory Write)
- Contains: current focus, last session details, next priority, active decisions, founder profile
- This is the PRIMARY source for session continuity

### Layer 2: state/patterns.md (Coaching Patterns)
- Read at session start (Step 0)
- Write when patterns are promoted (3+ observations)
- Contains: what works, avoidance behaviors, voice preferences, scheduling patterns
- This makes the coach smarter over time

### Layer 3: state/progress.md (Evidence Trail)
- NOT read at session start (overhead without coaching value)
- Write at session end (session log entry)
- Contains: session history, weekly summaries, verification data
- This provides hard evidence for pattern detection and weekly reviews

### Dual Write Rule
Keep writing to BOTH native Claude Code memory AND the state layer:
- Native memory: fuzzy, cross-conversation, auto-retrieved by Claude Code
- State layer: structured, exact, controlled by the coach
- They serve different purposes and both must be maintained
```

**Step 2: Update SKILL.md error handling**

In the "## Error Handling" section, add these entries after the existing 9 rules:

```markdown
10. **state/context.md missing:** Skip memory load in Step 0. Create from `templates/context.md` at session end (Memory Write). This is the normal first-session case — not an error.

11. **state/patterns.md missing:** Skip in Step 0. Create from `templates/patterns.md` when first pattern is promoted. An empty patterns file means the coach hasn't learned enough yet.

12. **state/progress.md missing:** Create from `templates/progress.md` at session end (Memory Write). The first session log entry will be written.

13. **Git sync fails (pull or push):** Warn the user once: "State sync had an issue. Using local state." Continue the session. Never block a coaching session on git operations.

14. **Cron mode with no state files:** Create all memory files from templates, log "first cron session" in progress.md, and continue. Cron should work even on a fresh install.

15. **Memory files corrupted (invalid markdown):** Overwrite from templates. Warn: "Your coaching memory got corrupted. Starting fresh — the coach will relearn your patterns." Continue the session.
```

**Step 3: Update plugin.json**

Update `.claude-plugin/plugin.json`:
- `"version"`: `"1.1.0"`
- `"description"`: add "with compounding memory" — `"Daily AI coaching system for founders with compounding memory. One command (/coach), every morning, 3 actions. Streak tracking, decision log, LinkedIn drafting, strategy framework, and memory that grows smarter over time."`
- Do NOT add a `"hooks"` field — Claude Code discovers `hooks/hooks.json` automatically at plugin root

**Step 3b: Add .gitignore for config/ directory**

Create or update `.gitignore` at plugin root to exclude personal data from git sync:
```
# Personal configuration (contains identity, LinkedIn profile, etc.)
config/
```

This prevents `config/identity.md`, `config/linkedin.md`, and other personal config files from being exposed if the repo is pushed to a public remote with `GIT_SYNC` enabled. The `state/` directory IS tracked (that is the purpose of git sync). The `config/` directory is NOT tracked (user-specific, contains personal data).

**Step 4: Update SKILL.md description frontmatter**

Update the YAML frontmatter `description` field at the top of SKILL.md to mention memory:

Find:
```
description: |
  Daily AI coaching system for founders. Run /coach every morning for 3 specific actions.
  Tracks streaks, logs decisions, drafts LinkedIn posts, and reviews your week.
  Memory compounds over time — day 30 is sharper than day 1.
```

Replace with:
```
description: |
  Daily AI coaching system for founders with 3-layer memory. Run /coach every morning for 3 specific actions.
  Tracks streaks, logs decisions, drafts LinkedIn posts, and reviews your week.
  Memory compounds over time — patterns, evidence, and coaching context persist across sessions.
  Supports cron mode for passive updates and git sync for cross-computer use.
```

**Exit Criteria:**
- agents/coach.md has "## State Layer Memory (v1.1)" section with 3 layers documented
- SKILL.md error handling has rules 10-15 for memory, git sync, and cron edge cases
- plugin.json has version 1.1.0 and updated description (NO hooks field)
- SKILL.md frontmatter description mentions 3-layer memory and cron/git sync
- `.gitignore` exists with `config/` exclusion
- All files are valid (no JSON parse errors, no broken markdown)

**Required checks:** JSON validation of plugin.json. Read agents/coach.md and verify state layer section. Read SKILL.md and verify error handling rules 10-15 exist. Verify `.gitignore` excludes `config/`.
**Checkpoint type:** none
**Allowed scope:** agents/coach.md, SKILL.md (error handling + frontmatter), plugin.json, .gitignore
**Out-of-scope drift:** Do NOT modify session flows or routing logic in this phase

---

## Phase Autonomy Classification
| Phase | Checkpoint Type | Classification | Reason |
|-------|----------------|----------------|--------|
| Phase 1: Hook Infrastructure | none | AFK | Straightforward file creation + JSON edit |
| Phase 2: Memory Templates + FIRST_RUN | none | AFK | Template creation + small SKILL.md edit |
| Phase 3: SKILL.md Memory Operations | none | AFK | Core implementation but all decisions resolved in design |
| Phase 4: Cron Mode | none | AFK | New routing path + session flow, design is complete |
| Phase 5: Polish + Integration | none | AFK | Supporting files, error handling, version bump |

---

## Acceptance Checks

1. **Memory load at start:** Run `/coach` on a repo with existing state/context.md. Verify the coach references content from context.md (last session, founder profile) in its output.
2. **Memory compounds:** Run 3+ morning+evening cycles. Verify state/patterns.md has promoted patterns (avoidance behaviors, scheduling patterns).
3. **Session evidence:** After a morning session, verify state/progress.md has a new row in the Session Log table.
4. **Hooks fire:** Verify `.claude-plugin/hooks/hooks.json` is valid JSON. Verify SessionStart hook would cat context.md. Verify Stop hook checks GIT_SYNC before git operations.
5. **Full session under 2 minutes:** Run a morning session with memory files present. Total time from `/coach` to "Go. Report back tonight." must be under 2 minutes.
6. **State survives restart:** Run morning session, close Claude Code, reopen, run evening session. Verify evening session reads morning's actions from context.md.
7. **Cron mode:** Run `/coach cron`. Verify it outputs one line, updates context.md and progress.md, does NOT generate actions or ask questions, does NOT increment streak.
8. **Git sync:** Set `GIT_SYNC: true` in context.md. Verify Step 0 mentions pull. Verify Stop hook includes git commit+push.
9. **Backward compatibility:** Delete state/context.md, state/patterns.md, state/progress.md. Run `/coach`. Verify session works normally (graceful skip), and memory files are created at session end.
10. **Evening action recovery:** After morning session writes to context.md, verify evening session reads actions from context.md `## Last Session` instead of asking the user.

---

## Risks And Mitigations

| Risk | P | I | Score | Mitigation |
|------|---|---|-------|------------|
| SessionStart hook stdout not visible to Claude | 2 | 4 | 8 | Step 0 reads files explicitly anyway — hook is acceleration, not requirement |
| Stop hook may not fire in all scenarios | 3 | 3 | 9 | SKILL.md also runs git sync at session end as safety net. Dual approach: if both fire, second is no-op. If Stop doesn't fire, SKILL.md handles it. |
| Git push in Stop hook adds latency | 3 | 2 | 6 | Hook is async:true, non-blocking, with `|| true` fallback |
| config/ with personal data exposed via GIT_SYNC | 2 | 4 | 8 | .gitignore excludes config/. Only state/ is git-synced. |
| Pattern promotion logic too aggressive/conservative | 2 | 2 | 4 | 3-observation threshold is tunable. Start conservative, adjust later |
| Memory files grow too large over time | 2 | 3 | 6 | Trimming rules: progress.md keeps 14 days + 8 weeks, context.md keeps last session only |
| Cron mode creates stale state (no user verification) | 2 | 2 | 4 | Cron only updates priority and logs — doesn't make coaching decisions |
| SKILL.md becomes too long (602 → ~800+ lines) | 3 | 2 | 6 | All new sections are modular and clearly separated. Could refactor to includes in v1.2 |
| Hook format incompatible with some Claude Code versions | 2 | 3 | 6 | Hooks are acceleration, not requirements. SKILL.md Step 0 works without hooks |

---

## Context References

### Patterns to Follow
- `skills/coach/SKILL.md` (lines 1-8) — YAML frontmatter format
- `skills/coach/SKILL.md` (lines 20-43) — Session Detection routing pattern (first-match-wins)
- `skills/coach/SKILL.md` (lines 130-145) — Morning Step 1 file reading pattern
- `skills/coach/SKILL.md` (lines 580-602) — Error handling pattern
- `hooks/hooks.json` at plugin root (reference: cc10x at `~/.claude/plugins/marketplaces/cc10x/plugins/cc10x/hooks/hooks.json`, ralph-loop at `~/.claude/plugins/marketplaces/claude-plugins-official/plugins/ralph-loop/hooks/hooks.json`) — Hook JSON format

### Configuration Files
- `.claude-plugin/plugin.json` — Plugin manifest (needs version bump + description update, NO hooks field)
- `agents/coach.md` — Coach persona (needs state layer rules)

### Related Documentation
- `docs/plans/2026-04-04-coach-state-layer-design.md` — Approved design with data structures
- `SPEC.md` — Original product spec (quarterly strategy reset is out of scope)

---

## Summary
- Plan saved: `docs/plans/2026-04-04-coach-state-layer-plan.md`
- Phases: 5
- Risks: 9 identified (2 at score 9, 1 at score 8)
- Key decisions: Hooks at `hooks/hooks.json` plugin root (verified from cc10x + ralph-loop, no plugin.json hooks field), memory files created on first session END (not FIRST_RUN), dual write to native memory + state layer, cron counts total_sessions but not streak, SKILL.md git sync as safety net for Stop hook uncertainty, .gitignore for config/ personal data

### Recommended Skills for BUILD (SKILL_HINTS for Router)
- None required (this is prompt-as-code markdown, no framework-specific skills needed)

### Confidence Score: 85/100
- Context references included with file:line (+25)
- Edge cases documented (15 error handling rules) (+20)
- Test/acceptance checks specific (10 checks with exact scenarios) (+20)
- Risk mitigations defined for all 9 risks (+20)
- File paths exact (+15)
- Hook location verified from 2 real plugins (cc10x + ralph-loop) (+5 vs previous)
- Deduction: Hook stdout injection into Claude context is inferred, not proven (-10)
- Deduction: Stop event may not fire in all scenarios — mitigated by SKILL.md fallback (-5)
- Deduction: Pattern promotion logic is described conceptually, not with exact pseudocode (-5)

**Key Assumptions:**
- SessionStart hook stdout is injected as context visible to Claude (inferred from cc10x pattern)
- `Stop` hook event fires on session end (inferred from ralph-loop usage, but not verified to fire in all scenarios — SKILL.md git sync is safety net)
- `${CLAUDE_PLUGIN_ROOT}` resolves correctly for hook commands (proven by cc10x)
- Hooks at `hooks/hooks.json` at plugin root are auto-discovered (proven from cc10x + ralph-loop — no plugin.json hooks field needed)
