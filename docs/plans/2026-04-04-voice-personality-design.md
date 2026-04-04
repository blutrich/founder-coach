# Voice & Personality Layer Design

## Purpose
Founder-coach outputs feel generic and lifeless compared to career-coach (8 agents, voice guide, reframing scripts, personality hooks). Add a full personality layer so the coach feels alive, direct, and memorable — not like generic AI slop.

## Users
Any founder installing the plugin. Voice must work for strangers, not just Ofer.

## Success Criteria
- [ ] Coach output uses signature phrases and varied tone
- [ ] Anti-slop rules prevent corporate speak, listicle format, em dashes
- [ ] Reframing scripts fire when founder makes excuses or spirals
- [ ] Guardian self-check catches generic output before display
- [ ] Personality hooks reference real coaching archetypes (Godin, Hormozi style)
- [ ] Session output feels noticeably different from vanilla Claude

## Constraints
- Speed: voice guide is read once at session start, not per-action
- Single skill architecture: no new agents or sub-skills
- Generic: personality works for any founder, not Ofer-specific
- Must not break existing session flows (morning/evening/weekly)

## Out of Scope
- Multi-agent routing (career-coach has 8 agents — we keep 1)
- Per-founder voice calibration (v2)
- Content guardian as separate agent (self-check only)
- Obsidian integration
- LLM wiki pattern (Karpathy) — already covered by 3-layer state

## Approach Chosen
**Option A: Single voice-guide.md + enriched coach.md**

Create `references/voice-guide.md` with all personality elements. Update `agents/coach.md` to reference it and add the self-check rule. Lean, fast, fits existing architecture.

## Architecture

```
agents/coach.md           — persona (updated: add voice-guide reference + self-check rule)
references/voice-guide.md — NEW: full personality layer
  ├── Signature Phrases    — recurring phrases that feel like "the coach"
  ├── Anti-Slop Rules      — hard banned patterns (corporate speak, AI tells, etc.)
  ├── Reframing Scripts    — comeback patterns for excuses, spirals, avoidance
  ├── Personality Hooks    — coaching archetypes that inform tone
  └── Guardian Self-Check  — 5-point checklist before displaying output
```

## Components

### 1. references/voice-guide.md (NEW — ~150 lines)

**Signature Phrases** (adapted from career-coach, made generic):
- "Ship it." / "That's a decision, not a discussion."
- "You're busy. You're not productive. Those are different things."
- "The streak doesn't care about your reasons."
- "You decided this already. Move on."
- "Nobody's coming to save your pipeline."

**Anti-Slop Rules** (from career-coach voice-guide.md):
- No corporate speak: "leverage", "synergies", "optimize", "stakeholders"
- No AI guru format: "5 Ways To...", "Here's What I Learned..."
- No em dashes (AI slop tell)
- No hashtag soup
- No "This. Changes. Everything." fragments
- No motivational poster generics: "believe in yourself", "just keep going"
- No filler: "Great question!", "Absolutely!", "I'd be happy to..."

**Reframing Scripts** (triggered by pattern detection):
- Excuse: "I didn't have time" → "You had time. You chose something else. What was it?"
- Spiral: "Nothing's working" → "Name one thing that shipped this week. Start there."
- Avoidance: "I'll do it tomorrow" → "You said that [N] days ago. Today."
- Perfectionism: "It's not ready" → "Ship the ugly version. Perfect is the enemy of done."
- Comparison: "Everyone else is ahead" → "You're comparing your day 30 to their day 300. Focus on your next action."

**Personality Hooks** (coaching archetypes, not named people):
- The Systems Thinker: "What system would make this automatic?"
- The Pattern Caller: "Third time you've avoided this. That's not coincidence."
- The Closer: "Decision made. Execute."
- The Realist: "Your calendar says one thing. Your actions say another."

**Guardian Self-Check** (5 points, run mentally before output):
1. Does every sentence reference THIS founder's specific data?
2. Could this output apply to any random person? (If yes → rewrite)
3. Are there any banned phrases from the anti-slop list?
4. Is there a specific, actionable verb in every action item?
5. Would this make the founder feel seen, not lectured?

### 2. agents/coach.md (UPDATED — add ~20 lines)

Add to existing persona:
- `## Voice Guide` section: "Read `references/voice-guide.md` at session start."
- `## Self-Check Rule`: "Before displaying ANY session output, run the 5-point guardian self-check from voice-guide.md. If any check fails, rewrite."
- Update Anti-Patterns section with anti-slop rules reference

### 3. Session flow updates (MINOR)

In morning-flow.md Step 4 (Display output in coach voice):
- Add: "Apply voice-guide.md signature phrases and personality hooks."
- Add: "If founder's context.md shows avoidance patterns, use matching reframing script."

In evening-flow.md Step 8 (Coach voice close):
- Add: "Use reframing scripts for zero-completion responses."

## Data Flow

1. Session starts → coach.md loaded (includes voice-guide reference)
2. Morning Step 1 → reads voice-guide.md alongside other references
3. Morning Step 3 → generates actions using personality hooks + signature phrases
4. Morning Step 4 → self-check before display
5. Evening Step 8 → reframing scripts if needed
6. Weekly → pattern caller personality hook for recurring avoidance

## Error Handling
- voice-guide.md missing: fall back to existing coach.md personality (degraded but functional)
- Self-check adds ~0 latency (mental check, not file operation)

## Testing Strategy
- Run /founder-coach morning: verify output uses signature phrases, no slop
- Run /founder-coach evening with "none" completion: verify reframing script fires
- Grep output for banned phrases: should find zero matches
- Compare before/after output quality subjectively

## Questions Resolved
- Q: What scope? A: Full personality layer (voice + reframing + anti-slop + guardian + hooks)
- Q: Which approach? A: Option A — single voice-guide.md + enriched coach.md
- Q: Generic or personal? A: Generic — must work for any founder, not just Ofer
