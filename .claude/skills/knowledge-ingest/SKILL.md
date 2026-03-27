---
name: knowledge-ingest
description: |
  Add content to your Second Brain. Accepts URLs, pasted text, or file paths.
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

Add content to your Second Brain. This is the core pipeline — all content enters through here.

## Vault Location

`/Users/nunoduarte/Desktop/FeeltheVibe/theKnowledge/`

## Before Starting

1. Read `memory.md` at the vault root for context on past learnings and current positions.
2. Read `_meta/tags-registry.md` to know existing tags (prefer reuse over creating new ones).
3. Read `_meta/domains-registry.md` for the current domains list.
4. **First-run check**: If `_meta/domains-registry.md` has no data rows (empty or header only):
   - Ask the user: "This looks like a fresh vault. What are your main areas of interest?" (give examples: technology, philosophy, business, health, etc.)
   - For each domain they provide: add a row to the registry, create the MOC file, and create the library folder.
   - If the user says "skip" or "none yet": proceed with no domains — they'll emerge organically as content is ingested.

## Input Types

The user will provide one of:
- **URL** — fetch content using `firecrawl scrape <url>` to get clean markdown
- **Pasted text** — raw content in the message
- **File path** — a local file to read and process

## Processing Pipeline

### Step 0: Duplicate Check

Before processing, check if this content already exists in the vault.

#### For URLs:
1. Grep `_meta/sources-index.md` for the URL (strip protocol and trailing slashes for matching).
2. Also grep all files in `01-sources/` recursively for `source_url:` containing the URL.
3. If a match is found: report the existing note's UID, title, and file path to the user. Ask:
   - **Update**: Re-ingest and merge new information into the existing note
   - **Skip**: Abort ingestion
   - **Force new**: Create a separate source note anyway (e.g., content has changed significantly)

#### For titles/pasted text:
1. Read `_meta/sources-index.md` and compare the provided title (or first 10 words of pasted content) against existing Title column entries.
2. Flag if any title shares 3+ significant words with the input (ignore common words: a, the, of, in, to, and, for, is, on, with).
3. If a potential match is found: show the candidate(s) and ask the user to confirm duplicate or proceed.

#### For file paths:
1. Extract the filename, grep `_meta/sources-index.md` for it.
2. Apply the same fuzzy title matching as above.

If no duplicates found, proceed to Step 1.

### Step 1: Detect Content Type

Determine `content_type` from the input:
- `article` — blog posts, news articles, essays, substacks
- `tweet` — X/Twitter posts or threads (URLs containing x.com or twitter.com)
- `podcast` — podcast episodes, audio show notes
- `book` — book notes, chapter summaries, book reviews
- `video` — YouTube videos, talks, presentations
- `discussion` — forum threads, comment discussions, debates

### Step 2: Fetch Content (if URL)

Try fetching in this order:

1. **Firecrawl (preferred)**: Run `firecrawl scrape <url>` to get clean markdown. Firecrawl strips boilerplate, ads, and navigation, returning only the article content. If firecrawl returns an error or is not installed, fall through to WebFetch.

2. **WebFetch (fallback)**: Use the WebFetch tool to fetch the page content. Less clean than firecrawl but works without additional setup. May include navigation elements and other noise — manually trim if needed.

3. **Manual paste (last resort)**: If both fail (e.g., paywalled content, anti-bot protection), ask the user to paste the content directly.

For X/Twitter URLs: firecrawl handles threads well. If it fails, ask the user to paste the thread.

**Important**: Always store the original URL in the `source_url` frontmatter field, regardless of which fetch method was used. This enables duplicate detection in Step 0.

### Step 3: Process Content

Read the appropriate template from `_templates/source-<content_type>.md`.

Generate:
- **Summary**: 2-3 sentences capturing the core thesis. Be precise, not generic.
- **Key Takeaways**: 3-5 actionable or insight-bearing bullets. Not restatements — each should teach something.
- **Core Arguments**: The main claims or positions argued in the content.
- **Concepts**: Atomic ideas that can stand as their own notes. Think: "Would someone search for this term?"
- **Tags**: Read `_meta/tags-registry.md` first. Reuse existing tags. Only mint new ones for genuinely new concepts. Tags are lowercase-hyphenated.
- **Domains**: Read `_meta/domains-registry.md` for the current domains list. Assign from active domains. A source can belong to multiple domains. If content doesn't fit any existing domain, propose a new one (see Domain Fit Check below).
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
2. **Sources Index** (`_meta/sources-index.md`): Add a new row with: UID, Title, URL, Author, Type, Domains, Tags, Date.
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

   Domain folder mapping is defined in `_meta/domains-registry.md`. Read it to find the correct `08-library/<domain>/` path for each domain.

### Domain Fit Check

If content doesn't fit any domain in `_meta/domains-registry.md`:
1. Propose a new domain name (lowercase-hyphenated slug + display name)
2. Briefly explain why existing domains don't fit
3. Ask user to: approve, rename, or skip domain assignment
4. If approved: add a new row to `_meta/domains-registry.md`, create `07-maps/MOC-<Display-Name>.md`, and create `08-library/<domain-slug>/`

### Step 8: Update Memory

Read `memory.md` and update:
- **Session Log**: Append what was ingested.
- **Learning Journal**: If a genuinely new insight emerged (not just "added another article"), add it.
- **Knowledge Gaps**: If this source reveals a gap (e.g., a claim with no counterargument in the vault), note it.

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

- If firecrawl fails, try WebFetch. If both fail, ask the user to paste the content directly.
- If the content doesn't fit any template well, use `source-article.md` as the default.
- If no meaningful concepts can be extracted, still create the source note but note this in the processing log.
