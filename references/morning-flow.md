# Morning Session Flow

This flow runs when there is no entry in `state/streak.json` history for today's date.

### Step 1: Read ALL context

Read every file below. If a file does not exist or is empty, skip it silently — only `config/goals.md` is required.

- `config/goals.md` — **required** — extract all uncommented `goal_N:` lines and their values
- `config/identity.md` — strengths, weaknesses, role, work_days
- `config/strategy.md` — assertions, truth, alternatives, people, money, time
- `config/linkedin.md` — check if `enabled: true` is uncommented
- `config/calendar.md` — check if `enabled: true` is uncommented
- `references/voice-guide.md` — signature phrases, anti-slop rules, reframing scripts, personality hooks
- `agents/godin.md` — Seth Godin: strategy, systems, goal alignment
- `agents/wood.md` — Jenny Wood: visibility, courage, hard conversations
- `agents/hormozi.md` — Alex Hormozi: offers, pricing, sales, revenue
- `agents/cagan.md` — Marty Cagan: product, discovery, shipping, validation
- `state/streak.json` — current streak count and history
- `state/scoreboard.md` — current week's progress
- `state/decisions.md` — recent decisions
- Claude Code native memory — patterns, learnings from past sessions
- `state/context.md` — (already loaded in Step 0) current focus, last session details, founder profile
- `state/patterns.md` — (already loaded in Step 0) coaching patterns and avoidance behaviors

### Step 2: Calendar + Gmail check (optional)

**Calendar:** If `config/calendar.md` has an uncommented `enabled: true` line:
- Attempt to read today's calendar using the Google Calendar MCP tool
- If the MCP tool is unavailable or errors: **skip silently** — do not display any error, do not mention calendar at all
- If available and returns data: note today's meetings, prep needs, and deep work windows for use in action generation

**Gmail:** If `config/identity.md` has an uncommented `gmail: true` line:
- Attempt to scan recent inbox using Gmail MCP (search for unread or flagged messages from last 2 days)
- If the MCP tool is unavailable or errors: **skip silently**
- If available: note threads needing replies, follow-ups on outreach, and anything time-sensitive for use in action generation
- Use in Action 2 (gap detection): "You emailed [person] 3 days ago with no reply. Follow up today."

### Step 3: Generate 3 SPECIFIC actions

Generate exactly 3 actions. Each must be specific enough to complete in one sitting and must connect to a stated goal from `config/goals.md`.

**Expert routing:** For each action, pick the expert whose domain matches the action type (see `agents/coach.md ## Expert Routing`). Write the action in that expert's voice. Tag each action with the expert name so the founder knows who's talking.

**Action 1 — Highest priority from goals:**
Pick the goal that moves the needle most today. Consider:
- What's most urgent or time-sensitive
- What has the most impact on the founder's stated goals
- If calendar data is available and shows an empty morning: flag deep work opportunity
- If calendar shows meetings: adjust the action around the schedule

**Action 2 — Gap detection / weakness:**
Identify what's behind schedule, what's been avoided, or what's slipping. Reference:
- `config/identity.md` weakness field if available ("You said you avoid X — today we tackle it")
- `state/scoreboard.md` for metrics that are behind target
- Patterns from Claude Code native memory if known ("Third week in a row you skipped Y")
- `state/patterns.md` ## Avoidance Behaviors for known patterns ("You've avoided outreach 4 times — today we tackle it")
- `state/context.md` ## Founder Profile for strengths and avoidance patterns
- If no gap data is available yet (identity.md empty, scoreboard fresh, no memory): focus on a different angle of the same goal — e.g., planning, research, or preparation rather than execution

**Action 3 — LinkedIn/content OR second goal action:**
- If `config/linkedin.md` has `enabled: true` uncommented: generate a LinkedIn action (draft a post, publish, or engage). Reference the founder's expertise, audience, and tone from linkedin.md.
- If LinkedIn is NOT enabled: generate a second goal-aligned action instead (different goal than Action 1 if possible, or a different angle on the same goal).

**Rules for all actions:**
- Each action must be specific enough to complete in one sitting
- Each action must connect to a stated goal
- Reference past decisions if relevant: "You decided X — today's action aligns with that"
- Reference patterns if known: "You tend to avoid Y — today we tackle it"
- If calendar shows meetings: adjust actions around the schedule
- If calendar shows an empty day: flag the deep work opportunity

### Step 4: Display output in coach voice

Follow the personality and tone rules from `agents/coach.md` and `references/voice-guide.md`. Use signature phrases naturally. Apply personality hooks based on context (Systems Thinker for ad-hoc problems, Pattern Caller for recurring behavior, Closer for deliberation, Realist for goal-action gaps). If founder's context.md shows avoidance patterns, use matching reframing scripts from voice-guide.md.

**Before displaying:** Run the 5-point guardian self-check. If any check fails, rewrite.

Structure the output as:

1. **Streak line:** "Day {N}." followed by streak commentary.
   - Day 1: "Day 1. Let's go."
   - Day 2-7: brief acknowledgment ("Day 5. Building momentum.")
   - Day 10+: reference the streak itself ("Day 23. The chain doesn't break.")
   - If streak was broken and restarting: "Day 1 again. The chain starts now."

2. **Brief context** (1-2 sentences): Reference what the coach knows — recent decisions, this week's scoreboard, patterns from memory. Ground the founder in their own data.

3. **The 3 actions** (numbered, specific, with brief rationale for each):
   ```
   1. [Action 1] — [brief rationale connecting to goal]
   2. [Action 2] — [brief rationale, reference gap/weakness]
   3. [Action 3] — [brief rationale, LinkedIn or goal-aligned]
   ```

4. **Closing:** "Go. Report back tonight."

### Step 4b: Persist morning actions immediately

Right after displaying the 3 actions, write them to `state/context.md` `## Last Session → Actions given` as FULL TEXT. Do this NOW, before streak update — if the session crashes after this point, the evening session can still recover the actions.

If `state/context.md` does not exist yet, create it from `templates/context.md` first.

### Step 5: Update state/streak.json

After displaying the morning output, update the streak file. Follow the **Streak Update Rules** below.

Add a new entry to the `history` array:
```json
{
  "date": "YYYY-MM-DD",
  "type": "morning",
  "timestamp": "ISO8601 timestamp of right now",
  "actions_given": 3,
  "actions_completed": null
}
```

Update the streak counters using these rules:

1. **Same-day re-run:** If `history` already has an entry for today with `"type": "morning"` — do NOT add a duplicate entry, do NOT increment any counters. The routing in Step 2 should have sent this to EVENING, but as a safety net: skip the update and do not double-count.

2. **Continuing streak:** If `last_session` date was the previous work day (see **Weekend Handling** in SKILL.md), increment `current_streak` by 1.

3. **Streak broken:** If `last_session` is older than the previous work day, reset `current_streak` to 1. The streak broke because a work day was missed.

4. **First ever session:** If `first_session` is null, set it to today's date.

5. **Always:** Set `last_session` to today's date. Increment `total_sessions` by 1.

6. **Record update:** If `current_streak` > `longest_streak`, update `longest_streak`.

### Step 6: Write to Claude Code native memory

- If this is the first session ever (`total_sessions` was 0 before this session): write a `user` type memory with the founder profile from `config/identity.md` (see `agents/coach.md` for the exact frontmatter format).
- Write or update a `project` type memory with the current active goals from `config/goals.md`.

### Step 7: STOP

Morning session is complete. Do not proceed to evening or weekly.
