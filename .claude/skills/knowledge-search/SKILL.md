---
name: knowledge-search
description: |
  Search the web for topics, claims, or domain gaps and present results for review.
  Human validates sources before anything gets ingested. Research assistant for your
  Second Brain — finds what's worth reading so you can decide what's worth keeping.

  Triggers on: search for, research, find sources about, knowledge search,
  find articles on, what's out there about, fill gap on, explore topic,
  search my gaps, find counterarguments to, deep dive into, find more on
allowed-tools:
  - WebSearch
  - WebFetch
  - Bash(firecrawl *)
  - Bash(npx firecrawl *)
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Knowledge Search

Search the web for topics, claims, or knowledge gaps — then ingest approved sources into your Second Brain. This is a **human-in-the-loop** research workflow: the agent searches and presents, the human validates, then approved sources flow through the ingestion pipeline.

**Golden rule: NEVER ingest a source without explicit human approval.**

## Vault Location

The vault is the **project root** (the directory containing `CLAUDE.md`). All paths in this skill are relative to the project root. Do not hardcode absolute paths.

## Before Starting

1. Read `memory.md` at the vault root for recent session context. If it doesn't exist, skip it.
2. Read `memory-gaps.md` to understand what the vault is missing — this informs search suggestions. If it doesn't exist, skip it.
3. Read `_meta/domains-registry.md` for active domains.
4. Read `_meta/sources-index.md` (global lightweight index) for deduplication of search results. If the search targets a specific domain, also read `_meta/sources/<domain>.md` for richer context.
5. Tags are loaded during the ingestion phase (not needed for search itself).

## Step 1: Parse the Search Request

Detect which **search mode** the user is requesting:

| Mode | Trigger Examples | Behavior |
|------|-----------------|----------|
| **Topic exploration** | "search for articles on Austrian business cycle theory", "what's out there about vibe coding" | Broad search across multiple angles on a topic |
| **Claim verification** | "find sources supporting or challenging the Cantillon effect", "find counterarguments to self-ownership" | Targeted search for both supporting AND opposing evidence |
| **Gap filling** | "search my gaps", "fill gaps on Bitcoin", "fill gap on [specific gap]" | Read `memory-gaps.md`, convert gaps into targeted search queries |
| **Domain deepening** | "find more sources for my AI/VibeCoding domain", "deepen my Bitcoin knowledge" | Read the domain's MOC, identify concepts with few sources, search for depth |
| **Specific source** | "find the Card & Krueger minimum wage study", "find Hayek's Denationalisation of Money" | Narrow, direct search for a known work |

If the user's request is ambiguous, ask one clarifying question. If it maps cleanly to a mode, proceed.

## Step 2: Execute Search

Use `WebSearch` to find relevant sources. Construct **2-3 varied queries** to cover different angles:

### By Mode:

**Topic exploration:**
- Query 1: The topic itself (e.g., "Austrian business cycle theory")
- Query 2: Topic + "analysis" or "explained" or "deep dive"
- Query 3: Topic + a key author or concept already in the vault (if relevant)

**Claim verification:**
- Query 1: The claim + "evidence" or "supporting" (e.g., "Cantillon effect evidence")
- Query 2: The claim + "criticism" or "against" or "debunked" (e.g., "Cantillon effect criticism")
- Query 3: The claim + "debate" or "counterarguments"

**Gap filling:**
1. Read `memory-gaps.md` and parse each gap entry.
2. If the user said "search my gaps" (no specific gap): pick the top 3-5 most actionable gaps and generate one query each.
3. If the user named a specific gap: generate 2-3 targeted queries for that gap.
4. Example gap: "Need counterarguments to self-ownership: social contract theory, communitarianism" → search "social contract theory critique of self-ownership" and "communitarian argument against self-ownership."

**Domain deepening:**
1. Read `07-maps/MOC-<Domain>.md` for the target domain.
2. Identify concepts or topics mentioned but with few or no linked sources.
3. Generate 2-3 queries targeting those thin areas.

**Specific source:**
- Query 1: Exact title or author + title
- Query 2: Author + topic if title is uncertain

### Search Quality Tips:
- For academic claims, append "study" or "paper" or "research"
- For technical topics, include the specific technology name
- For counterarguments, explicitly search "criticism of" or "against"
- Prefer recent results when the topic is fast-moving (add current year to query)

## Step 3: Deduplicate Against Vault

Before presenting results to the user:

1. For each result URL: strip protocol (`https://`, `http://`) and trailing slashes, then check against `_meta/sources-index.md` URL column.
2. For each result title: compare against the Title column in `sources-index.md`. Flag if 3+ significant words match (ignore common words: a, the, of, in, to, and, for, is, on, with, that, this, it, by, at, from).
3. Also grep `01-sources/` for the URL in `source_url:` fields as a secondary check.
4. Mark duplicates but **still include them** in the results — flagged so the user knows.

## Step 4: Present Results for Human Review

Present results in a numbered, scannable format. This is the human validation gate — the user decides what enters the vault.

```
## Search Results: [topic/query description]

I searched for [brief description of queries used].

### 1. [Title]
   Source: [domain/publication] | Author: [if known] | Date: [if known]
   URL: [url]
   Snippet: [2-3 sentence preview from search results]
   Relevance: [1 sentence — why this matters for your vault, reference specific gaps or domains]

### 2. [Title]
   Source: [domain/publication] | Author: [if known] | Date: [if known]
   URL: [url]
   Snippet: [2-3 sentence preview from search results]
   Relevance: [1 sentence]
   ⚠️ ALREADY IN VAULT — similar to: [existing note title]

### 3. [Title]
   ...

---
**What would you like to do?**
- **"Ingest 1, 3, 5"** — approve specific results by number
- **"Ingest all"** — approve everything
- **"Skip"** — discard these results
- **"Refine: [new terms]"** — search again with different terms
- **"Preview 2"** — I'll fetch the full content of #2 so you can assess quality before deciding
- **"More"** — search for more results on this topic
```

**Important presentation rules:**
- Maximum 10 results per presentation. If more are found, show the best 10 and note how many were omitted.
- Order by relevance to the user's vault (gap-filling results first, then domain-relevant, then general).
- Always include the "Relevance" line — this is what makes the skill valuable vs. a plain web search.
- Never auto-select or recommend specific results. Present neutrally and let the human decide.

## Step 5: Preview (On Request)

If the user asks to preview a specific result (e.g., "Preview 2"):

1. Fetch the URL using firecrawl (preferred) or WebFetch (fallback).
2. Show a condensed preview:
   - Detected content type (article, video, podcast, etc.)
   - Author and publication date (if extractable from the page)
   - A 3-5 sentence summary of the actual content (not just the search snippet)
   - Word count or length estimate
3. Ask: "Would you like to ingest this source? (yes/no)"

This step exists because search snippets can be misleading. A preview gives confidence without committing to full ingestion.

## Step 6: Ingest Approved Sources

After the user approves sources (e.g., "Ingest 1, 3, 5"):

**For each approved source**, execute the full knowledge-ingest pipeline. Read the detailed steps from `.claude/skills/knowledge-ingest/SKILL.md` (Steps 0-9):

1. **Duplicate check** (Step 0) — re-verify even though we checked in Step 3, as the vault may have changed
2. **Detect content type** (Step 1)
3. **Fetch content** (Step 2) — firecrawl → WebFetch → ask user to paste
4. **Process content** (Step 3) — summary, key takeaways, concepts, tags, domains, confidence
5. **Write source note** (Step 4) — to `01-sources/<content_type>/`
6. **Create/update concept notes** (Step 5) — in `02-concepts/`
7. **Discover connections** (Step 6) — grep vault, classify, add backlinks
8. **Update indexes** (Step 7) — tags registry, sources index, processing log, MOCs, library docs
9. **Update memory** (Step 8) — session log, learnings, gaps
10. **Report** (Step 9) — standard ingestion summary

**Batch processing rules:**
- Process sources **sequentially**, not in parallel.
- After each source, print the standard ingestion report (same format as knowledge-ingest Step 9).
- Between sources, briefly report progress: "Ingested 1 of 3: [title]. Processing next..."
- If any source fails to fetch, report the failure and continue with the next one. Don't abort the batch.

## Step 7: Post-Search Updates

After all approved sources are ingested:

1. **`memory.md` Session Log**: Append entry — "Research session: searched for [topic]. Found N results, ingested M. Sources: [list of ingested titles]."
2. **`memory-gaps.md`**: If the search was gap-driven:
   - If a gap is now fully addressed by the ingested sources, note it as addressed (don't delete — mark with a date).
   - If partially addressed, update the gap entry with what remains.
3. **`memory-learnings.md`**: If the research session revealed a surprising finding or pattern, add it.

## Step 8: Final Report

```
Research Complete: [topic]
Searched: [N] queries | Results found: [N] | Already in vault: [N]
Approved: [N] | Ingested: [N]

Sources ingested:
- [title 1] → [domains], [tags]
- [title 2] → [domains], [tags]

New concepts created: [list with [[links]]]
Connections discovered: [N] notes linked
Gaps addressed: [list, if applicable]
```

If knowledge gaps remain in the searched area, suggest:
> "There are still open gaps on [topic]. Want me to search for more, or is this enough for now?"

## Error Handling

- If `WebSearch` returns no results: try reformulating the query (simpler terms, fewer qualifiers). If still nothing, tell the user and suggest they try different search terms.
- If a source URL fails to fetch during ingestion: report the failure, skip it, continue with the next approved source. Offer the user the option to paste the content manually.
- If all queries in a gap-filling search return irrelevant results: report that the gap may need a more specific query and ask the user to rephrase.
- If the user's request doesn't match any search mode: default to **topic exploration** mode.
