# Streak Rules, Recovery, and Error Handling

Read this when computing a streak, when `state/streak.json` is missing or corrupt, or when any file read fails.

## Streak Edge Cases

### Weekend Handling

The streak does NOT break over weekends. Work days are determined by the `work_days` field in `config/identity.md`:

- If `work_days` is uncommented and set (e.g., `work_days: Sun-Thu` or `work_days: Mon-Fri`): use those days as work days.
- If `work_days` is not set or commented out: default to **Mon-Fri**.

When calculating whether the streak continues:
- "Previous work day" means the last day that is a work day before today.
- If `last_session` matches the previous work day, the streak continues.
- If `last_session` is older than the previous work day, the streak is broken.

Example: Last session was Friday. Today is Monday. Work days are Mon-Fri. Monday's previous work day is Friday → streak continues.

Example: Last session was Thursday. Today is Monday. Monday's previous work day is Friday, but last session was Thursday (missed Friday) → streak broken, reset to 1.

Example: Work days are Sun-Thu. Sunday's previous work day is Thursday (Fri+Sat skipped). If `last_session` was Thursday and today is Sunday → streak continues.

If `work_days` format is not a recognized range, default to Mon-Fri.

### Multiple Runs Same Day

Only the first morning run counts. Subsequent runs route to evening. Never double-count.

### Streak Recovery (Corrupted or Missing streak.json)

If `state/streak.json` does not exist or fails to parse as valid JSON:

1. Recreate with initial empty state (zeroed counters, empty history)
2. Warn: "Your streak data got corrupted. Starting fresh. The chain starts now."
3. Continue with the session as normal (Day 1).

---

## Error Handling

Handle gracefully — never crash, never leave the founder without a session.

1. **streak.json corrupted/missing:** Recreate from empty state. Warn and continue.
2. **goals.md empty after first run:** Route to SETUP_INCOMPLETE.
3. **Calendar MCP unavailable:** Skip silently. Never error on missing calendar.
4. **No native memory access:** Coach works from config + state files alone.
5. **Session type ambiguous:** Default to MORNING.
6. **Multiple /founder-coach same session type:** Allow re-run. No double-counting.
7. **scoreboard.md missing/corrupted:** Recreate using Scoreboard Initialization (see `${CLAUDE_PLUGIN_ROOT}/references/memory-operations.md`).
8. **decisions.md missing:** Recreate empty with header. Continue.
9. **Config file missing (not goals):** Skip gracefully. Only goals.md is required.
10. **state/context.md missing:** Skip memory load. Create at session end.
11. **state/patterns.md missing:** Skip. Create when first pattern is promoted.
12. **state/progress.md missing:** Create at session end from template.
13. **Git sync fails:** Warn once. Continue. Never block on git.
14. **Cron mode with no state files:** Create from templates. Continue.
15. **Memory files corrupted:** Overwrite from templates. Warn and continue.
