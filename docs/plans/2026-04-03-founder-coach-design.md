# Founder Coach — Design

## Purpose
Daily AI coaching system for founders. One command (`/coach`), every morning, 3 actions. Accountability with memory that compounds over time.

## Users
Tech founders who use Claude Code. First 10 from Esner community (Monday.com founders).

## Success Criteria
- [ ] Install in under 30 seconds
- [ ] First session delivers value in under 2 minutes
- [ ] Streak tracking works across sessions
- [ ] Memory persists and improves coaching over time
- [ ] LinkedIn post generation works on first try
- [ ] Calendar integration optional but functional
- [ ] Decision log captures and resurfaces decisions
- [ ] Weekly review gives real percentage scores
- [ ] Personality feels like a real coach, not a chatbot
- [ ] 10 founders can install and use independently

## Constraints
- Claude Code plugin (not standalone app)
- No external dependencies or services
- No hosting, no accounts, no subscriptions
- 2-day build timeline (Passover)
- Everything local — zero data collection
- Calendar is optional (Google Calendar MCP)

## Out of Scope
- Nothing deferred — all features in v1 per user decision
- No web UI, no mobile app
- No multi-user features (each founder has their own install)
- No analytics/telemetry

## Approach Chosen
**Claude Code plugin** with a single `/coach` skill and internal session-type routing. One command, auto-detects morning/evening/weekly/first-run.

Why: Preserves the spec's "one command" UX. Plugin format allows proper packaging, distribution, and marketplace listing.

## Architecture

### Plugin Structure
```
founder-coach/
├── plugin.json                # Plugin manifest
├── skills/
│   └── coach/
│       └── SKILL.md           # Routing engine — the brain
├── agents/
│   └── coach.md               # Persona + behavior rules
├── config/                    # User-editable (created on first run)
│   ├── goals.md               # 1-3 quarterly goals (REQUIRED)
│   ├── strategy.md            # 6-section Godin strategy framework
│   ├── identity.md            # Who you are, strengths, weaknesses
│   ├── linkedin.md            # Content creation config
│   └── calendar.md            # Calendar integration config
├── state/                     # Auto-managed (created on first run)
│   ├── scoreboard.md          # Weekly targets vs actuals
│   ├── decisions.md           # Timestamped decision log
│   └── streak.json            # Streak counter + session history
├── references/
│   ├── linkedin-guide.md      # Post creation + voice calibration
│   └── godin-principles.md    # System thinking coaching prompts
└── templates/
    ├── scoreboard.md          # Weekly tracking template
    └── decisions.md           # Decision entry template
```

### Session Detection (SKILL.md routing)
```
/coach →
  1. No config/goals.md?           → FIRST_RUN
  2. Goals all commented/empty?    → SETUP_INCOMPLETE
  3. Check streak.json.last_session:
     a. No session today           → MORNING
     b. Morning done, not evening  → EVENING
     c. Friday + evening done      → WEEKLY
     d. Friday + no session yet    → MORNING (weekly after evening)
```

### Session type stored in streak.json
Each session history entry records:
```json
{
  "date": "2026-04-03",
  "type": "morning|evening|weekly",
  "timestamp": "2026-04-03T08:30:00Z",
  "actions_given": 3,
  "actions_completed": null
}
```

Evening session updates the morning entry's `actions_completed` field.

## Components

### 1. SKILL.md (Router)
- Reads state/streak.json to detect session type
- Reads all config/* files for user context
- Reads state/* for current tracking data
- Branches to appropriate session flow
- References agents/coach.md for personality
- References references/* for coaching principles

### 2. agents/coach.md (Persona)
- Voice rules: tells don't ask, brief celebration, pattern calling
- Godin-style insights: systems thinking, smallest viable audience
- Example responses for tone calibration
- Rules for action generation (always 3, always specific, always tied to goals)

### 3. Config Files (User-Editable)
- Created on FIRST_RUN with commented templates
- User uncomments and fills in
- goals.md is REQUIRED — others optional
- Self-documenting (comments explain every field)

### 4. State Files (Auto-Managed)
- streak.json: exact counter, can't be "approximately"
- scoreboard.md: weekly targets vs actuals table
- decisions.md: timestamped log, coach reviews weekly

### 5. References (Static Knowledge)
- linkedin-guide.md: voice calibration, post structure, audience targeting
- godin-principles.md: coaching philosophy, system thinking prompts

### 6. Templates (Scaffolding)
- scoreboard.md: weekly tracking template for new weeks
- decisions.md: decision entry format

## Data Flow

### Morning Session
```
Read: config/* → state/streak.json → state/scoreboard.md → state/decisions.md
      → Claude Code native memory (patterns, learnings)
      → Google Calendar (if config/calendar.md enabled)

Generate: 3 actions tied to goals
  - Action 1: highest priority from goals
  - Action 2: gap detection (what's behind/avoided)
  - Action 3: LinkedIn action (draft/publish/engage)

Write: state/streak.json (new session entry)
```

### Evening Session
```
Read: state/streak.json (today's morning entry) → state/scoreboard.md

Prompt: "What did you complete?" (All / Some / None)

Update: streak.json.actions_completed
        state/scoreboard.md (actuals)

Prompt: "Any decisions worth recording?"

Write: state/decisions.md (new entries)
       Claude Code native memory (patterns learned)
```

### Weekly Session (Friday)
```
Read: state/scoreboard.md (full week) → state/decisions.md (week's decisions)
      → config/strategy.md (for strategy alignment check)

Generate:
  - Score: percentage against targets
  - Top win + biggest gap
  - Decision review: "You decided X. Still holding?"
  - Next week's 3 priorities
  - Strategy alignment: "Your assertion was X. Actions moved toward/away."

Write: state/scoreboard.md (new week section)
       Claude Code native memory (weekly patterns)
```

### First Run
```
Create: config/goals.md, config/strategy.md, config/identity.md,
        config/linkedin.md, config/calendar.md (all with commented templates)
Create: state/streak.json (zeroed), state/scoreboard.md (empty),
        state/decisions.md (empty)

Output: Welcome message + instructions to fill config files
```

## Memory Strategy (Hybrid)

### Claude Code Native Memory (`~/.claude/projects/.../memory/`)
Written with proper YAML frontmatter so Claude Code auto-retrieves across all conversations:

- `user` type: founder profile, strengths, weaknesses, stage
- `feedback` type: what coaching approaches work/don't (e.g., "short lists get completed")
- `project` type: active decisions, current goals, recent wins
- `reference` type: LinkedIn config, calendar setup

### Structured State Files (in plugin `state/`)
For data that must be exact, not approximate:
- streak.json: streak counter (can't be "about 62")
- scoreboard.md: 3/15 not "about 20%"
- decisions.md: timestamped log (searchable, reviewable)

### Why Hybrid
Claude's native memory is great for fuzzy learning (patterns, preferences, avoidance behaviors). Structured files are necessary for precise tracking (streaks, scores, dates).

## Error Handling

| Scenario | Handling |
|----------|----------|
| streak.json corrupted/missing | Recreate from empty, warn user, don't break |
| goals.md empty after first run | SETUP_INCOMPLETE flow — nudge to fill |
| Calendar MCP unavailable | Skip calendar, coach works without it |
| No native memory access | Coach still works from config + state files |
| Session type ambiguous | Default to morning |
| Multiple /coach in same session type | Allow re-run, don't double-count streak |

## Testing Strategy

Manual end-to-end testing (this is a skill, not code with unit tests):
1. Fresh install → first run creates all config files
2. Fill goals → morning session generates 3 actions
3. Evening check-in → scoreboard updates correctly
4. Streak increments across sessions
5. Decision log captures and resurfaces decisions
6. Friday weekly review shows real scores
7. LinkedIn draft generation works
8. Calendar integration enhances (when available) but doesn't break (when not)
9. Memory writes correct frontmatter
10. Second user can install and use independently

## Questions Resolved
- Q: What's in v1 scope? A: Everything — all features per spec's 2-day plan
- Q: Architecture? A: Claude Code plugin with single /coach skill, internal routing
- Q: Skill split? A: One skill, auto-detects session type
