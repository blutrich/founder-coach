# Founder Coach — Landing Page Content

---

## Hero

**I talked to an AI coach every morning for 62 days. I didn't miss one.**

Not a chatbot. Not a todo app. A system that remembers my goals, tracks my decisions, and tells me exactly what to do next.

Because if you sell your time at the lowest possible price, you'll always be busy helping someone else get to where they're going. The coach makes sure your time goes toward the change YOU seek to make.

`/coach` — one command, every morning.

[Install in 30 seconds] [See my real scoreboard]

---

## The Problem

You know what to do. You just don't do it.

You start Monday with 3 priorities. By Wednesday you've revisited 2 of them. By Friday you shipped none and added 4 new ones. You told yourself you'd post on LinkedIn this week. You didn't. You made a decision on Tuesday. You unmade it on Thursday.

This isn't a productivity problem. It's a systems problem.

You don't need another task manager. You need someone who won't let you bullshit yourself.

---

## Why We Built This

Seth Godin writes: "Big problems demand small solutions."

The big problem: founders are scattered. Too many goals, no accountability, decisions that get revisited endlessly, content that never ships.

The tempting solution: drop everything, buy a course, hire a coach at $500/hour, declare war on your habits.

But that's not how the problem got here.

It got here one skipped morning at a time. One revisited decision at a time. One "I'll post tomorrow" at a time.

So the fix is the same size: one command, every morning, 3 actions. Not a revolution. A system.

We didn't build a productivity tool. We built a feedback loop that changes how you make decisions — the same way the problem built itself, except in reverse.

---

## How It Works

### Morning: You run `/coach`

The coach reads your goals, your calendar, your patterns, and your past decisions. Then it tells you what to do. Not asks. Tells.

```
Day 23. Streak alive.

You told me your #1 goal is revenue. You spent the last 3 days
on a website redesign. Those don't connect.

Your 3 actions today:

1. Send the proposal to the client you've been avoiding. Here's the draft.
2. Ship the LinkedIn post I wrote for you last night. It's about what
   you actually built this week, not what you think sounds impressive.
3. Your calendar is empty until 14:00. That's 5 hours of deep work.
   Don't open email until after lunch.

Go. Report back tonight.
```

### Evening: You check in

What did you complete? The coach updates your scoreboard. Only confirmed completions count. No self-reported vanity metrics.

Then it asks: "Any decisions worth recording today?"

You type: "Decided to stop taking investor meetings until 10K MRR."

Next week, when someone DMs you about funding, the coach will say: "You decided no investor meetings until 10K MRR. That was Tuesday. The answer is no. Move on."

### Friday: The scoreboard

Weekly score. What you hit, what you missed, what pattern keeps showing up. The coach doesn't judge. It reflects. Then it gives you next week's 3 priorities.

---

## The Decision Log

This is the thing nobody else has.

Founders don't fail because they make bad decisions. They fail because they make the same decision five times. Each time feels like the first time. Each time wastes a week.

The coach writes down every decision with your rationale. Then it reviews them weekly: "You decided X on March 3rd because Y. Still holding?"

If you've revisited a decision 3 times, the coach calls it: "Either commit or change it. But stop circling."

---

## LinkedIn Built In

You know you should post. You don't. The coach knows this about you (it's in your config under "weakness: content").

So every morning, one of your 3 actions is content. Not generic content — a post about what you actually built or decided this week, written in YOUR voice, calibrated to YOUR audience.

The coach doesn't write for you. It drafts for you. You edit, you ship. The point is: you ship.

---

## Why This Compounds (and other tools don't)

Every productivity app promises to change your life on day 1. Most are abandoned by day 3. Here's why the Coach is different.

A useful system has three attributes:

**1. It gets easier over time.** Past success makes future success more likely.

On day 1, the coach knows nothing about you. It reads your config and gives generic-ish actions. By day 7, it knows your patterns. By day 30, it knows which actions you complete and which you avoid. By day 60, it knows you better than you know yourself. The memory compounds. Every session makes the next one sharper.

This is the opposite of a todo app, which is exactly as dumb on day 100 as it was on day 1.

**2. It's a welcome contribution to your work.** Not a tax on your time.

Nobody wants another dashboard to maintain. The coach takes 2 minutes in the morning and 1 minute at night. The rest of the day, it's invisible. When it surfaces a LinkedIn draft, it's based on what you actually did — not homework you need to invent. When it preps you for a meeting, it saved you 10 minutes of re-reading your calendar.

The best tools don't feel like tools. They feel like a co-founder who pays attention.

**3. It's resilient.** When the world changes, the system adjusts.

Your goals change? Edit `config/goals.md`. New quarter, new priorities, same streak. Your calendar explodes? The coach detects it and gives you one action instead of three. You pivot your company? The decision log captures why, and the coach stops optimizing for the old direction.

The system doesn't break when your life changes. It's designed for the fact that it will.

**The unseen driver: time.**

The journey to results is an investment. It doesn't work the first day. The streak counter showing "Day 1" is the least impressive moment of the entire system. Day 1 is just a promise.

But day 7, you notice you're doing what you said. Day 14, you haven't revisited a decision. Day 30, your LinkedIn has actual content on it. Day 60, people ask what changed.

Nothing changed. You just invested time in a system that compounds, instead of starting over every Monday.

---

## The Streak

62 days. That's my real number.

The streak doesn't break when you skip an action. It breaks when you skip the session. Showing up is the minimum. The rest compounds.

Day 1 feels like nothing. Day 7 you notice you're doing the things you said you'd do. Day 30 you realize you haven't revisited a single decision. Day 60 people ask what changed.

Nothing changed. You just stopped starting over.

---

## Built by a Founder, for Founders

I'm not a developer. I'm what some people call "the new technical class" — I build with AI agents the way a previous generation built with no-code tools.

I built this system for myself when I was overwhelmed at work: too many projects, too many stakeholders, too many decisions that kept coming back. I needed something that would tell me what to do in the morning and hold me accountable at night.

62 days later, I haven't missed a session.

The system tracked 200+ decisions. It generated 30+ LinkedIn posts. It caught me 4 times trying to revisit a decision I'd already made. It learned that I avoid outreach on Mondays and started pushing harder on Tuesdays.

Now it's yours.

---

## Technical Details

**What it is:** A Claude Code skill. One command: `/coach`.

**Setup:** Run `/coach` once. It creates 4 config files. Fill in your goals, your identity, your weakness. Run `/coach` again. Day 1 starts.

**Memory:** Uses Claude Code's native memory system. The coach writes memories with proper frontmatter — your coaching context is available across ALL your Claude Code conversations, not just /coach sessions. Structured state (streak, scoreboard, decisions) lives in dedicated files for precision.

**Onboarding:** Files over questions. No interactive Q&A. You fill in templates at your own pace, with self-documenting comments. Inspired by pipeline patterns in production agent systems.

**Calendar:** Optional Google Calendar integration. The coach reads your schedule, preps you for meetings, and detects deep work windows.

**LinkedIn:** Built-in content skill. Drafts posts from your real work and decisions, calibrated to your voice and audience. Not generic. Yours.

**Privacy:** Everything lives locally in your project directory and Claude Code's memory. Nothing is sent anywhere. No accounts. No subscriptions. No data collection.

```
founder-coach/
├── SKILL.md           — the engine
├── config/            — your goals, identity, linkedin, calendar
├── state/             — scoreboard, decisions, streak
├── agents/coach.md    — the personality
└── references/        — linkedin guide, coaching principles
```

Install:
```bash
claude skill add founder-coach
```

---

## The Godin Principle

> "Find 10 people who trust you, respect you, need you, listen to you."

This isn't a product launch. I'm not trying to get 1,000 downloads.

I'm looking for 10 founders who:
- Know they should post but don't
- Start every week with big plans and end with nothing shipped
- Make the same decisions over and over
- Need someone to say "stop overthinking, do this NOW"

If that's you, install it. Run it tomorrow morning. Tell me what happens.

The 10 of you become the proof. Not my 62 days — yours.

---

## FAQ

**Is this just a fancy todo list?**
No. A todo list stores what you want to do. The coach tells you what to do, based on your goals, your patterns, and the decisions you've already made. It's the difference between a notebook and a co-founder who actually pays attention.

**What if I disagree with the coach?**
Override it. The coach has opinions, not authority. But it will remember that you overrode it, and if a pattern forms, it will call that out too.

**Do I need to be technical?**
You need Claude Code installed. If you can type `/coach` in a terminal, you're technical enough.

**What does it cost?**
Nothing. It's open source. You need a Claude Code subscription (which you probably already have).

**Can I customize the personality?**
The coach persona is in `agents/coach.md`. It's a markdown file. Edit it to sound like whoever you need it to sound like.

**What about my data?**
Everything is local. Config files, state files, and Claude Code memories all live on your machine. Nothing leaves your computer.

---

## Seeing Strategy Clearly

Strategy is a flexible plan that guides us as we make decisions over time, within a system. The two hard parts: time and systems.

Time resets every morning. New chances. New decisions. That's why the coach runs daily, not weekly. A weekly review is an autopsy. A daily check-in is a steering wheel.

Systems involve other people and their interests. Your co-founder wants speed. Your investor wants metrics. Your customer wants the feature you deprioritized. The coach doesn't resolve these tensions. It makes them visible: "You decided X on Tuesday for reason Y. Today you're considering undoing it because of Z. Is Z bigger than Y, or are you just tired?"

Strategy demands humility. You can't predict the future. You can't control the system. But you can make better decisions today than you made yesterday, because today you have data from yesterday.

And strategy means considering not just YOUR actions, but the responses of everyone else: competitors, customers, partners, the market. The coach surfaces this too: "You decided to launch in April. Your competitor just announced for March. Does your timeline still hold, or do you need to adjust?"

If you sell your time at the lowest possible price, you'll always be busy helping someone else get to where they're going. Answering their Slack. Attending their meetings. Building their roadmap.

The coach asks every morning: "Are today's 3 actions moving YOUR goals, or someone else's?"

That's the whole game. Not a master plan. A daily practice of trading your time for the change you seek to make, not the change everyone else wants from you.

---

> "You don't need more information. You need the guts to make a decision and the discipline to follow through. That's what I'm here for."
>
> — The Founder Coach, Day 1
