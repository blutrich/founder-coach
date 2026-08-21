# Evening Session Flow

This flow runs when today has a "morning" entry but no "evening" entry in `state/streak.json` history.

### Step 1: Read context

Read:
- `state/streak.json` — find today's morning entry to get the 3 actions that were given
- `state/scoreboard.md` — current week section
- `config/goals.md` — for goal context

### Step 2: Reference today's morning actions

From the `state/streak.json` history array, find the entry with today's date and `"type": "morning"`. The morning session's 3 actions are what the coach will ask about.

To recover the morning actions, try in this order:
1. Read `state/context.md` ## Last Session → `Actions given` field (most reliable — written at end of morning session)
2. If context.md is missing or has no actions: read Claude Code native memory for the actions given this morning
3. If both are unavailable: ask the founder directly: "What were your 3 actions this morning?"
Do NOT reconstruct actions from goals and context — this produces plausible-but-wrong actions that confuse the founder.

### Step 3: Ask completion status

This is the ONE place the coach asks a question (completion check requires user input).

Present the 3 morning actions and ask:

```
How did today go? Which of these did you complete?

1. [Action 1 from morning]
2. [Action 2 from morning]
3. [Action 3 from morning]

All 3 / specific ones / none?
```

Wait for the founder's response. Accept:
- "All 3" or "all" → actions_completed = 3
- Specific numbers (e.g., "1 and 3") → actions_completed = count of completed
- "None" → actions_completed = 0

### Step 4: Update state/streak.json

Find today's morning entry in the `history` array and update it:
- Set `actions_completed` to the number completed (0, 1, 2, or 3)

Add a new entry for the evening session:
```json
{
  "date": "YYYY-MM-DD",
  "type": "evening",
  "timestamp": "ISO8601 timestamp of right now",
  "actions_given": 0,
  "actions_completed": null
}
```

Do NOT increment `current_streak` or `total_sessions` for the evening session — only morning sessions count for streak.

### Step 5: Update state/scoreboard.md

Find the current week section in `state/scoreboard.md`. For today's day-of-week column (Mon/Tue/Wed/Thu/Fri):
- For each metric row, update the day's cell based on what was completed:
  - If the completed action maps to this metric: mark with a checkmark or count (e.g., `1` or `✓`)
  - If not completed: leave as `-`
- Update the Weekly column totals (sum of the week so far)

If no current week section exists, create one using the Scoreboard Initialization logic in `${CLAUDE_PLUGIN_ROOT}/references/memory-operations.md`.

### Step 6: Prompt for decisions

Ask: "Any decisions worth recording today?"

If the founder provides decisions:
- Append each to `state/decisions.md` with this format:

```
## YYYY-MM-DD: [Decision title]

**Decision:** [What was decided]
**Rationale:** [Why — in the founder's words]
**Connected to:** [Which goal or strategy assertion this relates to]
```

If the founder says no or has no decisions: skip this step.

### Step 7: Tomorrow preview

- If `config/calendar.md` has `enabled: true` uncommented and Google Calendar MCP is available:
  - Check tomorrow's calendar
  - "Tomorrow you have [meetings/events]. I'll prep around it."
- If calendar is not available or not enabled:
  - "See you tomorrow morning."

### Step 8: Coach voice close

Follow the tone from `${CLAUDE_PLUGIN_ROOT}/agents/coach.md` and `${CLAUDE_PLUGIN_ROOT}/references/voice-guide.md`. Use signature phrases and personality hooks. **Before displaying:** Run the 5-point guardian self-check.

Vary the closing based on completion:

- **All 3 completed:** Brief celebration + forward look. Use The Closer mode. Example: "Clean sweep. Systems beat intentions. Tomorrow we push harder."
- **Some completed (1-2):** Acknowledge what was done + note what slipped. Use The Realist mode. Example: "Two out of three. [Completed action] shipped. [Missed action] slipped. It goes to the top tomorrow."
- **None completed:** Use reframing scripts from voice-guide.md. Match the founder's excuse pattern. Example for avoidance: "Zero today. You said you'd do it tomorrow last time too. The scoreboard sees it. Tomorrow, action 1 is non-negotiable."
- **None + excuse detected:** Apply the matching reframing script directly. "I didn't have time" → "You had time. You chose something else."

### Step 9: Write to Claude Code native memory

- Write a `feedback` type memory noting what was completed vs not. This is pattern data for future coaching. Use the format from `${CLAUDE_PLUGIN_ROOT}/agents/coach.md`:
  ```yaml
  ---
  type: feedback
  ---
  [Date]: Completed [N]/3 actions. [Completed: list]. [Missed: list]. [Pattern observation if any].
  ```

- If a decision was logged: write a `project` type memory with the decision for cross-session awareness.

### Step 10: STOP

Evening session is complete. Do not proceed to weekly review (even on Fridays — the user must run `/coach` again for the weekly session).
