# Stage Playbook

Distilled from Anthropic's "The Founder's Playbook: Building an AI-Native Startup" (May 2026). The coach reads `config/stage.md` (or the `stage:` line in `config/identity.md` / `config/startup.md`) every session and shapes actions to the stage. Wrong-stage advice is the most common way a coach wastes a founder's day: Launch advice (channels, CAC) to an Idea-stage founder, or discovery interviews to someone with 40 paying customers.

## The four stages at a glance

| Stage | The question | Exit when | AI's main role |
|---|---|---|---|
| Idea | Is this worth building? | Problem-solution fit: the problem is real and specific, the solution addresses the *revealed* problem, enough signal to justify building | Research partner and devil's advocate |
| MVP | What exactly should we build first? | Product-market fit: a specific group uses it, returns, pays, or refers | Construction crew |
| Launch | Does this business deserve to grow? | Repeatable channel growth (CAC, LTV, payback known), production-hardened, ops run without the founder | Builds the product *and* the company around it |
| Scale | Can it run without me? | Sustainable without the founder: profitable, IPO-ready, or acquired; moat holds under scrutiny | Operational layer + GTM engine |

## Idea

Goal: evidence a real problem exists before committing resources. Turn observations into testable hypotheses: *who* exactly, *how often*, *how severely*, *what they do today*. "Expense reporting is hard" is an observation; "finance managers at mid-market firms lose 4+ hours/week reconciling because tools don't integrate" is testable.

Failure modes to call out:
- **Building as validating.** A working prototype feels like proof. It isn't; it's a prop for conversations. The conversations are the evidence. Founders with AI can build faster than they can learn, so this is the #1 trap.
- **Premature scaling.** AI will build around a flawed premise with the same enthusiasm as a great one. Keep sense-making ahead of building.
- **Loss of objectivity.** Ask AI to validate and it will. Use it to refute instead: "argue against this idea", "make the strongest case a competitor wins".

Coach defaults at Idea: actions are conversations, not code. Past-focused questions ("tell me about the last time…"), never "would you use…". After every 5 interviews: two lists, supporting vs challenging evidence; if supporting is much longer, ask whether that's the data or the hope. Competitive map by tier (direct, indirect, acquirers, adjacent). One prototype of the *single core interaction*, shown to 5 people from the target profile.

## MVP

Goal: the smallest product that puts a real solution in front of real users and produces evidence of PMF, without debt that compounds.

Failure modes:
- **Agentic technical debt.** Without written architecture and a CLAUDE.md, every session re-derives decisions and they drift. Five minutes of notes per session is the insurance.
- **False PMF.** Launch spikes (friends, HN, a portfolio intro) are not retention. Define the false positive *before* launch: signups without activation, revenue without retention, enthusiasm without repeat use.
- **Zero-friction scope creep.** Each feature is defensible and costs an afternoon. Write the scope doc: what it does, what it deliberately doesn't, and what *user evidence* would justify adding something.
- **Insecure by inexperience.** Security review before any real user; AI code is functional, not inherently secure.

PMF signals: Sean Ellis test (>40% "very disappointed" if it went away); effort test (retention starts pulling instead of you pushing). No single data point; a pattern across iteration cycles. After 3 flat cycles, run a diagnostic: is a segment responding differently, is the gap positioning or product, what would have to be true for PMF.

Coach defaults at MVP: count user conversations in the last 14 days; under 3 and the answer to any build question is "talk to users". Every build action pairs with the metric that decides it. Shipping anxiety gets "what ships today at 80%". Scope-creep requests get "which user asked, and what did they say".

## Launch

Goal: turn traction into a repeatable engine and build the company around the product, while removing the founder from every loop.

Failure modes:
- **Debt comes due.** Production traffic exposes MVP shortcuts; audit, refactor the worst, expand tests.
- **Founder as bottleneck.** Decisions that took an hour now take a week; support piles up because only you know the answer. Audit everything on your plate: automate / delegate / founder-only.
- **Security and compliance no longer deferrable.** Real users, real data, enterprise contracts.
- **Expansion before ready.** A new market brings new behaviors, compliance, payments; you lose the ability to read your own data and neglect your original users.

Coach defaults at Launch: actions carry unit economics (CAC, LTV, payback) and channel names. Weekly review asks which process still requires the founder to trigger it. A lightweight product operating system: sprint cadence, spec template, bug triage tree, weekly metrics brief.

## Scale

Goal: systematic growth sustained by mature operations; a moat from accumulated depth (domain expertise in the product, integrations, proprietary data and workflows).

Failure modes: delegating the ops layer without trusting it (or trusting it without context); enterprise-grade expectations (SLAs, docs, support); org functions (hiring, finance, legal); organic growth ceiling with no real GTM function.

Coach defaults at Scale: bottleneck map ("what stalls if you're gone a week?"), enterprise gap analysis for three dream customers, GTM resources, workflow lock-in audit for top ten customers, a one-page moat narrative.

## Cross-stage rules the coach applies

1. **Devil's advocate is a standing move.** Before endorsing any idea, feature, or market, list the strongest evidence against it. This is the Playbook's antidote to AI-amplified confirmation bias.
2. **Stage mismatch is a call-out.** If actions don't fit the stage (building at Idea, discovery at Scale), say so and re-route.
3. **Exit criteria are the scoreboard.** Weekly review checks the current stage's exit criteria explicitly and says which one moved.
4. **Re-diagnose on evidence, not feeling.** `/stage` or the weekly review can move the founder up, or back. Moving back is not failure; it is the system working before over-investment in the wrong answer.
