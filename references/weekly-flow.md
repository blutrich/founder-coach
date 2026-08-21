# Weekly Session Flow (Friday, after evening check-in)

This flow runs when it's Friday AND today has an "evening" entry but no "weekly" entry in `state/streak.json` history.

### Step 1: Read full week context

Read all of these:
- `state/scoreboard.md` — full current week: all metrics, all days, all targets
- `state/decisions.md` — this week's decisions (from the Monday of the current scoreboard week through today, matching the `## Week of YYYY-MM-DD` anchor date)
- `config/strategy.md` — for strategy alignment checks
- `config/goals.md` — for goal reference
- Claude Code native memory — patterns observed across weeks

### Step 2: Generate weekly review

#### a. Score

Calculate percentage for each metric in the scoreboard:
- Per metric: `(actual completed this week) / (target) * 100`
- Overall score: average of all metric percentages

Display:
```
This week: [overall]%

| Metric | Target | Actual | Score |
|--------|--------|--------|-------|
| [Metric 1] | [target] | [actual] | [X]% |
| [Metric 2] | [target] | [actual] | [X]% |
| LinkedIn posts | [target] | [actual] | [X]% |
```

#### b. Top win

Identify the highest-performing metric or most impactful completion this week.

"Your best move this week: [specific achievement with context]."

#### c. Biggest gap

Identify the lowest-performing metric or most avoided area.

"Where you slipped: [specific gap]. [Pattern observation if available from native memory — e.g., 'Third week in a row outreach fell short.']"

#### d. Decision review

For each decision logged in `state/decisions.md` this week:
- "You decided [X] on [day]. Still holding?"

If a decision has been revisited 3+ times (check the full decisions.md history for entries with the same `Decision title` text, case-insensitive, or the same `Connected to` goal reference):
- "You've revisited this decision [N] times. Either commit or change it. But stop circling."

This is one of the places the coach asks a question — decision review requires input.

#### e. Strategy alignment

Reference `config/strategy.md` for each section that has uncommented content:

- **Truth:** "Your truth was [X]. Does it still hold?"
- **Assertions:** "Your assertion was [X]. This week's actions moved [toward/away from] it."
- **Alternatives:** "Your alternative was [Y]. Are we closer to needing it?"
- **People:** "You said you need [person/type]. Did you reach out?"
- **Money:** "Your money situation was [X]. Any changes?"
- **Time:** "You said you'd be at [milestone] by [timeline]. [On track / behind / ahead]?"

Skip any section that is still commented out or empty.

#### f. Next week priorities

Generate 3 priorities for next week, derived from:
- Gaps from this week (metrics that underperformed)
- Goals that need acceleration
- Upcoming calendar events (if calendar enabled and accessible)
- Patterns from native memory

Display as numbered list with brief rationale.

#### g. Content prompt

"Ship one post about what you built this week."

If LinkedIn is enabled (`config/linkedin.md` has `enabled: true`):
- "Want me to draft it now? I'll pull from this week's wins."
- If the founder says yes: draft a LinkedIn post following `${CLAUDE_PLUGIN_ROOT}/references/linkedin-guide.md` guidelines, using this week's actual achievements from the scoreboard and decisions as content.

### Step 3: Create new week section in state/scoreboard.md

Archive the current week:
- Keep the current week's table in the file (do not delete it)
- Add a `---` separator below it

Create a fresh table for next week:
- Use the same metrics and targets as the current week (unless goals have changed)
- Reset all day columns to `-`
- Reset Weekly column to `0/[target]`
- Date the new section with next Monday's date

```
---

## Week of YYYY-MM-DD

| Metric | Target | Mon | Tue | Wed | Thu | Fri | Weekly |
|--------|--------|-----|-----|-----|-----|-----|--------|
| [Metric 1] | [target] | - | - | - | - | - | 0/[target] |
| [Metric 2] | [target] | - | - | - | - | - | 0/[target] |
```

### Step 4: Update state/streak.json

Add a new entry for the weekly session:
```json
{
  "date": "YYYY-MM-DD",
  "type": "weekly",
  "timestamp": "ISO8601 timestamp of right now",
  "actions_given": 0,
  "actions_completed": null
}
```

### Step 5: Write to Claude Code native memory

- Write a `feedback` type memory with weekly patterns: what worked, what didn't, completion rate, avoidance patterns.
- Write/update a `project` type memory with updated goal progress and any strategy adjustments.

### Step 6: STOP

Weekly review is complete. Display: "Have a good weekend. The chain picks up Monday." (Or the next work day per `config/identity.md` work_days.)
