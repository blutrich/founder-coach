# Founder Coach v1.1 — State Layer Design

## Purpose
Upgrade the founder-coach plugin with cc10x-inspired state persistence so the coach compounds over time. Memory, hooks, evidence, and workflow state — but optimized for speed. The coach must feel instant (under 2 minutes for a full session).

## Users
Founders using Claude Code who run /coach daily.

## Success Criteria
- [ ] Coach reads memory at session start and writes at session end — automatically
- [ ] Memory compounds: day 30 coaching is measurably sharper than day 1
- [ ] Session evidence captured: what was assigned, what was completed, patterns observed
- [ ] Hooks handle boilerplate: auto-detect context, auto-save state, auto-sync
- [ ] Full /coach session still completes in under 2 minutes
- [ ] State survives session restarts / compaction / new conversations
- [ ] Cron mode runs passive updates without user interaction
- [ ] Cross-computer sync via git push/pull
- [ ] No multi-agent routing — single coach persona handles everything

## Constraints
- SPEED IS #1. Every file read, every hook, every state update must justify its existence.
- No multi-agent routing (deferred — single agents/coach.md persona)
- Must be backward-compatible with v1 (existing config/state files still work)
- Everything local, no external services
- Plugin format (hooks live in .claude-plugin/)

## Out of Scope
- Multi-agent routing (specialist agents like Robbins, Hormozi, etc.)
- Landing page (separate effort)
- Marketing packaging (separate effort)
- Knowledge base / wiki compilation (v2)

## Approach Chosen
Full cc10x-style 3-layer state with hooks, adapted for coaching speed.

The key insight from cc10x: **state persistence is not about complexity — it's about never losing context.** The 3-layer model (working memory + patterns + evidence) maps perfectly to coaching:

| cc10x Layer | Coach Equivalent | Purpose |
|-------------|-----------------|---------|
| activeContext.md | state/context.md | What's happening now: current goals focus, last session, next priority, active decisions |
| patterns.md | state/patterns.md | What the coach has learned: avoidance behaviors, effective actions, voice preferences, scheduling patterns |
| progress.md | state/progress.md | Evidence: session history, scoreboard snapshots, verification (what worked, what didn't) |

## Architecture

### State Layer (3 files + existing state files)

```
state/
├── context.md          # NEW — working memory (cc10x activeContext equivalent)
├── patterns.md         # NEW — coaching patterns learned (cc10x patterns equivalent)
├── progress.md         # NEW — evidence trail (cc10x progress equivalent)
├── streak.json         # EXISTING — session counter + history
├── scoreboard.md       # EXISTING — weekly targets vs actuals
└── decisions.md        # EXISTING — timestamped decision log
```

### Hooks (in .claude-plugin/)

```
.claude-plugin/
├── plugin.json         # EXISTING — updated with hooks reference
├── marketplace.json    # EXISTING
└── hooks/
    └── hooks.json      # NEW — hook definitions
```

### Updated SKILL.md Flow

```
/coach →
  [Hook: SessionStart — pre-loads state/context.md into session]
  1. SKILL.md reads pre-loaded context (instant — already in memory)
  2. Session detection (existing logic)
  3. Session execution (morning/evening/weekly)
  4. Write memory updates to state/context.md + state/patterns.md
  5. Write evidence to state/progress.md
  [Hook: Stop — auto-commit + push if git configured]
```

## Components

### 1. state/context.md (Working Memory)

```markdown
# Coach Context
<!-- Read at session start. Write at session end. -->

## Current Focus
[What the founder is working toward right now]

## Last Session
- Date: YYYY-MM-DD
- Type: morning|evening|weekly
- Actions given: [list]
- Actions completed: [list or pending]
- Decisions logged: [any]
- Key observation: [one-line insight]

## Next Session Priority
[What to focus on next time — derived from gaps, patterns, urgency]

## Active Decisions
[Decisions that are still live and should be reviewed weekly]
- YYYY-MM-DD: [decision] — Status: [holding|revisited|changed]

## Founder Profile (evolves over time)
- Strengths: [observed from completions]
- Avoidance patterns: [observed from skips]
- Best time for deep work: [inferred from calendar + completions]
- Communication style: [how they respond to the coach]

## Session Settings
# CRON_MODE: false
# GIT_SYNC: false
# CALENDAR_MCP: false
```

### 2. state/patterns.md (Coaching Patterns)

```markdown
# Coaching Patterns
<!-- Accumulated learnings. Promotes from context.md when repeated 3+ times. -->

## What Works
- [Pattern]: [Evidence from sessions]

## What Doesn't Work
- [Anti-pattern]: [What happened when tried]

## Avoidance Behaviors
- [Behavior]: [How often observed] — [Best coaching response]

## Action Effectiveness
- [Action type]: [Completion rate] — [When it works best]

## Voice Preferences
- [How the founder responds to direct vs gentle coaching]
- [Whether they prefer morning energy or evening reflection]

## Scheduling Patterns
- [Best days for different session types]
- [Calendar patterns that affect completion]
```

### 3. state/progress.md (Evidence Trail)

```markdown
# Progress Evidence
<!-- Hard data. Not opinions. -->

## Weekly History
[Rolling 8-week summary — older weeks trimmed]

### Week N (Date Range)
- Score: X%
- Top metric: [what]
- Gap metric: [what]
- Streak: X days
- Decisions: N logged, N reviewed
- Pattern: [one-line observation]

## Session Log (Last 14 days)
| Date | Type | Actions Given | Completed | Key Insight |
|------|------|---------------|-----------|-------------|
| YYYY-MM-DD | morning | 3 | 2/3 | Avoided outreach again |

## Verification
- [command or check] → [result]
```

### 4. Hooks

**hooks/hooks.json:**
```json
{
  "hooks": [
    {
      "event": "SessionStart",
      "command": "cat state/context.md 2>/dev/null || echo 'NO_CONTEXT'",
      "description": "Pre-load coaching context for faster session start"
    },
    {
      "event": "Stop",
      "command": "cd \"$(git rev-parse --show-toplevel 2>/dev/null)\" && git add state/ && git commit -m \"coach session $(date '+%Y-%m-%d %H:%M')\" --quiet 2>/dev/null && git push --quiet 2>/dev/null || true",
      "description": "Auto-save state and sync on session end"
    }
  ]
}
```

Note: Hooks are MINIMAL. SessionStart just cats a file. Stop just commits+pushes. No complex Python scripts. If they fail, the skill still works — hooks are acceleration, not requirements.

### 5. Cron Mode

Add to SKILL.md routing:

```
### CRON_MODE Detection
If arguments contain "cron" or "CRON_MODE", or state/context.md has CRON_MODE: true:

1. Read state/context.md + state/streak.json + state/scoreboard.md
2. Increment /coach session count (cron = showing up)
3. Read today's activity (from scoreboard, decisions)
4. Update state/context.md:
   - ## Last Session: "CRON SESSION" + date
   - ## Next Session Priority: based on gap detection
5. Update state/progress.md session log
6. Git commit + push
7. Output one-line summary to stdout
8. STOP. No actions generated. No user interaction.
```

### 6. Cross-Computer Sync

Add to SKILL.md Step 0 (before session detection):

```
### Step 0: Sync (if git configured)
If state/context.md has GIT_SYNC: true:
1. git pull --rebase --quiet (get latest from other machines)
2. If conflict: warn user, continue with local state
3. At session end (or via Stop hook): git add state/ && git commit && git push
```

### 7. SKILL.md Memory Operations

**At session START (add before Step 1):**
```
### Step 0: Load Memory
Read state/context.md (if exists — skip silently if not, first-run creates it)
Read state/patterns.md (if exists)
Use this context to inform all coaching decisions this session.
```

**At session END (add after scoreboard/streak updates):**
```
### Step N: Update Memory
1. Update state/context.md:
   - ## Last Session: date, type, actions, completions, observation
   - ## Next Session Priority: derived from today's gaps
   - ## Active Decisions: add any new, update reviewed ones
   - ## Founder Profile: update if new pattern observed

2. Check for pattern promotion:
   - If an observation appears in ## Last Session 3+ times across sessions → promote to state/patterns.md
   - Examples: "avoided outreach" 3x → patterns.md ## Avoidance Behaviors
   - "completed morning actions but not evening" 3x → patterns.md ## Scheduling Patterns

3. Update state/progress.md:
   - Add row to ## Session Log
   - If weekly review: add ## Weekly History entry, trim entries older than 8 weeks
```

## Data Flow

```
/coach invoked
    ↓
[Hook: SessionStart — cats context.md into session]
    ↓
SKILL.md Step 0: Read context.md + patterns.md (memory loaded)
    ↓
SKILL.md Step 1: Read config/* + state/* (existing logic)
    ↓
Session routing + execution (existing logic, but now INFORMED by memory)
    ↓
SKILL.md Step N: Write context.md + patterns.md + progress.md
    ↓
SKILL.md Step N+1: Update streak.json + scoreboard.md (existing logic)
    ↓
[Hook: Stop — git commit + push]
```

## Error Handling

| Scenario | Handling |
|----------|----------|
| context.md missing | Skip memory load, create on first session end (backward compatible) |
| patterns.md missing | Skip, create when first pattern promoted |
| progress.md missing | Skip, create on first session end |
| Git sync conflict | Warn user, continue with local state, don't block session |
| Hook fails | Session still works — hooks are acceleration, not requirements |
| Cron mode + no state files | Create initial state files, log "first cron session" |
| Memory files too large | Trim: context.md keeps last session only, progress.md keeps 8 weeks, patterns.md is append-only but small |

## Speed Budget

| Operation | Target | Notes |
|-----------|--------|-------|
| Hook: SessionStart (cat context.md) | <1s | Single file cat |
| Step 0: Read memory (2 files) | <2s | ~200 lines total |
| Step 1: Read config+state (existing) | <3s | Already in v1 |
| Session execution | <90s | The actual coaching (LLM generation) |
| Step N: Write memory (3 files) | <3s | Small edits |
| Hook: Stop (git commit+push) | <5s | Background, non-blocking |
| **Total overhead from state layer** | **<6s** | On top of existing session time |

## Questions Resolved
- Q: Full cc10x or lightweight? A: Full 3-layer, but optimized for speed (no workflow JSON, no task graphs)
- Q: Multi-agent? A: No — deferred. Single coach persona.
- Q: Cron mode? A: Yes — passive updates without user interaction
- Q: Cross-computer sync? A: Yes — git-based, controlled by GIT_SYNC setting
- Q: Landing page? A: Separate effort, not this upgrade
- Q: Backward compatible? A: Yes — missing memory files are created on first session end
