# Founder Coach Implementation Plan

> **For Claude:** REQUIRED: Follow this plan phase-by-phase. This is a Claude Code plugin — all files are markdown/JSON, not application code. There are no unit tests. Each phase produces files that can be manually tested by running `/coach` in Claude Code.
> **Design:** See `docs/plans/2026-04-03-founder-coach-design.md` for full specification.

**Goal:** Build a Claude Code plugin with a single `/coach` skill that acts as a daily AI coaching system for founders — streak tracking, scoreboard, decision log, LinkedIn drafting, calendar awareness, and Godin strategy framework.

**Architecture:** Claude Code plugin format (`.claude-plugin/plugin.json` + `skills/coach/SKILL.md`). The SKILL.md is the routing engine — it detects session type (first-run, morning, evening, weekly) and branches behavior. An `agents/coach.md` file defines the persona. Config templates are created on first run. State files (streak, scoreboard, decisions) are auto-managed. Claude Code native memory is used for fuzzy learning; structured files for precise tracking.

**Tech Stack:** Markdown, JSON, YAML frontmatter. Claude Code plugin SDK. No external dependencies.

**Prerequisites:** A directory with git initialized. Familiarity with Claude Code plugin format (`.claude-plugin/plugin.json`, `skills/{name}/SKILL.md` with YAML frontmatter).

**Durable Decisions:**
- Plugin manifest at `.claude-plugin/plugin.json` (NOT `plugin.json` at root)
- Single skill: `skills/coach/SKILL.md` with `name: coach` frontmatter
- Session routing logic lives inside SKILL.md (not separate files)
- Config files created at `config/` relative to plugin root (user-editable, commented templates)
- State files at `state/` relative to plugin root (auto-managed by coach)
- References at `references/` (static coaching knowledge)
- Templates at `templates/` (scaffolding for new weeks/decisions)
- Agent persona at `agents/coach.md` (personality + behavior rules)
- Native memory writes use YAML frontmatter with 4 types: user, feedback, project, reference
- streak.json is the single source of truth for session detection and streak counting

---

## Codebase Reality Check

- **Verified files / surfaces:** This is a greenfield project. Only `SPEC.md`, `README.md`, `LANDING_PAGE.md`, and `docs/plans/2026-04-03-founder-coach-design.md` exist. No plugin files exist yet.
- **Existing patterns / constraints:** Plugin format verified from reference plugin at `/Users/oferbl/.claude/plugins/cache/claude-plugins-official/playground/` — uses `.claude-plugin/plugin.json` manifest and `skills/{name}/SKILL.md` with YAML frontmatter. Existing personal coach at `/Users/oferbl/.claude/skills/ofer-2-coach/` uses same SKILL.md pattern with `name: coach` and `user_invocable: true` frontmatter.
- **Pressure points / contradictions:** The README.md shows `SKILL.md` at repo root in the file structure diagram, but the plugin format requires `skills/coach/SKILL.md`. The README file structure section needs updating in Phase 5 to match the actual plugin layout. The design file also shows `SKILL.md` at root in one place but `skills/coach/SKILL.md` in the architecture section — the plugin format (subdirectory) is correct.

## Plan-vs-Code Gaps

| Current code / behavior | Planned change | Gap / risk | Plan response |
|-------------------------|----------------|------------|---------------|
| README.md shows `SKILL.md` at repo root | Plugin format requires `skills/coach/SKILL.md` | README file structure diagram will be inaccurate | Phase 5 Task 5.2 explicitly checks and updates README to match reality |
| No git repo initialized | Plan assumes git for commits | Build will fail at commit steps if no git | Phase 1 prerequisites state git must be initialized; builder should run `git init` first |
| SPEC.md references `memory/context.md` (legacy) | Design decided against custom memory file — uses native Claude Code memory | SPEC.md is outdated on this point | SPEC.md is source material, not the plan of record. Design file is canonical. No action needed. |
| Existing ofer-2-coach uses agents/ with 8 sub-agents | Founder Coach uses single `agents/coach.md` | Simpler architecture — no risk, but builder should not copy multi-agent pattern | Plan explicitly specifies single agent file |

## Assumption Ledger

- **Proven by code:**
  - Plugin format uses `.claude-plugin/plugin.json` (verified: playground plugin at `/Users/oferbl/.claude/plugins/cache/claude-plugins-official/playground/52e95f6756e5/.claude-plugin/plugin.json`)
  - Skills use `skills/{name}/SKILL.md` with YAML frontmatter (verified: playground plugin `skills/playground/SKILL.md`)
  - SKILL.md frontmatter includes `name`, `description`, `user_invocable` fields (verified: existing ofer-2-coach SKILL.md)

- **Inferred:**
  - Claude Code native memory accepts YAML frontmatter with `type` field for user/feedback/project/reference (described in user's task description and design, consistent with Claude Code documentation patterns)
  - `config/` and `state/` directories created by the skill at runtime will persist in the user's project directory (standard file system behavior)
  - Streak date comparison using YYYY-MM-DD strings is safe without timezone handling (reasonable for date-only, no time-sensitive operations)

- **Needs user confirmation:**
  - None — all critical assumptions are either proven from codebase inspection or safely inferred from documented behavior.

---

## Phase 1: Plugin Skeleton + First Run Flow

> **Exit Criteria:** Running `/coach` in a fresh project creates all config and state files, displays welcome message, and a second `/coach` detects SETUP_INCOMPLETE when goals are still commented out.

**Objective:** Establish the plugin structure and implement the first-run detection and file scaffolding flow.

**Inputs:** Design file section "Architecture > Plugin Structure", "Onboarding" section, plugin.json format from reference plugins.

**Files/Surfaces:**
- Create: `.claude-plugin/plugin.json`
- Create: `skills/coach/SKILL.md` (Phase 1 scope: first-run detection + SETUP_INCOMPLETE only)
- Create: `agents/coach.md`
- Create: `templates/goals.md`
- Create: `templates/identity.md`
- Create: `templates/strategy.md`
- Create: `templates/linkedin.md`
- Create: `templates/calendar.md`
- Create: `templates/scoreboard.md`
- Create: `templates/decisions.md`

**Dependencies:** None (first phase).

**Allowed scope:** Plugin manifest, SKILL.md skeleton with first-run + setup-incomplete routing only, agent persona file, all template files.

**Out-of-scope drift:** Do NOT implement morning/evening/weekly session flows yet. Do NOT implement streak logic yet. Do NOT write reference files yet.

### Task 1.1: Plugin manifest

**Files:**
- Create: `.claude-plugin/plugin.json`

**Step 1:** Create the plugin manifest.

```json
{
  "name": "founder-coach",
  "description": "Daily AI coaching system for founders. One command (/coach), every morning, 3 actions. Streak tracking, decision log, LinkedIn drafting, and strategy framework with memory that compounds over time.",
  "author": {
    "name": "Ofer Blutrich",
    "email": "ofer@blutrich.com"
  }
}
```

**Step 2:** Verify the manifest is valid JSON.

Run: `cat .claude-plugin/plugin.json | python3 -m json.tool`
Expected: Pretty-printed JSON, no errors.

### Task 1.2: Agent persona file

**Files:**
- Create: `agents/coach.md`

Write the coach persona based on Design file "Personality" section. This file is referenced by SKILL.md. It defines:

1. **Voice rules:** Tells don't ask. Brief celebration then move on. Pattern calling. References past decisions. Godin-style insight.
2. **Action generation rules:** Always 3 actions. Always specific. Always tied to goals. One LinkedIn action per morning.
3. **Tone examples:** Include 4-5 voice examples from the design (e.g., "Day 23. You've shipped 4 posts in 3 weeks...").
4. **Anti-patterns:** Never preachy. Never generic. Never ask "What would you like to do?" Always grounded in user's specific context.
5. **Memory writing rules:** How to write to Claude Code native memory with proper YAML frontmatter. Include the 4 memory types (user, feedback, project, reference) with examples from design.
6. **Content pattern:** fact -> Why -> How to apply (for memory entries).

### Task 1.3: Config and state templates

**Files:**
- Create: `templates/goals.md` (from Design: "Onboarding > config/goals.md")
- Create: `templates/identity.md` (from Design: "Onboarding > config/identity.md")
- Create: `templates/strategy.md` (from Design: "Goal System > config/strategy.md" — the full 6-section Godin framework)
- Create: `templates/linkedin.md` (from Design: "Onboarding > config/linkedin.md")
- Create: `templates/calendar.md` (from Design: "Onboarding > config/calendar.md")
- Create: `templates/scoreboard.md` (from Design: "Onboarding > state/scoreboard.md")
- Create: `templates/decisions.md` (from Design: "Onboarding > state/decisions.md")

Copy the exact template content from the design file for each. These templates are what gets copied to `config/` and `state/` on first run.

**Step 1:** Create each template file with the exact content from the design.

**Step 2:** Verify all 7 template files exist.

Run: `ls templates/`
Expected: `calendar.md  decisions.md  goals.md  identity.md  linkedin.md  scoreboard.md  strategy.md`

### Task 1.4: SKILL.md skeleton with first-run + setup-incomplete routing

**Files:**
- Create: `skills/coach/SKILL.md`

This is the most critical file. It is the routing engine.

**YAML frontmatter:**
```yaml
---
name: coach
description: |
  Daily AI coaching system for founders. Run /coach every morning for 3 specific actions.
  Tracks streaks, logs decisions, drafts LinkedIn posts, and reviews your week.
  Memory compounds over time — day 30 is sharper than day 1.
user_invocable: true
---
```

**Phase 1 routing logic (write into SKILL.md body):**

```
# Founder Coach

You are the Founder Coach. Read agents/coach.md for your personality and behavior rules.

## Session Detection

When /coach is invoked, determine the session type:

### Step 1: Check if config files exist
- Read: config/goals.md
- If file does NOT exist → FIRST_RUN
- If file exists but all goal lines are still commented (start with #) → SETUP_INCOMPLETE

### FIRST_RUN Flow

1. Create the config/ directory and copy these template files into it:
   - config/goals.md (from templates/goals.md)
   - config/identity.md (from templates/identity.md)
   - config/strategy.md (from templates/strategy.md)
   - config/linkedin.md (from templates/linkedin.md)
   - config/calendar.md (from templates/calendar.md)

2. Create the state/ directory and initialize state files:
   - state/streak.json with: {"current_streak": 0, "longest_streak": 0, "total_sessions": 0, "first_session": null, "last_session": null, "history": []}
   - state/scoreboard.md (from templates/scoreboard.md)
   - state/decisions.md (from templates/decisions.md)

3. Display the welcome message:
   [exact welcome message from design]

4. STOP. Do not proceed to morning session.

### SETUP_INCOMPLETE Flow

1. Read config/goals.md
2. Check if any goal lines are uncommented (don't start with #)
3. If all goals are still commented:
   - "Your goals are still commented out. Open config/goals.md and uncomment at least one goal. That's step one. I can't coach you toward nothing."
4. STOP.
```

**Step 3:** Verify SKILL.md has correct frontmatter.

Run: `head -6 skills/coach/SKILL.md`
Expected: YAML frontmatter block with `name: coach`.

### Task 1.5: Manual test — first run

**Step 1:** From the plugin directory, verify the complete file structure exists:

Run: `find . -type f | grep -v '.git' | grep -v '.claude' | sort`
Expected:
```
./.claude-plugin/plugin.json
./agents/coach.md
./skills/coach/SKILL.md
./templates/calendar.md
./templates/decisions.md
./templates/goals.md
./templates/identity.md
./templates/linkedin.md
./templates/scoreboard.md
./templates/strategy.md
```

**Step 2:** Verify no config/ or state/ directories exist yet (they are created on first run).

Run: `ls config/ 2>&1; ls state/ 2>&1`
Expected: Both should show "No such file or directory"

**Step 3:** Commit.

```bash
git add .claude-plugin/ agents/ skills/ templates/
git commit -m "feat: plugin skeleton with first-run and setup-incomplete flows"
```

**Expected artifacts:** Plugin manifest, agent persona, 7 templates, SKILL.md with first-run + setup-incomplete routing.

**Required checks:** File structure matches design. SKILL.md frontmatter is valid. plugin.json is valid JSON.

**Checkpoint type:** none (AFK)

---

## Phase 2: Morning Session Flow + Streak Tracking

> **Exit Criteria:** Running `/coach` after filling in goals produces 3 specific actions tied to those goals, creates a streak entry in `state/streak.json`, and displays the streak count. Running `/coach` again on the same day detects "morning already done" and routes to evening.

**Objective:** Implement the morning session flow and streak tracking logic.

**Inputs:** Phase 1 output (SKILL.md skeleton), Design "Morning Session" and "Streak Tracker" sections, Design "Session Detection" routing table.

**Files/Surfaces:**
- Modify: `skills/coach/SKILL.md` (add morning session flow + full routing logic)

**Dependencies:** Phase 1 complete (SKILL.md skeleton, templates, agent persona exist).

**Allowed scope:** Morning session flow, streak tracking, session detection routing for morning/evening/weekly.

**Out-of-scope drift:** Do NOT implement evening or weekly session content yet (just the routing detection). Do NOT implement LinkedIn drafting content yet (morning mentions it as action 3 but the full LinkedIn guide comes in Phase 4).

### Task 2.1: Full session detection routing

**Files:**
- Modify: `skills/coach/SKILL.md`

Add the complete routing logic after the SETUP_INCOMPLETE check:

```
### Step 2: Session type detection (after config confirmed)

Read state/streak.json to get session history.

Routing rules (check in order):
1. No config/goals.md → FIRST_RUN (already handled above)
2. Goals all commented → SETUP_INCOMPLETE (already handled above)
3. No entry in history for today → MORNING
4. Today has a "morning" entry but no "evening" entry → EVENING
5. It's Friday AND today has an "evening" entry → WEEKLY
6. It's Friday AND no session today yet → MORNING (weekly comes after evening)
7. Today already has all session types done → "You've already checked in today. Go build something. Come back tomorrow."

Day detection: Use the current date. "Friday" = day of week is Friday.
```

### Task 2.2: Morning session flow

**Files:**
- Modify: `skills/coach/SKILL.md`

Add the MORNING session section:

```
### MORNING Session

1. Read ALL context:
   - config/goals.md (required — extract uncommented goals)
   - config/identity.md (if exists — strengths, weaknesses, role)
   - config/strategy.md (if exists — assertions, truth, alternatives)
   - config/linkedin.md (if exists — check if enabled)
   - config/calendar.md (if exists — check if enabled)
   - state/streak.json (current streak, history)
   - state/scoreboard.md (current week's progress)
   - state/decisions.md (recent decisions)
   - Claude Code native memory (patterns, learnings from past sessions)

2. If config/calendar.md has `enabled: true` (uncommented):
   - Attempt to read today's calendar using Google Calendar MCP
   - If calendar MCP unavailable: skip silently, do not error
   - If available: note meetings, prep needs, deep work windows

3. Generate 3 SPECIFIC actions:
   - Action 1: Highest priority from goals (what moves the needle most today)
   - Action 2: Gap detection (what's behind schedule, what's been avoided — reference identity.md weakness if available)
   - Action 3: LinkedIn/content action (if linkedin.md enabled: draft/publish/engage; if not enabled: replace with second goal-aligned action)

   Rules for actions:
   - Each action must be specific enough to complete in one sitting
   - Each action must connect to a stated goal
   - Reference past decisions if relevant ("You decided X — today's action aligns with that")
   - Reference patterns if known ("You tend to avoid Y — today we tackle it")
   - If calendar shows meetings: adjust actions around schedule
   - If calendar shows empty day: flag deep work opportunity

4. Display output in coach voice (see agents/coach.md):
   - Streak line: "Day {N}. [streak commentary]." or "Day 1. Let's go."
   - Brief context (1-2 sentences referencing what coach knows)
   - The 3 actions (numbered, specific, with brief rationale)
   - Closing: "Go. Report back tonight."

5. Update state/streak.json:
   - Add entry to history: {"date": "YYYY-MM-DD", "type": "morning", "timestamp": "ISO8601", "actions_given": 3, "actions_completed": null}
   - If last_session date was yesterday: current_streak += 1
   - If last_session date was today (re-run): do NOT increment streak, do NOT add duplicate entry
   - If last_session was before yesterday: current_streak = 1 (streak broken, restart)
   - If first_session is null: set to today
   - Update last_session to today
   - Update total_sessions += 1
   - If current_streak > longest_streak: update longest_streak

6. Write to Claude Code native memory:
   - If this is the first session: write a `user` type memory with founder profile from identity.md
   - Write/update a `project` type memory with current active goals
```

### Task 2.3: Streak edge cases

Document these edge cases in SKILL.md as explicit rules:

- **Weekend handling:** Streak does NOT break over weekends. If last session was Friday and next is Sunday or Monday, streak continues. Only breaks if a WORK DAY is missed (based on work_days in identity.md, default Mon-Fri).
- **Multiple runs same day:** Only first morning run counts. Subsequent `/coach` calls route to evening (or re-display morning if needed). Never double-count.
- **Corrupted streak.json:** If JSON parse fails, recreate with zeroed state, warn user: "Your streak data got corrupted. Starting fresh. The chain starts now."
- **Missing streak.json:** Same as corrupted — recreate and warn.

### Task 2.4: Commit

```bash
git add skills/coach/SKILL.md
git commit -m "feat: morning session flow with streak tracking and session routing"
```

**Expected artifacts:** SKILL.md with complete session detection, morning flow, streak logic.

**Required checks:** Routing logic handles all 7 detection cases. Streak math is correct for continuation, break, restart, re-run.

**Checkpoint type:** none (AFK)

---

## Phase 3: Evening Session + Scoreboard

> **Exit Criteria:** Running `/coach` after a morning session prompts for completion status, updates scoreboard with actuals, prompts for decisions, writes to decisions.md, and updates streak.json with actions_completed count. The scoreboard shows a real targets-vs-actuals table.

**Objective:** Implement evening check-in flow and scoreboard tracking.

**Inputs:** Phase 2 output (morning flow + streak), Design "Evening Session" and "Scoreboard" sections.

**Files/Surfaces:**
- Modify: `skills/coach/SKILL.md` (add evening session flow)

**Dependencies:** Phase 2 complete (morning session creates streak entries and actions).

**Allowed scope:** Evening session flow, scoreboard updates, decision log entries.

**Out-of-scope drift:** Do NOT implement weekly review yet. Do NOT modify morning flow.

### Task 3.1: Evening session flow

**Files:**
- Modify: `skills/coach/SKILL.md`

Add the EVENING session section:

```
### EVENING Session

1. Read context:
   - state/streak.json (today's morning entry — get the 3 actions given)
   - state/scoreboard.md (current week)

2. Reference today's morning actions (from the history entry for today).

3. Ask: "What did you complete today?" Present the 3 morning actions and ask for status:
   - All 3 completed
   - Specific ones completed (which ones?)
   - None completed

   This is the ONE place the coach asks a question (completion check requires user input).

4. Update state/streak.json:
   - Set today's entry: actions_completed = number completed (0, 1, 2, or 3)

5. Update state/scoreboard.md:
   - Find current week section
   - Update "Actual" column for each metric based on completions
   - If no current week section exists, create one from templates/scoreboard.md

6. Prompt for decisions: "Any decisions worth recording today?"
   - If user provides decisions:
     - Append to state/decisions.md with format:
       ```
       ## YYYY-MM-DD: [Decision title]
       **Decision:** [What was decided]
       **Rationale:** [Why]
       **Connected to:** [Which goal or strategy assertion this relates to]
       ```
   - If user says no: skip

7. Tomorrow preview:
   - If calendar enabled and accessible: "You have [X] tomorrow. I'll prep around it."
   - If not: "See you tomorrow morning."

8. Coach voice close:
   - If all 3 completed: brief celebration + forward look
   - If some completed: acknowledge + note what slipped
   - If none: direct but not harsh — "Showing up counts. The streak holds. But tomorrow we ship."

9. Write to Claude Code native memory:
   - `feedback` type: note what was completed vs not (pattern data for future coaching)
   - If a decision was logged: `project` type with the decision
```

### Task 3.2: Scoreboard initialization

When goals are first uncommented and the first morning session runs, the scoreboard needs to be initialized with the right metrics. Add this logic to SKILL.md:

```
### Scoreboard Initialization (runs once, when first morning session detects empty scoreboard)

1. Read config/goals.md — extract goal text
2. Read config/linkedin.md — if enabled, add "LinkedIn posts" as a metric
3. Create week section in state/scoreboard.md:

| Metric | Target | Mon | Tue | Wed | Thu | Fri | Weekly |
|--------|--------|-----|-----|-----|-----|-----|--------|
| [Goal 1 key metric] | [inferred target] | - | - | - | - | - | 0/X |
| [Goal 2 key metric] | [inferred target] | - | - | - | - | - | 0/X |
| LinkedIn posts | [from linkedin.md posting_goal or default 3] | - | - | - | - | - | 0/X |

The coach infers reasonable weekly targets from the goals. Example: "Hit 10K MRR" → "Outreach actions: 5/week". "Ship v2 by April 30" → "Dev tasks completed: 5/week".
```

### Task 3.3: Commit

```bash
git add skills/coach/SKILL.md
git commit -m "feat: evening session with scoreboard tracking and decision log"
```

**Expected artifacts:** SKILL.md with evening flow, scoreboard update logic, decision capture.

**Required checks:** Evening correctly references morning actions. Scoreboard format matches design. Decision log format is consistent.

**Checkpoint type:** none (AFK)

---

## Phase 4: Weekly Review + LinkedIn Guide + References

> **Exit Criteria:** Running `/coach` on Friday after an evening session produces a weekly review with percentage scores, decision review, next week priorities, and strategy alignment check. LinkedIn draft generation works when prompted as a morning action.

**Objective:** Implement weekly review session and add reference files for LinkedIn drafting and coaching principles.

**Inputs:** Phase 3 output (evening + scoreboard), Design "Weekly Session", "LinkedIn Skill", "Goal System > Strategy Framework" sections.

**Files/Surfaces:**
- Modify: `skills/coach/SKILL.md` (add weekly session flow)
- Create: `references/linkedin-guide.md`
- Create: `references/godin-principles.md`

**Dependencies:** Phase 3 complete (scoreboard has data, decisions exist).

**Allowed scope:** Weekly review flow, LinkedIn reference guide, Godin coaching principles.

**Out-of-scope drift:** Do NOT add new session types. Do NOT modify morning/evening flows.

### Task 4.1: Weekly session flow

**Files:**
- Modify: `skills/coach/SKILL.md`

Add the WEEKLY session section:

```
### WEEKLY Session (Friday, after evening check-in)

1. Read full week context:
   - state/scoreboard.md (full current week — all metrics, all days)
   - state/decisions.md (this week's decisions)
   - config/strategy.md (for strategy alignment)
   - config/goals.md (for goal reference)
   - Claude Code native memory (patterns across weeks)

2. Generate weekly review:

   a. **Score:** Calculate percentage for each metric (actual / target).
      Overall score = average of all metric percentages.
      Display: "This week: X%" with per-metric breakdown.

   b. **Top win:** Identify the highest-performing metric or most impactful completion.
      "Your best move this week: [specific achievement]"

   c. **Biggest gap:** Identify the lowest-performing metric or most avoided area.
      "Where you slipped: [specific gap]. [Pattern observation if available]"

   d. **Decision review:** For each decision logged this week:
      "You decided [X] on [day]. Still holding?"
      If a decision has been revisited 3+ times (check full decisions.md history):
      "You've revisited this decision [N] times. Either commit or change it. But stop circling."

   e. **Strategy alignment:** Reference config/strategy.md:
      "Your assertion was [X]. This week's actions moved [toward/away from] it."
      "Your alternative was [Y]. Are we closer to needing it?"
      "You said you'd be at [Z] by [timeline]. [On track / behind / ahead]?"

   f. **Next week priorities:** 3 priorities for next week, derived from:
      - Gaps from this week
      - Goals that need acceleration
      - Upcoming calendar events (if available)

   g. **Content prompt:** "Ship one post about what you built this week."
      If LinkedIn enabled, offer to draft it now.

3. Create new week section in state/scoreboard.md:
   - Archive current week (keep it in the file, add a `---` separator)
   - Create fresh table for next week from templates/scoreboard.md

4. Write to Claude Code native memory:
   - `feedback` type: weekly patterns (what worked, what didn't)
   - `project` type: updated goal progress
```

### Task 4.2: LinkedIn guide reference

**Files:**
- Create: `references/linkedin-guide.md`

This file is referenced by SKILL.md when the coach needs to draft a LinkedIn post. Content:

1. **Post structure:** Hook (1-2 lines that stop scrolling) -> Story/insight (3-5 short paragraphs) -> Takeaway (actionable lesson) -> CTA (question or prompt)
2. **Voice calibration rules:** Reference config/linkedin.md for expertise, audience, tone. Posts must sound like the founder, not like AI.
3. **Content sources:** Draft from what the founder actually did/decided/built this week (from scoreboard, decisions, memory). Never generic.
4. **Formatting:** Short paragraphs. Line breaks between ideas. No emojis unless user's tone prefers them. No hashtags in body (optional at end).
5. **Anti-patterns:** No "I'm excited to announce." No humble brags. No "5 things I learned" listicles unless that's the founder's actual voice.
6. **Cross-post guidance:** If posting to X too, shorten to key insight + link.

### Task 4.3: Godin principles reference

**Files:**
- Create: `references/godin-principles.md`

Coaching philosophy the agent references. Based on Design "Core Philosophy" and SPEC "Strategy" section:

1. **Small solutions to big problems:** Applied daily, not in heroic leaps.
2. **Systems over power moves:** Change the system, not just the output.
3. **Smallest viable audience:** Find 10 who need this. Serve them deeply.
4. **Gradual build -> tidal wave:** No hype launch. Compound daily.
5. **Strategy is a practice, not a document:** Review it, update it, use it as a lens.
6. **The 6 sections:** Truth, Assertions, Alternatives, People, Money, Time — how to coach through each.
7. **Decision discipline:** Decide, commit, review weekly. Don't revisit between reviews.
8. **Challenge thinking, don't think for them:** The coach is a mirror with opinions, not a replacement.
9. **Time as the unseen driver:** Investments compound. Day 1 is a promise. Day 60 is proof.

### Task 4.4: Commit

```bash
git add skills/coach/SKILL.md references/
git commit -m "feat: weekly review with strategy alignment, LinkedIn guide, Godin principles"
```

**Expected artifacts:** SKILL.md with weekly flow, linkedin-guide.md, godin-principles.md.

**Required checks:** Weekly review produces real percentages. Strategy references connect to config. LinkedIn guide is actionable.

**Checkpoint type:** none (AFK)

---

## Phase 5: End-to-End Polish + README + Distribution

> **Exit Criteria:** Full loop works: first run -> fill goals -> morning -> evening -> morning -> weekly. README has install instructions. Plugin can be installed via `claude plugin add` from the repo.

**Objective:** Test the full loop, fix edge cases, write the README, and prepare for distribution.

**Inputs:** All prior phases. Design "Error Handling" section. Existing README.md in repo.

**Files/Surfaces:**
- Modify: `skills/coach/SKILL.md` (edge case handling, polish)
- Modify: `README.md` (update with install instructions, or verify existing is accurate)
- Create: `LICENSE` (MIT)

**Dependencies:** Phases 1-4 complete.

**Allowed scope:** Error handling, edge cases, README, license, final commit.

**Out-of-scope drift:** Do NOT add new features. Do NOT change architecture.

### Task 5.1: Error handling in SKILL.md

**Files:**
- Modify: `skills/coach/SKILL.md`

Add error handling section based on Design "Error Handling" table:

```
## Error Handling

- **streak.json corrupted/missing:** Recreate from empty state. Warn: "Your streak data got corrupted. Starting fresh. The chain starts now." Do not crash.
- **goals.md empty after first run:** Route to SETUP_INCOMPLETE. Nudge to fill.
- **Calendar MCP unavailable:** Skip calendar silently. Coach works without it. Never error on missing calendar.
- **No native memory access:** Coach still works from config + state files alone. Memory is enhancement, not requirement.
- **Session type ambiguous:** Default to MORNING.
- **Multiple /coach in same session type:** Allow re-run. Display same content. Do NOT double-count streak or add duplicate history entries.
- **scoreboard.md missing or corrupted:** Recreate from template. Warn user.
- **decisions.md missing:** Recreate empty. Continue.
- **Config file missing after first run (not goals):** Skip that config gracefully. Only goals.md is required.
```

### Task 5.2: README verification

**Files:**
- Review: `README.md` (existing in repo)

The existing README.md is comprehensive. Verify it matches the final implementation:
- Install command matches plugin format
- File structure matches what we built
- Session descriptions match SKILL.md behavior
- No references to features that don't exist

If discrepancies exist, update README.md to match reality.

### Task 5.3: License

**Files:**
- Create: `LICENSE`

MIT license with Ofer Blutrich, 2026.

### Task 5.4: Final file structure verification

Run: `find . -type f | grep -v '.git' | grep -v '.claude' | grep -v 'docs/' | grep -v 'SPEC.md' | grep -v 'LANDING_PAGE.md' | sort`

Expected (the distributable plugin):
```
./.claude-plugin/plugin.json
./LICENSE
./README.md
./agents/coach.md
./references/godin-principles.md
./references/linkedin-guide.md
./skills/coach/SKILL.md
./templates/calendar.md
./templates/decisions.md
./templates/goals.md
./templates/identity.md
./templates/linkedin.md
./templates/scoreboard.md
./templates/strategy.md
```

Note: `config/`, `state/`, and native memory files are NOT in the repo — they are created on first run per-user.

### Task 5.5: End-to-end manual test script

Test the full loop manually in Claude Code:

1. **Test 1 — First run:** `/coach` in clean state -> creates config/ and state/ -> welcome message
2. **Test 2 — Setup incomplete:** `/coach` without editing goals -> "goals still commented" message
3. **Test 3 — Fill goals:** Edit config/goals.md, uncomment at least one goal
4. **Test 4 — Morning session:** `/coach` -> 3 actions, streak "Day 1", streak.json updated
5. **Test 5 — Re-run morning:** `/coach` again -> routes to evening (not double morning)
6. **Test 6 — Evening session:** Check-in on completions -> scoreboard updates, decision prompt
7. **Test 7 — Next day morning:** (simulate by editing streak.json date) -> streak "Day 2"
8. **Test 8 — Weekly review:** (simulate Friday + evening done) -> percentage scores, decision review
9. **Test 9 — Streak break:** (simulate skipping a day) -> streak resets to 1
10. **Test 10 — Corrupted state:** Delete streak.json -> `/coach` recreates it gracefully

### Task 5.6: Final commit

```bash
git add -A
git commit -m "feat: complete founder coach plugin v1 — ready for distribution"
```

**Expected artifacts:** Complete, distributable plugin. README accurate. License present. All edge cases handled.

**Required checks:** Full 10-step manual test passes. File structure matches expected.

**Checkpoint type:** human_verify (final review before distribution)

---

## Phase Dependency Map

- **Phase 1:** depends on nothing, creates plugin skeleton + templates + agent persona, enables Phase 2
- **Phase 2:** depends on Phase 1 (SKILL.md skeleton), creates morning flow + streak logic, enables Phase 3
- **Phase 3:** depends on Phase 2 (morning creates streak entries), creates evening flow + scoreboard, enables Phase 4
- **Phase 4:** depends on Phase 3 (scoreboard has data), creates weekly review + references, enables Phase 5
- **Phase 5:** depends on Phases 1-4, creates error handling + distribution readiness

## Phase Autonomy Classification

| Phase | Checkpoint Type | Classification | Reason |
|-------|----------------|----------------|--------|
| Phase 1 | none | AFK | Straightforward file creation from design templates |
| Phase 2 | none | AFK | Morning flow + streak logic clearly specified in design |
| Phase 3 | none | AFK | Evening flow follows morning pattern, scoreboard format defined |
| Phase 4 | none | AFK | Weekly review, LinkedIn guide, and Godin principles all specified |
| Phase 5 | human_verify | HITL | Final review before distribution to 10 founders |

## Acceptance Checks

1. `/coach` on fresh install creates all config and state files in under 5 seconds
2. `/coach` after filling goals produces 3 specific, goal-tied actions
3. Streak increments correctly across sessions (day N -> day N+1)
4. Streak breaks when a work day is missed (not weekends)
5. Evening check-in updates scoreboard with real numbers
6. Decision log captures decisions with date, rationale, and strategy connection
7. Weekly review shows percentage scores per metric
8. Weekly review surfaces past decisions for re-evaluation
9. LinkedIn draft is based on actual work/decisions (not generic)
10. Corrupted/missing state files are recreated gracefully
11. Calendar integration enhances but does not break when unavailable
12. A second user can clone and use the plugin independently

## Risks and Mitigations

| Risk | P | I | Score | Mitigation |
|------|---|---|-------|------------|
| SKILL.md routing logic misdetects session type | 3 | 4 | 12 | Explicit priority-ordered routing rules with fallback to MORNING |
| Streak math off-by-one (weekends, timezone) | 3 | 3 | 9 | Use date-only comparison (no time), explicit weekend skip rule |
| Claude Code native memory frontmatter format wrong | 2 | 4 | 8 | Include exact YAML examples in agents/coach.md; test with one write first |
| Scoreboard metrics don't match goals well | 2 | 3 | 6 | Coach infers reasonable defaults; user can edit scoreboard.md directly |
| Plugin format incompatible with user's Claude Code version | 2 | 5 | 10 | Use simplest possible plugin.json; test install on fresh machine |
| SKILL.md too long, hits context limits | 2 | 4 | 8 | Keep SKILL.md focused on routing; delegate personality to agents/coach.md and knowledge to references/ |

## Recommended Skills for BUILD (SKILL_HINTS for Router)

None required. This is a markdown-only plugin with no framework dependencies.

## Confidence Score: 82/100

- Context References: Design file is comprehensive with exact templates (+25)
- Edge cases: Documented in design and plan (+15)
- Testing: Manual only (no automated tests possible for a skill) — slight risk (+10)
- Risk mitigations: Defined for top risks (+15)
- File paths: Exact, derived from design and reference plugins (+17)

**Factors that could improve it:**
- Automated testing framework for Claude Code skills (doesn't exist yet)
- Testing the exact YAML frontmatter format for native memory on a live install
- Confirming `.claude-plugin/plugin.json` is the correct path (vs `plugin.json` at root) — verified from playground plugin reference

**Key Assumptions (see Assumption Ledger above for full classification):**
- [proven] Plugin format: `.claude-plugin/plugin.json` + `skills/{name}/SKILL.md`
- [inferred] Native memory YAML frontmatter with type field works as documented
- [inferred] Date-string comparison for streaks is safe without timezone handling
