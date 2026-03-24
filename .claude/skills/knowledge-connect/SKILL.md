---
name: knowledge-connect
description: |
  Re-scan notes for connections and backlinks. Useful as the vault grows
  and new notes may relate to older ones that weren't connected at ingestion time.

  Triggers on: find connections, connect notes, knowledge connect, link notes,
  discover connections, rescan connections
allowed-tools:
  - Read
  - Edit
  - Glob
  - Grep
---

# Knowledge Connect

Re-scan notes in the theKnowledge vault for connections and create `[[backlinks]]` between related notes.

## Vault Location

`/Users/nunoduarte/Desktop/FeeltheVibe/theKnowledge/`

## Before Starting

1. Read `memory.md` for context.
2. Read `_meta/tags-registry.md` for the tag landscape.

## Usage Modes

### Mode 1: Specific Note
User says "find connections for [[note-name]]" or provides a note path.
→ Run the connection algorithm on that single note.

### Mode 2: Recent Notes
User says "connect recent notes" or "rescan connections".
→ Read `_meta/processing-log.md`, find items ingested in the last 7 days, run the connection algorithm on each.

### Mode 3: Full Vault Scan
User says "rescan all connections".
→ Glob all notes in `01-sources/`, `02-concepts/`, `03-arguments/`, `04-models/`. Run on each (start with those that have the fewest `related_*` entries).

## Connection Algorithm

For each target note:

1. **Extract key terms**: Read the note and extract: all tags, concept names mentioned, author names, and distinctive phrases.

2. **Search the vault**: For each key term, Grep across:
   - `01-sources/` (other sources)
   - `02-concepts/` (concept definitions)
   - `03-arguments/` (claims and evidence)
   - `04-models/` (frameworks)

3. **Filter candidates**: Skip notes that are already linked in the target note's frontmatter.

4. **Read candidates**: Read the top 5-10 matching notes (frontmatter + summary only).

5. **Classify connection**:
   - **Direct**: Same concept discussed → link with note: "discusses same concept"
   - **Supporting**: Builds on or strengthens → link with note: "supports/extends"
   - **Contradicting**: Opposing view → link with note: "contradicts/challenges"
   - **Tangential**: Loose thematic similarity → do NOT link

6. **Write links**: For Direct, Supporting, and Contradicting:
   - Add to target note's `related_sources` or `related_concepts` in frontmatter
   - Add a backlink in the other note pointing back to the target
   - Include a one-line annotation explaining the connection

## After Connecting

- Update `memory.md` Session Log with what was connected.
- If interesting patterns emerge (e.g., many notes converge on a topic), note this in `memory.md` Learning Journal and suggest the user run `/knowledge-synthesize`.

## Report to User

```
Scanned: <note title>
New connections found: <count>
- [[note-a]] — <connection type>: <annotation>
- [[note-b]] — <connection type>: <annotation>
Suggestion: <if applicable, suggest synthesis>
```
