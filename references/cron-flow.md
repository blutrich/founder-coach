# CRON Session Flow

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

Cron sessions do NOT modify `current_streak` or `total_sessions`. The streak and session count only track interactive sessions where the founder actively shows up. Cron entries in history have `"type": "cron"` — they are metadata only, not session counts.

**Important:** Cron and interactive sessions must not run concurrently. If a cron job is scheduled, ensure it does not overlap with typical /coach usage times.

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
