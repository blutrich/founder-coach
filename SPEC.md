# Founder Coach — Spec

> "Big problems demand small solutions." — Seth Godin
>
> One command. Every morning. 3 actions. A thinking partner with memory that won't let you bullshit yourself.

---

## 1. Truth

Founders are overwhelmed. Not because the work is hard, but because the decisions never stop. Every morning brings new inputs: emails, Slack, DMs, investor updates, customer requests, competitor moves. By Wednesday the priorities set on Monday are forgotten.

The market for productivity tools is enormous and mostly useless. Todo apps don't hold you accountable. Notion boards become graveyards. Coaching costs $500/hour and happens once a week — 167 hours too late.

AI assistants (ChatGPT, Claude, Copilot) are powerful but stateless. They don't remember what you decided last Tuesday. They don't know you avoid outreach. They don't track whether you're doing what you said you'd do. Every conversation starts from zero.

The system is optimized for reaction, not intention. Slack rewards fast replies. Email rewards volume. LinkedIn rewards posting. None of them reward doing the one thing that actually matters today.

62 days of real usage data confirms: the gap isn't tools or information. It's accountability with memory.

## 2. Assertions

We will build a Claude Code skill — `/coach` — that acts as a proactive daily co-founder.

**We assert:**
- A 2-minute morning session with 3 specific actions will ship more than a 2-hour planning session
- A decision log that resurfaces past decisions will reduce decision-revisiting by 80%+
- Memory that compounds across sessions will make the coach more valuable on day 30 than day 1
- Built-in LinkedIn drafting from real work will convert "I should post" into actual posts
- A streak mechanic (show up daily) will drive retention better than features
- 10 founders using this for one week during Passover will generate organic word-of-mouth

**The business model:** Open source the skill. Build reputation. The skill positions the builder as the expert. Consulting, workshops, and custom coaching systems are the revenue layer — not the tool itself.

## 3. Alternatives

**If founders don't adopt it:** The skill still works for its creator (62 days and counting). It becomes a portfolio piece and a case study for "the new technical class" — a non-developer who built a production AI system.

**If the streak mechanic doesn't stick:** The decision log and LinkedIn skill have standalone value. Each component is useful independently.

**If Claude Code changes its skill/memory format:** The coach is markdown files. It ports to any LLM tool that reads markdown. Zero vendor lock-in.

**If 10 founders don't engage during Passover:** The community post still demonstrates a real 62-day system with screenshots. The story stands alone.

## 4. People

**Builder:** Ofer Blutrich. AI builder, not a developer. 62 days of daily usage. 25+ production Claude Code skills. Former national climbing champion (100+ first ascents). The person who builds tools AND teaches others to build. Track record: shipped to Wix, Base44, and Israeli AI communities.

**First 10 users:** Tech founders from the Esner community (Monday.com). People who already use Claude Code. People who publicly admit they should post more, ship more, decide faster.

**The coach itself:** One persona. Direct, opinionated, grounded in your data. Not a chatbot — a co-founder who pays attention.

## 5. Money

**Cost to build:** 2 days of time during Passover. Zero infrastructure. Zero hosting. Zero dependencies.

**Cost to user:** Nothing. Requires existing Claude Code subscription.

**Revenue model (future):** The skill is the top of funnel. Revenue comes from:
- Custom coaching systems for teams ($5-15K)
- Workshops on building AI skills ($3-8K/day)
- Consulting on agent architecture ($150-300/hr)
- The FREEDOM pipeline: independent AI consulting practice

**Assets built:** Open source repo with stars. Community proof (user testimonials). Case study content. Network of 10+ founders who use the tool daily.

## 6. Time

**Week 1 (Passover):** Build core skill (2 days). Find 10 founders. They start Day 1.

**Week 2:** 10 founders have 5-7 day streaks. Collect feedback. Iterate. Community post goes live with THEIR data, not just mine.

**Month 1:** Word of mouth from the 10. LinkedIn posts about the experience. GitHub stars accumulate. First workshop inquiry.

**Month 3:** The skill has 50+ active users. The builder has consulting pipeline from visibility. The system compounds — past success makes future success more likely.

**Month 6:** The skill is the proof point for a consulting practice. "I built this, I used it for 200+ days, and then I helped 50 founders use it. Want me to build your team's version?"

---

## What This Is

A Claude Code skill that acts as a proactive AI coach for founders. It doesn't ask what you want to do. It tells you what to do, based on your goals, your calendar, your patterns, and your decisions.

It remembers everything. It tracks your streak. It calls you out when your actions don't match your stated goals.

Built and validated over 62 real days of daily use.

## Core Philosophy (Godin)

- Small solutions to big problems, applied daily
- System changes over power moves
- Find 10 people who need this. Serve them deeply.
- Gradual build → tidal wave. No hype launch.
- The coach challenges your thinking — it doesn't think for you

## The Core Loop

### Morning `/coach`

1. Read memory (goals, decisions, patterns, what's working, what's not)
2. Read calendar (meetings today, prep needed)
3. Detect gaps (what's behind? what's been avoided?)
4. Deliver 3 SPECIFIC actions with exact instructions
5. Include one LinkedIn action (draft, publish, or engage)
6. "Go. Report back tonight."

### Evening `/coach`

1. "What did you complete?" (All / Some / None)
2. Update scoreboard (only confirmed completions)
3. Prompt for decisions: "Any decisions worth recording today?"
4. Decision log entry with rationale
5. Tomorrow preview: "You have [X] tomorrow. I'll prep around it."
6. Streak continues (showing up counts, even if you completed nothing)

### Weekly (Friday `/coach`)

1. Scoreboard: percentage against targets
2. Top win + biggest gap
3. Decision review: "You decided X on Tuesday. Still holding?"
4. Next week's 3 priorities
5. "Ship one post about what you built this week."

## Components

### 1. Streak Tracker
- Days in a row you ran /coach
- The #1 engagement hook
- Doesn't break if you skip actions — breaks if you skip the session
- Displayed on every session: "Day 14. Don't break the chain."

### 2. Scoreboard (Markdown)
- Weekly targets vs actuals in a table
- Configurable metrics (defaults: LinkedIn posts, outreach, key deliverables)
- Weekly score as percentage
- Historical trend: "Weeks 1-4: 60% → 74% → 89% → 95%"

### 3. Decision Log
- "I decided X because Y" entries
- Coach reviews past decisions weekly: "Still holding?"
- Prevents the #1 founder trap: revisiting decisions endlessly
- Pattern detection: "You've revisited this decision 3 times. Either commit or change it."

### 4. Memory (Hybrid: Native Claude Code + Structured Files)

**Uses Claude Code's built-in memory system** (`~/.claude/projects/.../memory/`).
No custom memory implementation. The coach writes memories with proper frontmatter
that Claude Code natively retrieves across all conversations.

**Native memory (auto-retrieved by Claude Code):**
The coach writes these as individual `.md` files with YAML frontmatter:

```yaml
---
name: founder-coaching-patterns
description: What coaching approaches work and don't work for this founder
type: feedback
---
- Ofer avoids outreach on Mondays. Push harder on Tuesdays.
- Short action lists (3 max) get completed. Long lists get ignored.
- LinkedIn posts ship when drafted in the morning session, not evening.
```

```yaml
---
name: founder-active-decisions
description: Decisions the founder made - coach reviews weekly to prevent revisiting
type: project
---
- 2026-04-02: Focus on revenue, not redesign. Revisit in May.
- 2026-04-01: No investor meetings until 10K MRR.
```

Memory types used:
- `user` — founder profile, strengths, weaknesses, stage
- `feedback` — what coaching approaches work/don't work
- `project` — active decisions, current goals, recent wins
- `reference` — LinkedIn config, calendar setup

**Structured files (in skill directory, for precise tracking):**
- `state/scoreboard.md` — weekly targets vs actuals (needs exact numbers)
- `state/decisions.md` — timestamped decision log (reviewable, searchable)
- `state/streak.json` — streak counter + session history (must be exact)

**Why hybrid:** Claude's native memory is great for learning patterns and
context (fuzzy, adaptive). But a streak counter can't be "approximately 62."
The scoreboard needs 3/15, not "about 20%." Structured state lives in files.
Learning lives in native memory.

### 5. LinkedIn Skill (Built-in)
- Post creation with voice calibration
- First run captures: expertise, audience, tone preferences
- Drafts posts grounded in what you actually built/did (from memory)
- Not generic content — YOUR voice, YOUR work
- Cross-post to X option

### 6. Calendar Awareness (Optional)
- Google Calendar integration via MCP
- Morning: surfaces today's meetings with prep notes
- Detects empty calendar days: "No meetings. Deep work day. Ship something."
- Detects meeting-heavy days: "Back-to-back. Your one action today is [highest priority only]."

### 7. Goal System + Strategy Framework (Godin's 6 Sections)

Goals are set on first run via `config/goals.md`. Everything routes through them.

But goals without strategy are just wishes. The coach uses Godin's 6-section
framework to help founders think clearly about their business:

**Built into onboarding** (`config/strategy.md` — created on first run):
```markdown
# Your Strategy
# Not a business plan. A thinking tool. Fill in what you can.
# The coach uses this to challenge your decisions.
# Remove the # from any line you want to activate.

## Truth — the world as it is
# What market are you in? Who are the competitors?
# What's the status quo? What have others tried?
# market: 
# competitors: 
# status_quo: 
# what_others_tried: 

## Assertions — how you'll change things
# What will you do, and what will happen as a result?
# assertion_1: We will do X, and then Y will happen
# assertion_2: We will build Z with this much money in this much time
# business_model: How does this become sustainable?

## Alternatives — what if your assertions are wrong?
# If plan A fails, what's plan B?
# if_wrong: 
# flexibility: How much can you pivot?
# runway: How long before you need results?

## People — who ships this?
# Not resumes. Attitudes, abilities, track record in shipping.
# team: 
# missing: Who do you need but don't have?

## Money — the math
# How much do you need? How will you spend it? Cash flow?
# budget: 
# burn_rate: 
# revenue_target: 

## Time — the unseen driver
# What's different in 1 week? 1 month? 1 year?
# week_1: 
# month_1: 
# month_6: 
# year_1: 
```

**Built into the weekly review:** The Friday session references your strategy:
- "Your assertion was X. This week's actions moved toward/away from it."
- "Your alternative was Y. Are we closer to needing it?"
- "You said you'd be at Z by month 1. It's been 3 weeks. On track?"

**Built into the decision log:** When you log a decision, the coach connects
it to your strategy: "This decision aligns with assertion #2" or "This
contradicts what you wrote in your alternatives section."

**Quarterly reset:** Every 3 months the coach prompts a full strategy review.
Not starting over — updating. "What changed in the Truth section? Do your
assertions still hold?"

## Personality

One voice. The brutally honest co-founder.

**Principles:**
- TELLS, doesn't ask. "Here's what you're doing" not "What would you like to do?"
- Celebrates briefly, then moves on. "Good. Now here's the next thing."
- Calls out patterns: "Third week you said you'd post and didn't. What's the real blocker?"
- References past decisions: "You decided to focus on X. Why are you spending time on Y?"
- Uses Godin-style insight: systems thinking, smallest viable audience, gradual build
- Never preachy. Never generic. Always grounded in YOUR specific context.

**Voice examples:**
- "Day 23. You've shipped 4 posts in 3 weeks. That's not a content strategy, that's a hobby. Ship today."
- "You decided to stop taking investor meetings until you hit 10K MRR. That was Tuesday. Today someone DMd you about funding. The answer is no. Move on."
- "Your calendar is empty until 14:00. You have 5 hours of deep work. Don't waste them on email."
- "You told me your #1 goal is revenue. You spent the last 3 days on your website redesign. Those don't connect."

## Onboarding (PR Agent Pattern — files over questions)

Inspired by the PR agent pipeline (`/new-client` → template files → fill → re-run).
No interactive Q&A. The user fills in templates at their own pace.

### First Run: `/coach`

Coach detects no `memory/context.md` → first run mode.

**Step 1:** Create config files with commented templates:

`config/strategy.md`: *(the 6-section business plan — see Goal System section above)*

`config/goals.md`:
```markdown
# Your Goals
# Define 1-3 goals for this quarter. Be specific and measurable.
# Remove the # from any line you want to activate.
# The coach routes ALL daily actions through these goals.

# goal_1: Hit 10K MRR by end of Q2
# goal_2: Ship v2 of the product by April 30
# goal_3: Post 3x/week on LinkedIn consistently

# timeline: Q2 2026
```

`config/identity.md`:
```markdown
# Who You Are
# The coach adapts its actions to your context.
# Remove the # from any line you want to activate.

# name: Your Name
# role: Founder / CEO / CTO / Solo builder
# company: Your Company
# stage: Pre-revenue / Early revenue / Growth / Scaling
# superpower: What you're best at (building, selling, designing, etc.)
# weakness: What you avoid (outreach, content, hiring, decisions, etc.)
# work_days: Sun-Thu / Mon-Fri / Custom
```

`config/linkedin.md`:
```markdown
# LinkedIn Configuration (Optional)
# If you want the coach to help you create and ship content.
# Remove the # from any line you want to activate.

# enabled: true
# expertise: What you know deeply (AI agents, SaaS growth, product design, etc.)
# audience: Who reads your posts (founders, developers, marketers, etc.)
# tone: How you sound (direct, storytelling, technical, casual, etc.)
# posting_goal: 3/week
# examples:
#   - https://linkedin.com/in/yourprofile/recent-activity
#   - Paste a post you wrote that felt like YOU
```

`config/calendar.md`:
```markdown
# Calendar Integration (Optional)
# The coach can read your calendar to prep you for meetings
# and detect deep work windows.
# Remove the # from any line you want to activate.

# enabled: true
# provider: google
# email: your@email.com
```

**Step 2:** Create initial state files:

`state/streak.json`:
```json
{
  "current_streak": 0,
  "longest_streak": 0,
  "total_sessions": 0,
  "first_session": null,
  "last_session": null,
  "history": []
}
```

`state/scoreboard.md`:
```markdown
# Scoreboard

## Current Week
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| (populated after goals are set) |
```

`state/decisions.md`:
```markdown
# Decision Log
# The coach reviews these weekly. Don't revisit — commit or change.
```

**No custom memory file.** The coach writes learning/patterns to Claude Code's
native memory directory with proper frontmatter. This means coaching context
is available across ALL conversations, not just /coach sessions.

**Step 3:** Stop and tell the user:

```
Welcome. I'm your founder coach.

I've created your setup files in config/:

  config/goals.md      — your 1-3 quarterly goals (REQUIRED)
  config/strategy.md   — your 6-section strategy (Truth, Assertions, Alternatives, People, Money, Time)
  config/identity.md   — who you are and what you avoid
  config/linkedin.md   — if you want help shipping content
  config/calendar.md   — if you want meeting-aware coaching

Open them. Uncomment the lines that matter. Be honest —
especially about your weakness. That's where I'll push hardest.

When you're ready, run /coach again. Day 1 starts then.
```

### Second Run: Day 1

Coach detects `config/goals.md` exists and has uncommented lines → proceed.

1. Parse all config files (skip commented lines, skip empty sections)
2. Load goals into memory/context.md
3. Check calendar (if enabled)
4. Generate first morning session: 3 actions routed through goals
5. Start streak: "Day 1. Let's go."

### Why Files Over Questions

- **No pressure.** Fill them in tonight, run /coach tomorrow morning.
- **Self-documenting.** Comments explain every field.
- **Iterable.** Change goals anytime by editing the file.
- **Persistent.** Config survives across sessions, machines, reinstalls.
- **Honest.** Writing "weakness: I avoid outreach" is easier on paper than saying it out loud.

## File Structure

```
founder-coach/
├── SKILL.md                 # The engine (routing, steps, personality)
├── agents/
│   └── coach.md             # Coach persona + behavior rules
├── config/                  # User-editable (created on first run)
│   ├── goals.md             # Quarterly goals (REQUIRED)
│   ├── strategy.md          # 6-section strategy (Truth/Assertions/Alternatives/People/Money/Time)
│   ├── identity.md          # Who you are, strengths, weaknesses
│   ├── linkedin.md          # Content config (optional)
│   └── calendar.md          # Calendar integration (optional)
├── state/                   # Structured tracking (auto-managed)
│   ├── scoreboard.md        # Weekly targets vs actuals
│   ├── decisions.md         # Timestamped decision log
│   └── streak.json          # Streak counter + session history
├── references/
│   ├── linkedin-guide.md    # Post creation + voice calibration
│   └── godin-principles.md  # System thinking prompts
└── templates/
    ├── scoreboard.md        # Weekly tracking template
    └── decisions.md         # Decision entries template
```

**Memory lives in Claude Code's native memory directory** — NOT in the skill.
The coach writes memories with proper frontmatter to `~/.claude/projects/.../memory/`.
This means coaching context is available in ALL Claude Code conversations, not just /coach.

Single repo. Single install.
No dependencies. No external services required.
Calendar is optional (enhances but not required).
LinkedIn skill is built-in (not a separate install).

## Competition Strategy (Godin Method)

### Phase 1: Find 10 (Days 1-2)
- DM 10 specific founders in the Esner community
- "I built something. Try /coach tomorrow morning. Tell me what happens."
- Pick people who publicly complain about productivity, content, focus

### Phase 2: Serve Deeply (Days 3-5)
- Those 10 run /coach daily during Passover
- Collect their feedback, iterate the skill
- They start sharing their streaks organically

### Phase 3: The Post (Days 5-7)
- Community post shows: YOUR 62-day streak + THEIR 5-day streaks
- Not "I built a tool" but "10 founders tried this over Passover. Here's what happened."
- Demo video: 30 seconds of a real morning /coach session
- Download link in first comment

### The Story (community post angle)
"62 days ago I started talking to an AI coach every morning. Not ChatGPT. Not a chatbot. A system that remembers my goals, tracks my decisions, and tells me exactly what to do.

I didn't miss a single day.

This Passover, I cleaned it up and gave it to 10 founders. Here's what they said after 5 days..."

## Success Criteria

- [ ] Install in under 30 seconds
- [ ] First session delivers value in under 2 minutes
- [ ] Streak tracking works across sessions
- [ ] Memory persists and improves
- [ ] LinkedIn post generation works on first try
- [ ] Calendar integration optional but functional
- [ ] Decision log captures and resurfaces decisions
- [ ] Weekly review gives real percentage scores
- [ ] Personality feels like a real coach, not a chatbot
- [ ] 10 founders can install and use independently

## 2-Day Build Plan

### Day 1: Core Engine
- SKILL.md (routing: morning/evening/weekly, first-run flow)
- agents/coach.md (personality, behavior rules, action generation)
- memory/context.md template (auto-created on first run)
- templates/scoreboard.md
- templates/decision-log.md
- Streak tracking logic
- Evening check-in flow

### Day 2: Polish + Distribution
- references/linkedin-guide.md (post creation skill)
- Calendar integration (optional MCP)
- references/godin-principles.md
- Test full loop: first run → morning → evening → morning → weekly
- Record demo video (30 sec)
- Write community post
- DM 10 founders

---

*"You don't need more information. You need the guts to make a decision and the discipline to follow through. That's what I'm here for."*
— The Founder Coach
