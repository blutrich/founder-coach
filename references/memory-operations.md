# Memory Operations

## Memory Write (runs at end of every session)

After completing the session-specific steps (morning/evening/weekly) and updating streak.json, write memory updates. If memory files don't exist yet, create them from `templates/context.md`, `templates/patterns.md`, `templates/progress.md`.

### Signal vs Noise Filter (apply to ALL memory writes)

Before writing anything to memory, ask: "Would a future coaching session need this to make a better decision?" Only persist:
- **Decisions** the founder made (and why)
- **Patterns** observed (avoidance, completion timing, energy levels)
- **Breakthroughs** — moments where the founder shifted perspective
- **Action outcomes** — what was completed, what was skipped, and why

Do NOT persist:
- Mechanical session transcripts ("I read these files, then I generated actions")
- Generic observations ("The founder seems motivated today")
- Restatements of config data (goals are already in goals.md)
- Anything the coach can re-derive from existing state files

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

**Promotion rule:** Use canonical tags for observations. When writing `## Last Session → Key observation` in context.md, use a bracketed tag like `[outreach-avoidance]`, `[evening-followthrough-weak]`, `[responds-to-direct-challenges]`. Write the same tag in the progress.md session log `Key Insight` column.

To count: search the progress.md `## Session Log` for exact tag matches (case-insensitive). If a tag appears in 3 or more rows, promote to state/patterns.md.

Promotion examples:
- `[outreach-avoidance]` appears 3x in session log → add to `## Avoidance Behaviors`: "Outreach avoidance: observed 3+ times — push outreach to Tuesday mornings"
- `[evening-followthrough-weak]` 3x → add to `## Scheduling Patterns`: "Morning execution strong, evening follow-through weak"
- `[responds-to-direct-challenges]` 3x → add to `## Voice Preferences`: "Direct challenges drive action better than gentle suggestions"

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

## Scoreboard Initialization (runs once, when first morning session detects empty scoreboard)

When the first morning session runs and `state/scoreboard.md` has no week section with actual metric rows (only template content or is empty), initialize it:

### Step 1: Extract metrics from goals

Read `config/goals.md` — for each uncommented `goal_N:` line, infer a trackable weekly metric. The coach translates goals into measurable actions:

- Revenue/growth goal (e.g., "Hit 10K MRR") → "Outreach actions" with target 5/week
- Shipping goal (e.g., "Ship v2 by April 30") → "Dev tasks completed" with target 5/week
- Learning goal (e.g., "Learn system design") → "Study sessions" with target 3/week
- Generic goal → infer the most actionable weekly metric

### Step 2: Check LinkedIn

Read `config/linkedin.md` — if `enabled: true` is uncommented, add "LinkedIn posts" as a metric. Use the `posting_goal` value if set, otherwise default to 3/week.

### Step 3: Create week section

Write the current week's section into `state/scoreboard.md`:

```
## Week of YYYY-MM-DD

| Metric | Target | Mon | Tue | Wed | Thu | Fri | Weekly |
|--------|--------|-----|-----|-----|-----|-----|--------|
| [Goal 1 metric] | [target] | - | - | - | - | - | 0/[target] |
| [Goal 2 metric] | [target] | - | - | - | - | - | 0/[target] |
| LinkedIn posts | [posting_goal or 3] | - | - | - | - | - | 0/[target] |
```

Only include the LinkedIn row if LinkedIn is enabled. Include one row per active goal.

## Git Sync at Session End

If `state/context.md` has `GIT_SYNC: true`:
1. The Stop hook (defined in `hooks/hooks.json`) should automatically run `git add state/ && git commit && git push`
2. However, the `Stop` event may not fire in all scenarios (it is inferred, not proven from all plugins). As a safety net, SKILL.md should also run git sync at session end:
   - `git add state/ && git commit -m "coach session $(date '+%Y-%m-%d %H:%M')" --quiet 2>/dev/null && git push --quiet 2>/dev/null || true`
3. The dual approach (hook + SKILL.md) is safe — if both fire, the second git commit is a no-op (nothing to commit)
