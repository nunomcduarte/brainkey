---
name: knowledge-chat
description: |
  Ask questions grounded in your personal knowledge base. Answers reference
  YOUR sources and positions, not generic AI knowledge.

  Triggers on: based on my knowledge, what do my notes say about,
  knowledge chat, ask my knowledge base, what have I learned about,
  from my sources
allowed-tools:
  - Read
  - Glob
  - Grep
---

# Knowledge Chat

Answer questions grounded in the user's personal knowledge vault. Every claim should reference specific sources from Second Brain vault.

## Vault Location

`/Users/nunoduarte/Desktop/FeeltheVibe/theKnowledge/`

## Before Starting

1. Read `memory.md` — especially Evolving Positions (to calibrate the answer to the user's current thinking) and Knowledge Gaps (to flag when the vault lacks information).
2. Read `_meta/tags-registry.md` for the tag landscape.

## Answering Process

1. **Parse the question**: Identify the core topic, any specific domains, and what kind of answer is needed (factual, opinion-based, comparison, etc.).

2. **Search the vault**:
   - Grep for key terms from the question across all note folders
   - Read relevant MOCs from `07-maps/` for the topic's domain
   - Check `_meta/sources-index.md` for relevant sources
   - Check `05-synthesis/` for existing synthesis notes on the topic

3. **Load relevant notes**: Read the top 5-15 most relevant notes. Prioritize:
   - Synthesis notes (already cross-referenced)
   - Concept notes (atomic definitions)
   - Source summaries (primary evidence)
   - Arguments (specific claims)

4. **Compose the answer**:
   - Ground every claim in a specific note: "According to [[src-...]], ..."
   - Use the user's Evolving Positions from `memory.md` to calibrate tone
   - Clearly distinguish between:
     - "Your sources say..." (grounded in vault)
     - "Your current position is..." (from Evolving Positions)
     - "I'd add that..." (Claude's own knowledge, clearly labeled)
   - If the vault has a Knowledge Gap on this topic, say so: "Note: your vault doesn't have counterarguments on this yet."

5. **Suggest follow-ups**:
   - Related notes the user might want to revisit
   - Knowledge gaps to fill
   - Synthesis opportunities

## Response Format

Answer the question directly first, then provide sources:

```
[Direct answer grounded in vault sources]

**Sources from your vault:**
- [[note-1]] — how it's relevant
- [[note-2]] — how it's relevant

**Gaps:** [if applicable, what's missing from the vault on this topic]

**Related notes you might revisit:** [if applicable]
```

## Important Rules

- NEVER make up sources or pretend a note exists when it doesn't.
- If the vault has nothing on the topic, say so honestly and offer to help the user find and ingest relevant content.
- When the vault has contradicting sources, present both sides, don't pick one.
- Update `memory.md` Session Log after answering.
