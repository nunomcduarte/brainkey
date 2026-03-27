---
name: knowledge-synthesize
description: |
  Generate cross-source synthesis notes that surface patterns, convergences,
  tensions, and gaps across the knowledge vault.

  Triggers on: synthesize knowledge, find patterns, knowledge synthesis,
  what patterns emerge, connect the dots, synthesize my notes
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Knowledge Synthesize

Generate synthesis notes that surface patterns across multiple sources in the Second Brain vault.

## Vault Location

`/Users/nunoduarte/Desktop/FeeltheVibe/theKnowledge/`

## Before Starting

1. Read `memory.md` — especially Evolving Positions and Knowledge Gaps.
2. Read `_meta/tags-registry.md` and `_meta/sources-index.md` for an overview.

## Usage Modes

### Mode 1: Domain Synthesis
User says "synthesize my knowledge on Bitcoin" or similar.
→ Read `07-maps/MOC-Bitcoin.md`, load the source summaries it references, look for patterns.

### Mode 2: Tag Synthesis
User says "synthesize notes tagged with <tag>".
→ Search `_meta/tags-registry.md` for the tag, load all notes that use it.

### Mode 3: Time-based Synthesis
User says "synthesize this week's additions" or "synthesize recent notes".
→ Read `_meta/processing-log.md`, gather items from the specified period.

### Mode 4: Cross-domain Synthesis
User says "how do Austrian Economics and Bitcoin connect in my notes?"
→ Load both MOCs, find overlapping concepts and sources, synthesize.

### Mode 5: Auto-discover
User says "find patterns" with no specific scope.
→ Read all MOCs, identify the domains with the most recent activity, synthesize the 2-3 most active areas.

## Synthesis Process

1. **Gather materials**: Load the relevant source notes (summaries and key takeaways — not full source material). Aim for 5-15 sources per synthesis.

2. **Detect patterns**: Look for:
   - **Convergence**: Multiple sources making the same argument from different angles
   - **Tension**: Sources that contradict each other or present opposing views
   - **Evolution**: Ideas that build on each other chronologically
   - **Gap**: Topics the user reads about but has no counterargument or alternative perspective

3. **Write synthesis note**: Use `_templates/synthesis.md`:
   - UID: `syn-YYYYMMDD-<slug>`
   - `pattern_type`: convergence, tension, evolution, or gap
   - Evidence chain linking back to specific sources
   - Clear statement of what the pattern means
   - Tensions and open questions
   - Implications for the user's thinking or action

4. **Save** to `05-synthesis/`.

5. **Update MOCs**: Add the synthesis note to relevant `07-maps/MOC-*.md` files under `## Synthesis Notes`.

6. **Update Memory**:
   - **Learning Journal**: Add the key insight from this synthesis
   - **Evolving Positions**: If the synthesis changes or strengthens a position, update it
   - **Knowledge Gaps**: If the synthesis reveals gaps, add them
   - **Session Log**: Log what was synthesized

## Quality Standards

- A synthesis note must reference at least 3 sources. If fewer than 3 are relevant, note this as a gap instead of forcing a synthesis.
- The "Connection" section should provide a genuine insight, not just "these sources are about the same topic."
- Always include tensions or open questions — synthesis should surface complexity, not flatten it.
- Write in clear, accessible language. The user values turning complex content into easy-to-understand formats.

## Report to User

```
Synthesis: <title>
Pattern: <convergence|tension|evolution|gap>
Sources synthesized: <count>
Key insight: <1-2 sentence summary>
Open questions: <bullet list>
Saved to: 05-synthesis/<filename>
```
