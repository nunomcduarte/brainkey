# Second Brain — Project Instructions

A personal knowledge management vault powered by Claude Code. Ingestion, connection discovery, synthesis, and querying — all in markdown files, no external databases or APIs.

## Vault Structure

```
./ (project root)              ← your Second Brain vault
├── CLAUDE.md          ← You are here
├── README.md          ← Usage guide
├── memory.md          ← Lightweight memory index — READ THIS FIRST every session
├── memory-learnings.md ← Learning Journal (condensed insights)
├── memory-positions.md ← Evolving Positions on key topics
├── memory-gaps.md      ← Knowledge Gaps and blind spots
├── memory-patterns.md  ← Owner's patterns and preferences
├── 00-inbox/          ← Raw captures before processing
├── 01-sources/        ← Processed source notes (articles, tweets, podcasts, books, videos, discussions)
├── 02-concepts/       ← Atomic concept notes (one idea per file)
├── 03-arguments/      ← Claims with evidence chains
├── 04-models/         ← Mental models and frameworks
├── 05-synthesis/      ← Cross-source pattern notes
├── 06-briefs/         ← Generated output documents
├── 07-maps/           ← Maps of Content (MOC) per domain
├── 08-library/        ← Living knowledge docs per domain (compiled summaries, lessons, concept reference)
├── 09-reviews/        ← Daily, weekly, monthly learning review documents
├── _meta/             ← System indexes
│   ├── domains-registry.md   ← Single source of truth for domains
│   ├── processing-log.md     ← Append-only action log
│   ├── sources-index.md      ← Global source lookup (lightweight)
│   ├── tags-registry.md      ← Global tag lookup (lightweight)
│   ├── sources/              ← Domain-split source indexes (loaded on demand)
│   ├── tags/                 ← Domain-split tag files (loaded on demand)
│   ├── session-archive.md    ← Overflow from memory.md
│   ├── learnings-archive.md  ← Overflow from memory-learnings.md
│   ├── positions-archive.md  ← Overflow from memory-positions.md
│   └── gaps-archive.md       ← Overflow from memory-gaps.md
└── _templates/        ← Note templates
```

## Core Domains

Domains are managed in `_meta/domains-registry.md` — the single source of truth.
Read it to get active domains and their associated MOCs and library folders.
New domains emerge organically during ingestion or via the first-run wizard.

## First Run

If `_meta/domains-registry.md` is empty or has no data rows, the vault is fresh:
1. Ask the user: "What are your main areas of interest?" (provide examples like technology, philosophy, business, etc.)
2. For each domain the user provides, create:
   - A row in `_meta/domains-registry.md`
   - A MOC file at `07-maps/MOC-<Display-Name>.md`
   - A library folder at `08-library/<domain-slug>/`
   - A tags file at `_meta/tags/<domain-slug>.md` (with header row)
   - A sources file at `_meta/sources/<domain-slug>.md` (with header row)
3. If the user declines or says "skip": proceed with no domains. They will emerge organically as content is ingested.

## Session Protocol

**Every time you start working in this vault:**
1. Read `memory.md` (lightweight index, ~40-60 lines — always)
2. Based on the task, selectively read ONE OR TWO memory sub-files:
   - `memory-positions.md` — when answering questions or calibrating tone
   - `memory-gaps.md` — when planning ingestion or checking coverage
   - `memory-learnings.md` — when reviewing insights or writing reviews
   - `memory-patterns.md` — when tailoring output style
3. Read `_meta/domains-registry.md` to know active domains
4. **Load domain-specific indexes only when needed:**
   - If the task involves a specific domain, read `_meta/tags/<domain>.md` and `_meta/sources/<domain>.md`
   - If the task requires checking ALL tags (e.g., deduplication), read `_meta/tags-registry.md` (the global lightweight index)
   - NEVER load all domain-split files at once — that defeats the purpose
5. **If a memory file or index file doesn't exist yet, skip it.** Files are created on first use.
6. After meaningful work, update the appropriate memory file:
   - Session Log → `memory.md` (keep last 10, archive older to `_meta/session-archive.md`)
   - New insights → `memory-learnings.md`
   - Stance changes → `memory-positions.md`
   - New gaps → `memory-gaps.md`

## Frontmatter Schema

Every note MUST have this base frontmatter:

```yaml
---
uid: <type-prefix>-<YYYYMMDD>-<slug>
type: <source|concept|argument|model|synthesis|brief>
created: <YYYY-MM-DDTHH:MM:SS>
modified: <YYYY-MM-DDTHH:MM:SS>
status: <inbox|processing|live|stale>
tags: []
domains: []
confidence: <high|medium|low|contested>
---
```

### UID Prefixes
- `src-` for sources
- `con-` for concepts
- `arg-` for arguments
- `mod-` for models
- `syn-` for synthesis
- `brf-` for briefs

### Additional fields by type:
- **Sources**: `content_type`, `title`, `author`, `source_url`, `publication`, `date_published`, `date_captured`, `related_concepts`, `related_sources`
- **Tweet sources**: add `platform`, `thread_length`
- **Podcast sources**: add `podcast_name`, `episode_number`, `duration`, `guests`
- **Book sources**: add `isbn`, `publisher`, `year`, `chapters_read`
- **Concepts**: `aliases`, `first_seen_in`
- **Arguments**: `stance` (supports|opposes|nuances), `counterarguments`
- **Models**: (no additional required fields)
- **Synthesis**: `sources_synthesized`, `pattern_type` (convergence|tension|evolution|gap)
- **Briefs**: `grounded_in`, `brief_type` (landing-page|article|thread|email|presentation)

## File Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Source | `src-YYYYMMDD-<slug>.md` | `src-20240324-hayek-denationalisation.md` |
| Concept | `<Concept Name>.md` | `Cantillon Effect.md` |
| Argument | `arg-YYYYMMDD-<slug>.md` | `arg-20240324-bitcoin-fixes-debasement.md` |
| Model | `<Model Name>.md` | `Stock-to-Flow Model.md` |
| Synthesis | `syn-YYYYMMDD-<slug>.md` | `syn-20240324-ai-austrian-convergence.md` |
| Brief | `brf-YYYYMMDD-<slug>.md` | `brf-20240324-bitcoin-landing-page.md` |
| MOC | `MOC-<Domain>.md` | `MOC-Bitcoin.md` |

**Why the asymmetry:** Concepts and Models use natural-language filenames because they're the most-linked nodes — `[[Cantillon Effect]]` reads naturally in any note. Sources, arguments, syntheses, and briefs use date-prefixed slugs for chronological sorting.

## Tag Conventions

- Tags are **lowercase-hyphenated**: `austrian-business-cycle`, `monetary-policy`, `vibe-coding`
- Tags are **AI-discovered**, not from a fixed taxonomy
- Before creating a new tag, check `_meta/tags-registry.md` (global lookup). For full tag context, read `_meta/tags/<domain>.md` for the relevant domain
- Only mint a new tag when the content genuinely introduces a new concept not covered by existing tags

## Connection Discovery

When looking for connections between notes:
1. Extract key terms from the note (tags, concept names, author names, technical terms)
2. Grep across `01-sources/`, `02-concepts/`, `03-arguments/`, `04-models/` for each term
3. Read the top 5-10 matches
4. Classify connection strength:
   - **Direct**: same concept discussed explicitly → always link
   - **Supporting**: builds on or strengthens another note → always link
   - **Contradicting**: opposing view → always link (valuable!)
   - **Tangential**: shared domain but loose link → do NOT link
5. Write `[[backlinks]]` on BOTH sides of the connection with a one-line annotation

## Index Management

After every ingestion or significant edit:

### Global indexes (always update):
- `_meta/tags-registry.md` — add any new tags (one line per tag: `| tag | domain(s) | count |`)
- `_meta/sources-index.md` — add the new source entry (one row per source)
- `_meta/processing-log.md` — append the action

### Domain-split indexes (update for each relevant domain):
- `_meta/tags/<domain>.md` — add/update tags with full detail (tag, count, description, related concepts, first seen in)
- `_meta/sources/<domain>.md` — add source row with full metadata
- If the domain-split file doesn't exist yet, create it with a header row

### MOCs and Library:
- Update relevant `07-maps/MOC-*.md` files
- Update relevant `08-library/<domain>/` docs

### Index consistency rule:
The global `tags-registry.md` and `sources-index.md` are lightweight rollups. Every entry in a domain-split file MUST also appear (in abbreviated form) in the global file. The global file is the deduplication checkpoint; domain files hold the detail.

## Memory Updates

After meaningful work, update the appropriate memory file:
- **`memory-learnings.md`**: When a new insight or "aha moment" emerges (one line per insight)
- **`memory-positions.md`**: When new evidence shifts a stance
- **`memory-gaps.md`**: When you notice a missing counterargument or unexplored area
- **`memory-patterns.md`**: When you notice something about the owner's thinking
- **`memory.md` Session Log**: Always — briefly log what happened (keep last 10 entries, archive older to `_meta/session-archive.md`)

## Memory Scaling

Memory files have caps. When a file exceeds its cap, older content moves to an archive.
Archived content is NOT deleted — agents grep archive files when searching for old content.

### Caps

| File | Cap | Archive Location | Archival Method |
|------|-----|------------------|-----------------|
| `memory.md` session log | 10 entries | `_meta/session-archive.md` | Move oldest entries verbatim |
| `memory-learnings.md` | ~80 entries | `_meta/learnings-archive.md` | Consolidate related entries into thematic summaries (2-3 lines each), move originals to archive |
| `memory-positions.md` | ~30 positions | `_meta/positions-archive.md` | Move positions marked "settled" (no longer evolving) to archive |
| `memory-gaps.md` | ~50 gaps | `_meta/gaps-archive.md` | Move gaps marked "filled" or "deprioritized" to archive |
| `memory-patterns.md` | 10 bullets | (no archive) | Replace entries when patterns shift — this file stays lean |

### Consolidation (for memory-learnings.md)

When `memory-learnings.md` approaches ~80 entries:
1. Group related entries by theme (not by date)
2. Write a 2-3 line summary for each theme group
3. Move the individual entries to `_meta/learnings-archive.md`
4. Keep the thematic summaries in the active file
5. Add a note: _See `_meta/learnings-archive.md` for full history._

### Archival Rules

- Archives are append-only. Entries are never deleted from archives.
- When searching for old content, grep the archive files.
- Agents NEVER load archive files at session start. Archives are search targets, not reading material.
- Archive files do not have caps — they grow indefinitely (fine because they are never loaded into context).

### Memory File Creation

Memory files are created on first use, not pre-populated. If an agent needs to write to a memory file and it doesn't exist, create it using the template from `_templates/`.

## Maintenance Workflows

### Weekly (triggered by knowledge-review weekly or manually)
1. Check `memory.md` index is under 60 lines. If over, trim vault stats or move stale pointers.
2. Archive session log entries beyond the last 10 to `_meta/session-archive.md`.
3. Scan `memory-learnings.md` for duplicates. Merge entries that say the same thing in different words.
4. Review `memory-positions.md` — mark any positions as "settled" if confidence is now high and no recent challenges.
5. Prune `memory-gaps.md` — remove gaps already filled by recent ingestions.

### Monthly (triggered by knowledge-review monthly or manually)
1. Run the subtraction diagnostic on all memory files: for each entry, ask "if this were deleted, would any future session be worse?" If no, delete.
2. If `memory-learnings.md` exceeds ~80 entries, run consolidation (see Memory Scaling).
3. Archive settled positions and filled gaps.
4. Update vault stats in `memory.md`.
5. Verify global indexes match domain-split indexes (spot check 5-10 entries).

## Content Processing Quality

When processing content:
- Summaries should be 2-3 sentences, capturing the core thesis
- Key takeaways should be actionable or insight-bearing, not just restatements
- Extracted concepts should be genuinely atomic — one idea per concept note
- Arguments should be falsifiable claims, not vague observations
- Always note the confidence level: is this settled knowledge, or contested?
- Use the owner's framing and language style when possible
