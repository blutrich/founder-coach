# Founder Coach

> Most of us have more agency than we admit.

We deny it because freedom is frightening. Freedom comes with responsibility. And responsibility means you can't blame the algorithm, the market, the timing, or the competition.

So we stay still. We embrace being stuck. We whine instead of lead.

The systems around us are optimized for obedience. Post when the algorithm says. Pivot when the market shifts. Build what the accelerator wants. Choose from the cards they show you, without ever seeing the full deck.

This tool exists because you have a choice. And without a nudge, the easiest thing to do is nothing.

---

## What This Is

A Claude Code skill that acts as your co-founder. The one who actually pays attention.

Every morning it reads your goals, your calendar, your patterns, and the decisions you've already made. Then it tells you what to do. Not asks. Tells.

Every evening it checks: did you do it?

Every week it reflects: are your actions moving your goals, or are you just busy?

It remembers everything. It tracks your streak. It won't let you revisit decisions you already made. It drafts your LinkedIn posts from what you actually built, not what sounds impressive.

One command: `/founder-coach`

---

## Why

Seth Godin writes: "Big problems demand small solutions."

The big problem is that founders are scattered. The tempting solution is to drop everything and declare war on your habits.

But that's not how the problem got here. It got here one skipped morning at a time. One revisited decision at a time. One "I'll post tomorrow" at a time.

So the fix is the same size. One command. Every morning. 3 actions.

Not a revolution. A system. And systems compound.

---

## The 62-Day Proof

I built this for myself. I'm not a developer. I'm what some call "the new technical class" — I build with AI agents the way others build with code.

I was overwhelmed: too many projects, too many decisions that kept coming back, content I never shipped. I needed something that would tell me what to do and not let me forget what I decided.

62 days later, I haven't missed a single session.

200+ decisions tracked. 30+ LinkedIn posts shipped. The coach caught me 4 times trying to revisit decisions I'd already made. It learned I avoid outreach on Mondays and started pushing harder on Tuesdays.

This isn't a demo project. This is a system I depend on every day.

---

## Quick Start

**Step 1:** Get Claude Code from [claude.ai/code](https://claude.ai/code) (if you don't have it)

**Step 2:** Inside Claude Code, run:
```bash
/plugin marketplace add blutrich/founder-coach
```

**Step 3:** Start coaching:
```bash
/founder-coach
```

That's it. The coach introduces itself, asks you 3 quick questions, and gives you Day 1's actions. No config files to edit. No setup homework. Coaching in under 60 seconds.

Works everywhere Claude Code runs: **CLI**, **Desktop app**, **VS Code**, **JetBrains**.

### One-Line Install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/blutrich/founder-coach/main/install.sh | bash
```

Then inside Claude Code:
```bash
/plugin                # select founder-coach → Install
/founder-coach         # Day 1 starts
```

### Manual Install

```bash
git clone https://github.com/blutrich/founder-coach.git ~/.claude/plugins/marketplaces/founder-coach
```

**GitHub:** [github.com/blutrich/founder-coach](https://github.com/blutrich/founder-coach)

### Daily Use

**Morning:** `/founder-coach` gives you 3 actions. Go do them.

**Evening:** `/founder-coach` asks what you completed. Updates your scoreboard.

**Friday:** `/founder-coach` runs your weekly review. Score, patterns, next week's priorities.

---

## What It Does

**Tells, doesn't ask.** "Here's what you're doing today" — not "What would you like to work on?"

**Tracks your streak.** The streak breaks when you skip the session, not when you skip an action. Showing up is the minimum. The rest compounds.

**Logs your decisions.** "I decided X because Y." The coach reviews them weekly: "Still holding?" If you've revisited something 3 times, it calls it out.

**Writes your LinkedIn posts.** Drafts from what you actually did this week, in your voice, for your audience. Not generic. Yours. You edit, you ship.

**Reads your calendar.** Preps you for meetings. Detects deep work windows. Adjusts actions when your day is packed.

**Learns your patterns.** Uses Claude Code's native memory. Over time it knows: you avoid outreach, you ship better in mornings, you revisit decisions under stress.

**Compounds over time.** Day 1 the coach barely knows you. Day 30 it knows which actions you complete and which you avoid. Day 60 it knows you better than you know yourself. Every session makes the next one sharper. That's the opposite of a todo app, which is exactly as dumb on day 100 as day 1.

---

## Architecture

```
founder-coach/
├── .claude-plugin/
│   └── plugin.json       # Plugin manifest
├── skills/
│   └── coach/
│       └── SKILL.md      # The engine — routing, session flows, all logic
├── agents/
│   └── coach.md          # Coach persona and behavior rules
├── templates/            # Scaffolding (copied to config/ and state/ on first run)
│   ├── goals.md          # Goal template
│   ├── identity.md       # Identity template
│   ├── strategy.md       # Strategy framework template
│   ├── linkedin.md       # LinkedIn config template
│   ├── calendar.md       # Calendar config template
│   ├── scoreboard.md     # Scoreboard template
│   └── decisions.md      # Decision log template
├── references/           # Static coaching knowledge
│   ├── linkedin-guide.md # Post structure, voice calibration, anti-patterns
│   └── godin-principles.md # 9 coaching principles
├── config/               # Your setup (created on first run, user-editable)
│   ├── goals.md          # Your 1-3 quarterly goals
│   ├── identity.md       # Who you are, strengths, weaknesses
│   ├── strategy.md       # 6-section strategy framework
│   ├── linkedin.md       # Content creation config
│   └── calendar.md       # Calendar integration
└── state/                # Precise tracking (auto-managed by coach)
    ├── scoreboard.md     # Weekly targets vs actuals
    ├── decisions.md      # Timestamped decision log
    └── streak.json       # Streak counter + session history
```

Note: `config/` and `state/` directories are created on first run. They are not included in the repository — each user gets their own.

**No dependencies.** No external services. No accounts. No subscriptions. Everything lives on your machine.

**Calendar** is optional (Google Calendar via MCP). Enhances coaching but not required.

---

## Where Your Data Lives

Everything is local. Here's exactly what gets created and where.

### You control (config/)

These files are yours. Edit them anytime.

| File | What's in it | Created by |
|------|-------------|------------|
| `config/goals.md` | Your 1-3 quarterly goals | Onboarding questions |
| `config/identity.md` | Your weakness, role, work days | Onboarding + you |
| `config/strategy.md` | 6-section strategy framework | You (optional) |
| `config/linkedin.md` | LinkedIn posting preferences | Onboarding + you |
| `config/calendar.md` | Google Calendar connection | You (optional) |

### Coach manages (state/)

The coach reads and writes these every session. You can read them anytime, but don't edit them manually.

| File | What's in it | Why it matters |
|------|-------------|---------------|
| `state/streak.json` | Streak counter + full session history | Tracks every morning/evening/weekly check-in |
| `state/scoreboard.md` | Weekly targets vs actuals by day | Shows what you actually did, not what you planned |
| `state/decisions.md` | Timestamped decision log with rationale | Catches you when you revisit decided things |
| `state/context.md` | Working memory: last session, next priority, your profile | How the coach remembers between sessions |
| `state/patterns.md` | Coaching patterns: what works, what you avoid | How the coach gets smarter over time |
| `state/progress.md` | Session log + weekly history | Hard evidence for pattern detection |

### Claude Code memory (automatic)

The coach also writes to Claude Code's native memory (`~/.claude/` directory) with proper YAML frontmatter. This means your coaching context is available across **all** Claude Code conversations, not just `/founder-coach`. You don't need to manage this — it happens automatically.

### Nothing leaves your machine

No telemetry. No analytics. No external API calls. No accounts. Config, state, and memory all live on your local filesystem. The only network call is to Claude's API (which Claude Code handles), and optionally Google Calendar if you enable it.

---

## The Philosophy

> "Find 10 people who trust you, respect you, need you, listen to you." — Seth Godin

This isn't a product launch. I'm not optimizing for downloads.

I'm looking for 10 founders who recognize themselves in this:

- You know what to do. You just don't do it.
- You start every week with priorities. You end it with none of them done.
- You've made the same decision three times this month.
- You have a LinkedIn draft from two weeks ago that you never published.

If that's you, install it. Run `/founder-coach` tomorrow morning. Tell me what happens after a week.

---

## Privacy

Everything is local. Config files, state files, and Claude Code memories all live on your machine. Nothing is sent to external services. No telemetry. No analytics. No data collection.

## License

MIT

## Credits

Built by [Ofer Blutrich](https://linkedin.com/in/oferblutrich) — AI Product Builder at Base44. Former founder. Former national climbing champion. Built this because he's been in the founder seat and knows what's missing.

Inspired by Seth Godin's "This Is Strategy" — systems thinking applied to personal execution.

---

> A blueprint is an assertion. It imagines what it will take to create and what it will be like to inhabit. It's a chance to live in a future that hasn't happened yet.
>
> Your strategy lives in four dimensions. Not simply a drawing of what you're hoping for — it includes time, and interactions. Step and response. Trial and improvement.
>
> Tomorrow is going to be here soon. Whether you plan for it or not.
>
> Showing up without a strategy is like building without a plan. It might work out, but it's unlikely.
>
> `/founder-coach` is the plan. Run it tomorrow morning.
