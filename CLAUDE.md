# Second Brain — Project Instructions

A personal knowledge management vault powered by Claude Code. Ingestion, connection discovery, synthesis, and querying — all in markdown files, no external databases or APIs.

## Vault Structure

```
theKnowledge/                  ← directory name (aka Second Brain)
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
├── _meta/             ← System indexes (tags, sources, processing log)
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
3. If the user declines or says "skip": proceed with no domains. They will emerge organically as content is ingested.

## Session Protocol

**Every time you start working in this vault:**
1. Read `memory.md` (lightweight index with recent sessions and pointers to sub-files)
2. Read the relevant memory sub-file for your task:
   - `memory-positions.md` — when answering questions or calibrating tone
   - `memory-gaps.md` — when planning ingestion or checking coverage
   - `memory-learnings.md` — when reviewing insights or writing reviews
   - `memory-patterns.md` — when tailoring output style
3. Read `_meta/tags-registry.md` to know existing tags
4. After meaningful work, update the appropriate memory file:
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
- Before creating a new tag, ALWAYS read `_meta/tags-registry.md` and prefer existing tags
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
- Update `_meta/tags-registry.md` with any new tags
- Update `_meta/sources-index.md` with the new source entry
- Append to `_meta/processing-log.md`
- Update relevant `07-maps/MOC-*.md` files

## Memory Updates

After meaningful work, update the appropriate memory file:
- **`memory-learnings.md`**: When a new insight or "aha moment" emerges (one line per insight)
- **`memory-positions.md`**: When new evidence shifts a stance
- **`memory-gaps.md`**: When you notice a missing counterargument or unexplored area
- **`memory-patterns.md`**: When you notice something about the owner's thinking
- **`memory.md` Session Log**: Always — briefly log what happened (keep last 10 entries, archive older to `_meta/session-archive.md`)

## Content Processing Quality

When processing content:
- Summaries should be 2-3 sentences, capturing the core thesis
- Key takeaways should be actionable or insight-bearing, not just restatements
- Extracted concepts should be genuinely atomic — one idea per concept note
- Arguments should be falsifiable claims, not vague observations
- Always note the confidence level: is this settled knowledge, or contested?
- Use the owner's framing and language style when possible
