---
name: knowledge-ingest
description: |
  Add content to the theKnowledge vault. Accepts URLs, pasted text, or file paths.
  Processes content into structured Obsidian notes with summaries, concepts, tags,
  and connections. Supports articles, tweets, podcasts, books, videos, and discussions.

  Triggers on: add to knowledge, save this, capture this, ingest, bookmark this,
  add article, save tweet, capture podcast, add book notes, knowledge ingest
allowed-tools:
  - Bash(firecrawl *)
  - Bash(npx firecrawl *)
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Knowledge Ingest

Add content to the theKnowledge vault. This is the core pipeline — all content enters through here.

## Vault Location

`/Users/nunoduarte/Desktop/FeeltheVibe/theKnowledge/`

## Before Starting

1. Read `memory.md` (lightweight index) at the vault root for recent session context. Read `memory-positions.md` for current positions.
2. Read `_meta/tags-registry.md` to know existing tags (prefer reuse over creating new ones).

## Input Types

The user will provide one of:
- **URL** — fetch content using `firecrawl scrape <url>` to get clean markdown
- **Pasted text** — raw content in the message
- **File path** — a local file to read and process

## Processing Pipeline

### Step 1: Detect Content Type

Determine `content_type` from the input:
- `article` — blog posts, news articles, essays, substacks
- `tweet` — X/Twitter posts or threads (URLs containing x.com or twitter.com)
- `podcast` — podcast episodes, audio show notes
- `book` — book notes, chapter summaries, book reviews
- `video` — YouTube videos, talks, presentations
- `discussion` — forum threads, comment discussions, debates

### Step 2: Fetch Content (if URL)

```bash
firecrawl scrape <url>
```

For X/Twitter URLs, try firecrawl first. If it fails, ask the user to paste the thread content.

### Step 3: Process Content

Read the appropriate template from `_templates/source-<content_type>.md`.

Generate:
- **Summary**: 2-3 sentences capturing the core thesis. Be precise, not generic.
- **Key Takeaways**: 3-5 actionable or insight-bearing bullets. Not restatements — each should teach something.
- **Core Arguments**: The main claims or positions argued in the content.
- **Concepts**: Atomic ideas that can stand as their own notes. Think: "Would someone search for this term?"
- **Tags**: Read `_meta/tags-registry.md` first. Reuse existing tags. Only mint new ones for genuinely new concepts. Tags are lowercase-hyphenated.
- **Domains**: Check the `## Core Domains` list in `CLAUDE.md` for the current domains. A source can belong to multiple domains. **Domain Fit Check** — if the content doesn't fit well into ANY existing domain (the match feels forced or the content's primary subject is clearly outside all current domains), pause and:
  1. Propose a new domain name (lowercase-hyphenated, following existing conventions like `austrian-economics`, `ai-vibecoding`)
  2. Briefly explain why existing domains don't cover it
  3. Ask the user to: **approve**, **rename** (suggest a different name), or **skip** (force-fit to the closest existing domain)
  4. If approved or renamed:
     - Create `08-library/<new-domain>/` folder
     - Create `07-maps/MOC-<New-Domain>.md` using the standard MOC structure (title, description, sections for Sources, Key Concepts, Arguments, Models & Frameworks, Synthesis Notes)
     - Add the new domain to the `## Core Domains` list in `CLAUDE.md`
     - Add the domain folder mapping to Step 7's Library section below
     - Continue ingestion with the new domain assigned
- **Confidence**: `high` (peer-reviewed, established author), `medium` (thoughtful but opinion-based), `low` (speculative), `contested` (actively debated).

### Step 4: Write Source Note

Generate the UID: `src-YYYYMMDD-<slug>` where slug is a short kebab-case descriptor.
Set `created` and `modified` to the current ISO datetime.
Set `status: live`.

Write to `01-sources/<content_type>/src-YYYYMMDD-<slug>.md`.

### Step 5: Create/Update Concept Notes

For each extracted concept:

1. Use Grep to search `02-concepts/` for existing notes matching the concept name.
2. **If exists**: Read the existing concept note. Append the new source to its `## Sources` section. Update `modified` date.
3. **If new**: Create a new concept note in `02-concepts/<Concept Name>.md` using the `_templates/concept.md` template. Set `first_seen_in` to the new source note.

### Step 6: Discover Connections

1. Extract key terms: all tags, concept names, author name, and distinctive technical terms.
2. Grep across `01-sources/`, `02-concepts/`, `03-arguments/`, `04-models/` for each key term.
3. Read the top 5-10 matching notes (just frontmatter + summary sections, not full content).
4. Classify connections:
   - **Direct** (same concept) → always link
   - **Supporting** (builds on) → always link
   - **Contradicting** (opposing view) → always link (these are valuable!)
   - **Tangential** (loose) → do NOT link
5. Add `[[backlinks]]` in the new source note's `related_sources` and `related_concepts` frontmatter.
6. Edit the related notes to add a backlink to the new source.

### Step 7: Update Indexes

1. **Tags Registry** (`_meta/tags-registry.md`): Add new rows for any new tags. Update counts for existing tags.
2. **Sources Index** (`_meta/sources-index.md`): Add a new row with: UID, Title, Author, Type, Domains, Tags, Date.
3. **Processing Log** (`_meta/processing-log.md`): Append: Date, "ingested", UID, brief note.
4. **MOCs** (`07-maps/MOC-<Domain>.md`): For each domain the source belongs to, add the source link under `## Sources`. Add any new concept links under `## Key Concepts`.
5. **Library** (`08-library/<domain>/`): For each domain the source belongs to, create a NEW library doc inside the domain folder. Each library doc is a standalone learning document derived from the ingested source:
   - **Filename**: `<descriptive-topic-slug>.md` (e.g., `autoresearch-and-skill-optimization.md`). Use a clear, readable name that describes the topic, NOT the source title.
   - **"What I Learned" section**: A concise narrative explaining what the source teaches, written in plain language. Not a copy of the source summary — reframe it as personal knowledge gained.
   - **"Key Lessons" section**: Actionable bullet-point takeaways.
   - **"Concepts" table**: All concepts extracted, with one-line definitions.
   - **"Sources" section**: Links back to the source note(s) this doc is derived from.
   - Use the `_templates/library-doc.md` template.
   - If a new source covers a topic that ALREADY has a library doc in that domain folder, UPDATE the existing doc instead of creating a duplicate — append new lessons, concepts, and sources to it.

   Domain folder mapping:
   - `libertarianism` → `08-library/libertarianism/`
   - `austrian-economics` → `08-library/austrian-economics/`
   - `bitcoin` → `08-library/bitcoin/`
   - `ai-vibecoding` → `08-library/ai-vibecoding/`
   - `ai-vibemarketing` → `08-library/ai-vibemarketing/`

### Step 8: Update Memory

Update the appropriate memory files:
- **`memory.md` Session Log**: Append what was ingested (keep last 10 entries, archive older to `_meta/session-archive.md`).
- **`memory-learnings.md`**: If a genuinely new insight emerged (not just "added another article"), add a one-line entry.
- **`memory-gaps.md`**: If this source reveals a gap (e.g., a claim with no counterargument in the vault), note it.
- **`memory.md` Vault Stats**: Update counts if they've changed significantly.

### Step 9: Report to User

Print a summary:
```
Ingested: <title>
Type: <content_type> | Domains: <domains>
Tags: <tags>
Concepts extracted: <list with [[links]]>
Connections found: <count> notes linked
New to vault: <any new concepts created>
```

## Error Handling

- If firecrawl fails, ask the user to paste the content directly.
- If the content doesn't fit any template well, use `source-article.md` as the default.
- If no meaningful concepts can be extracted, still create the source note but note this in the processing log.
