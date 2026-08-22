---
name: stage
description: Diagnose which startup stage the founder is in (Idea, MVP, Launch, Scale) using the Founder's Playbook exit criteria, score the criteria from the founder's own files, and recommend staying, advancing, or moving back. Use this when the founder asks "what stage am I", "am I ready to launch/scale", "should I be building or talking to users", or when the coach suspects stage mismatch (building at Idea, discovery at Scale). Also use it in onboarding and monthly.
argument-hint: "[optional: what changed recently]"
context: fork
agent: founder-coach:coach
background: false
model: sonnet
allowed-tools: Read, Grep, Glob, Write
---

# Stage Diagnosis

Read `${CLAUDE_PLUGIN_ROOT}/references/stage-playbook.md` first. Then read whatever exists of `config/startup.md`, `config/identity.md`, `config/goals.md`, `state/context.md`, `state/progress.md`, `state/scoreboard.md`. The stage the founder *claims* is in identity/startup; the stage the *evidence* supports is what you are here to find.

$ARGUMENTS

## Procedure

1. State the claimed stage in one line.
2. Score the exit criteria of that stage from evidence in the files only. For each criterion: met / not met / no evidence, with the line of evidence (a number, a date, a decision). No evidence counts as not met; say so plainly, founders fill that gap fast once it's named.
3. Check the stage below: are *its* exit criteria actually met? If not, the founder skipped a stage and the real stage is the lower one.
4. Name the stage's failure mode the founder is currently closest to (from the playbook) with the evidence.
5. Verdict: stay / advance / move back, and the single criterion that would change the verdict.
6. Write `config/stage.md`: `stage: <idea|mvp|launch|scale>`, a dated line of reasoning, and the exit-criteria checklist with current marks. Overwrite previous content.

## Output

Under 180 words. Verdict first. Then the checklist as a short list with marks. End with one action that moves the weakest criterion this week, tied to a goal. Apply the voice rules in `${CLAUDE_PLUGIN_ROOT}/references/voice-guide.md`.
