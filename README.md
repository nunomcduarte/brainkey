# Second Brain

A personal knowledge management system powered by Claude Code. Turn scattered content into connected, actionable knowledge.

## Setup

### Optional: Firecrawl for URL ingestion

For the best URL scraping experience, install firecrawl:
```bash
npm install -g firecrawl
```

The system works without it — URLs will be fetched via WebFetch as a fallback — but firecrawl produces cleaner markdown from web pages.

## Quick Start

1. Open this folder in Obsidian (File > Open Vault > select `theKnowledge`)
2. Open Claude Code in this directory: `cd ~/Desktop/FeeltheVibe/theKnowledge && claude`
3. Start adding content with `/knowledge-ingest`

## Skills

### `/knowledge-ingest` — Add Content

The core skill. Feed it a URL, pasted text, or file path and it will:
- Summarize the content
- Extract concepts, arguments, and mental models
- Auto-discover tags
- Find connections to existing notes
- Update all indexes and Maps of Content

**Examples:**
```
/knowledge-ingest https://mises.org/article/example
/knowledge-ingest [paste a tweet thread here]
/knowledge-ingest ~/Downloads/podcast-notes.md
```

**What it accepts:**
- Articles, blog posts, essays, substacks
- X/Twitter threads
- Podcast episode notes
- Book notes or chapter summaries
- Video transcripts or notes
- Forum discussions, debates

---

### `/knowledge-connect` — Find Connections

Re-scan notes for relationships. Useful after adding several pieces of content, as new notes may connect to older ones.

**Examples:**
```
/knowledge-connect                          # scan recent notes
/knowledge-connect [[Cantillon Effect]]     # scan a specific note
/knowledge-connect rescan all               # full vault scan
```

---

### `/knowledge-synthesize` — Surface Patterns

Generate cross-source synthesis notes that reveal:
- **Convergence** — multiple sources making the same argument
- **Tension** — sources that contradict each other
- **Evolution** — ideas building over time
- **Gaps** — topics missing counterarguments

**Examples:**
```
/knowledge-synthesize Bitcoin               # synthesize a domain
/knowledge-synthesize this week             # synthesize recent additions
/knowledge-synthesize Austrian Economics + Bitcoin  # cross-domain synthesis
```

---

### `/knowledge-chat` — Ask Your Knowledge Base

Ask questions and get answers grounded in YOUR sources, not generic AI. Every claim references specific notes.

**Examples:**
```
/knowledge-chat What do my sources say about the Cantillon Effect?
/knowledge-chat How does Austrian business cycle theory relate to Bitcoin?
/knowledge-chat What are the strongest arguments for sound money in my vault?
```

---

### `/knowledge-brief` — Generate Output Documents

Create briefs, outlines, and drafts grounded in your knowledge base. Every message backed by your sources.

**Types:** landing-page, article, thread, email, presentation

**Examples:**
```
/knowledge-brief Landing page for a Bitcoin education product
/knowledge-brief Article outline on vibe marketing
/knowledge-brief Twitter thread about Austrian Economics for beginners
```

---

### `/knowledge-status` — Vault Dashboard

See your vault's health at a glance: stats, recent activity, orphan notes, knowledge gaps, and suggestions.

```
/knowledge-status
```

---

## How It Works

### The Pipeline

```
Content In → Inbox → Process → Source Note → Extract Concepts → Find Connections → Update Indexes
```

1. Raw content lands in `00-inbox/`
2. Claude processes it into a structured source note in `01-sources/`
3. Atomic concepts are extracted to `02-concepts/`
4. Arguments and models go to `03-arguments/` and `04-models/`
5. Connections are discovered via search and backlinks are written on both sides
6. Indexes (`_meta/`) and Maps of Content (`07-maps/`) are updated

### The Memory

`memory.md` at the vault root tracks:
- **Learning Journal** — insights and "aha moments" over time
- **Evolving Positions** — your current stance on key topics
- **Knowledge Gaps** — what's missing
- **Patterns & Preferences** — what Claude notices about your thinking
- **Session Log** — continuity across sessions

Claude reads this at the start of every session and updates it after meaningful work.

### Search (No Database Needed)

The system uses structured markdown files as indexes:
- `_meta/tags-registry.md` — all tags and which notes use them
- `_meta/sources-index.md` — flat table of all sources
- `07-maps/MOC-*.md` — domain-specific content maps
- Plus Grep for full-text search

This works well for hundreds of notes without any external database.

## Vault Structure

```
theKnowledge/                  (aka Second Brain)
├── 00-inbox/          Raw captures before processing
├── 01-sources/        Processed source notes (articles, tweets, podcasts, books, videos, discussions)
├── 02-concepts/       Atomic concept notes — one idea per file
├── 03-arguments/      Claims with evidence chains
├── 04-models/         Mental models and frameworks
├── 05-synthesis/      Cross-source pattern notes
├── 06-briefs/         Generated output documents
├── 07-maps/           Maps of Content per domain
├── 08-library/        Living knowledge docs per domain — compiled summaries, lessons, concepts
├── _meta/             System indexes
└── _templates/        Note templates
```

## Domains

Your areas of interest are defined in `_meta/domains-registry.md`. New domains are
auto-created when ingested content doesn't fit existing ones. On first run, you'll be
asked for your main interests — or you can skip and let domains emerge organically.

## Tips

- **Start small.** Ingest 3-5 pieces of content to see the system in action before doing a big import.
- **Let tags emerge.** Don't pre-plan a taxonomy. The AI discovers tags from your content organically.
- **Run `/knowledge-synthesize` weekly.** This is where the magic happens — patterns you didn't see emerge.
- **Use `/knowledge-chat` before creating.** Before writing a landing page or article, ask your knowledge base first. You'll produce better, more grounded output.
- **Open in Obsidian.** The `[[backlinks]]` and graph view make the connections visible and browsable.
