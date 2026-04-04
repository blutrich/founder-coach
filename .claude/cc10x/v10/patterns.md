# Project Patterns
<!-- CC10X MEMORY CONTRACT: Do not rename headings. Used as Edit anchors. -->

## User Standards

## Architecture Patterns
- Claude Code plugin: .claude-plugin/plugin.json + skills/{name}/SKILL.md
- Single skill with internal routing (session detection via streak.json)
- Hybrid memory: native Claude Code memory (fuzzy) + structured state files (exact)
- Config created on first-run from templates/ (user-editable, commented)
- State auto-managed by coach (streak.json, scoreboard.md, decisions.md)

## Code Conventions

## File Structure
- .claude-plugin/plugin.json — manifest
- skills/coach/SKILL.md — routing engine (NOT at repo root)
- agents/coach.md — persona
- templates/ — 7 files (5 config + 2 state)
- references/ — linkedin-guide.md, godin-principles.md
- config/ and state/ — created at runtime, NOT in repo

## Testing Patterns

## Common Gotchas
- Plugin hooks: hooks/hooks.json at plugin ROOT, NOT .claude-plugin/hooks/. No "hooks" field in plugin.json.
- Stop hook may not fire — always have SKILL.md fallback for critical ops like git sync
- config/ has personal data (identity, linkedin) — .gitignore when git sync enabled
- `grep -v '.claude'` in file listings also excludes `.claude-plugin/` — use `grep -v '/.claude/'` instead
- Comment detection in templates: use specific patterns like `goal_N:` not generic `#` prefix check
- README.md shows SKILL.md at root — must be skills/coach/SKILL.md for plugin format
- README install command uses `claude skill add` — may need `claude plugin add` for plugin format
- README first-run table omits config/strategy.md
- SPEC.md references memory/context.md — superseded by native Claude Code memory in design
- Quarterly strategy reset in SPEC not included in plan — needs explicit defer or implementation

## API Patterns

## Error Handling

## Dependencies

## Project SKILL_HINTS

## Last Updated
2026-04-03
