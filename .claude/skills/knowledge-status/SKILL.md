---
name: knowledge-status
description: |
  Dashboard showing vault stats, recent additions, orphan notes, knowledge gaps,
  and connection health.

  Triggers on: knowledge status, vault stats, knowledge dashboard,
  how is my vault, vault health, show my knowledge
allowed-tools:
  - Read
  - Glob
  - Grep
---

# Knowledge Status

Display a dashboard of your Second Brain vault's health and activity.

## Vault Location

The vault is the **project root** (the directory containing `CLAUDE.md`). All paths in this skill are relative to the project root. Do not hardcode absolute paths.

## Dashboard Sections

### 1. Vault Stats

Count files in each folder:
- `01-sources/` — total sources (broken down by content_type subfolder)
- `02-concepts/` — total concepts
- `03-arguments/` — total arguments
- `04-models/` — total models
- `05-synthesis/` — total synthesis notes
- `06-briefs/` — total briefs

Use Glob to count: `01-sources/**/*.md`, etc.

### 2. Domain Coverage

Read `_meta/domains-registry.md` for the list of active domains. For each domain, read its MOC and count:
- Sources, concepts, arguments, models, syntheses
- Show which domains are well-covered vs. thin

### 3. Recent Activity

Read `_meta/processing-log.md` and show the last 10 entries.

### 4. Tag Landscape

Read `_meta/tags-registry.md` and show:
- Total unique tags
- Top 10 most-used tags
- Tags used only once (potential merge candidates)

### 5. Orphan Notes

Search for notes with empty `related_sources` and `related_concepts` — these are disconnected from the knowledge graph.

### 6. Knowledge Gaps

Read `memory-gaps.md` and display current gaps.

### 7. Suggestions

Based on the analysis, suggest:
- Domains that need more sources
- Orphan notes that should be connected (suggest running `/knowledge-connect`)
- Topics ripe for synthesis (suggest running `/knowledge-synthesize`)
- Stale notes (status: stale or not updated in a long time)

## Output Format

```
Second Brain Vault Status
========================

Sources: X (articles: X, tweets: X, podcasts: X, books: X, videos: X, discussions: X)
Concepts: X | Arguments: X | Models: X
Synthesis: X | Briefs: X

Domain Coverage:
  [For each domain in _meta/domains-registry.md]:
  <Display Name>:     X sources, X concepts

Tags: X unique (top: tag-a (N), tag-b (N), tag-c (N))

Recent Activity:
  - YYYY-MM-DD: action — item
  - ...

Orphan Notes: X disconnected notes
Knowledge Gaps: X identified gaps

Suggestions:
  - ...
```

Update `memory.md` Session Log after displaying status. Update vault stats in `memory.md` if they've changed.
