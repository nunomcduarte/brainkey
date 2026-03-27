---
name: knowledge-review
description: |
  Generate daily, weekly, or monthly learning review documents. Compiles all
  vault activity into detailed, organized study notes with insights, concepts,
  source tables, study questions, and next actions.

  Triggers on: knowledge review, daily review, weekly review, monthly review,
  what did I learn, study notes, learning digest, review my learnings,
  learning summary, review learnings
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Knowledge Review

Generate structured learning review documents from Second Brain vault activity.

## Vault Location

`/Users/nunoduarte/Desktop/FeeltheVibe/theKnowledge/`

## Before Starting

1. Read `memory.md` — especially Learning Journal, Evolving Positions, Knowledge Gaps, and Session Log.
2. Read `_meta/processing-log.md` to understand all vault activity.
3. Read `_meta/tags-registry.md` for tag context.

## Period Detection

### Auto-detect (default)

- **Always available**: `daily` — covers today (default)
- **If today is Monday**: offer `weekly` — covers the last 7 days
- **If today is the 1st of the month**: offer `monthly` — covers the last 30 days
- When auto-detecting, tell the user which period was detected and ask to confirm or override.

### Override

User can explicitly request any period:
- `/knowledge-review daily` — today only
- `/knowledge-review weekly` — last 7 days
- `/knowledge-review monthly` — last 30 days
- `/knowledge-review 2026-03-20 to 2026-03-24` — custom date range

### Date Range Calculation

Given the period, compute `start_date` and `end_date`:
- **Daily**: start = today, end = today
- **Weekly**: start = 7 days ago, end = today
- **Monthly**: start = 30 days ago, end = today
- **Custom**: use the dates provided

## Data Gathering

For the computed date range, collect ALL of the following:

### Step 1: Processing Log
Read `_meta/processing-log.md`. Filter rows where the Date column falls within the date range. This gives you the list of all ingestions, syntheses, briefs, and other actions in the period.

### Step 2: Learning Journal
Read `memory.md` → Learning Journal section. Extract entries whose date falls within the range. These are the "aha moments" — the most important insights.

### Step 3: Evolving Positions
Read `memory.md` → Evolving Positions section. Note any positions that reference sources from this period (check the source UIDs against processing log items).

### Step 4: Knowledge Gaps
Read `memory.md` → Knowledge Gaps section. Identify gaps that were added during this period (mentioned in session log entries for the period) and any that were resolved.

### Step 5: Source Notes
For each source in the processing log for this period:
- Read the full source note from `01-sources/`
- Extract: title, author, content_type, domains, confidence, summary, key takeaways, concepts extracted

### Step 6: Concept Notes
For each concept mentioned in the source notes' `concepts_extracted` sections, or created during the period:
- Read from `02-concepts/`
- Extract: title, definition, domains, connections

### Step 7: Synthesis & Briefs
Check if any files in `05-synthesis/` or `06-briefs/` were created in the period (match dates from processing log). Read their summaries.

### Step 8: Library Docs
Grep `08-library/` for any docs whose `modified` frontmatter date falls in the range. Note which were created vs. updated.

## Output Document

### Filename Convention

| Period | Filename | Example |
|--------|----------|---------|
| Daily | `review-YYYY-MM-DD.md` | `review-2026-03-24.md` |
| Weekly | `review-YYYY-WNN.md` | `review-2026-W13.md` |
| Monthly | `review-YYYY-MM.md` | `review-2026-03.md` |

Save to `09-reviews/{period}/` (e.g., `09-reviews/daily/review-2026-03-24.md`).

### Frontmatter

```yaml
---
uid: rev-YYYYMMDD-{period}
type: review
period: daily|weekly|monthly
date_range: ["YYYY-MM-DD", "YYYY-MM-DD"]
created: YYYY-MM-DDTHH:MM:SS
status: live
domains: []        # auto-detected from content
tags: []           # auto-detected from content
sources_reviewed: [] # list of source UIDs processed in this period
concepts_added: []   # list of concept names created in this period
---
```

### Document Sections

Write each section in this order:

#### 1. Executive Summary
3-5 sentences summarizing the period's learning activity. Include: how many sources processed, how many concepts created, which domains were active, and the single most important insight.

#### 2. What I Learned
Group by domain. For each active domain, write 1-3 paragraphs of **narrative prose** (not bullet lists) explaining what was learned. This should read like a study journal — connect ideas, show how they relate, note surprises. Every insight must be attributed to its source with a `[[source-link]]`.

This is the most important section. Spend the most effort here. The goal is a document someone could read to deeply understand what was learned, not just a list of facts.

#### 3. New Concepts
Markdown table with columns: Concept | Definition | Source | Domain

List every concept note created during the period.

#### 4. Key Insights & Aha Moments
Pull directly from the Learning Journal entries for this period. For each insight:
- Quote or paraphrase the insight
- Add 2-3 sentences of expanded context explaining WHY this matters
- Link to the source(s)

#### 5. Evolving Positions
If any positions in `memory.md` were updated during this period:
- State the position topic
- Show the before state (or "new position" if first time)
- Show the current state
- Cite the evidence that caused the shift

If no positions changed, write: "No position shifts this period."

#### 6. Connections Discovered
List the most interesting cross-note connections made during the period:
- Which notes were backlinked
- What type of connection (supporting, contradicting, etc.)
- Why the connection matters

If the period had heavy ingestion, focus on the 5-10 most interesting connections rather than listing all.

#### 7. Knowledge Gaps
Two subsections:
- **New gaps identified**: Gaps added to memory.md during this period
- **Gaps closed**: Any previously identified gaps that were addressed by new sources (check if a gap's topic now has coverage)

#### 8. Sources Processed
Markdown table with columns: Title | Type | Author | Domain | Confidence | Key Takeaway

One row per source ingested during the period.

#### 9. Study Questions
Generate 5-10 questions designed for active recall and deeper thinking. Mix these types:
- **Recall**: "What are the three types of X described in [[source]]?"
- **Application**: "How would you apply concept X to scenario Y?"
- **Connection**: "What's the relationship between concept X and concept Y?"
- **Critical**: "What's the strongest counterargument to claim X?"
- **Synthesis**: "If X and Y are both true, what does that imply for Z?"

Questions should be specific to the period's content, not generic.

#### 10. Next Actions
Based on the analysis, suggest 3-5 concrete actions:
- Domains that need feeding (especially empty ones)
- Gaps that should be addressed with specific types of sources
- Topics ripe for synthesis (`/knowledge-synthesize`)
- Orphan notes to connect (`/knowledge-connect`)
- Positions that need counterarguments

### Weekly Additions (period = weekly)

Add after "Study Questions", before "Next Actions":

#### Patterns This Week
Identify recurring themes across the week's sources:
- Which tags appeared most frequently
- Which concepts kept coming up across different sources
- Any emerging narrative or thread connecting the week's learning
- Surprising overlaps between domains

### Monthly Additions (period = monthly)

Add after "Study Questions", before "Next Actions":

#### Domain Progress
Table showing growth per domain:
| Domain | Sources (start → end) | Concepts (start → end) | Net Change |

Use vault file counts at month start vs. end. For the first month, "start" is 0.

#### Top 10 Insights
Curate the 10 most important insights from the month's Learning Journal entries. Rank by:
1. Cross-domain connections (highest value)
2. Position-changing evidence
3. Gap-closing discoveries
4. Novel frameworks or models

## After Generating

1. **Update `memory.md`**:
   - **Session Log**: "Generated {period} review for {date_range}. Covered X sources, Y concepts across Z domains. Saved to 09-reviews/{period}/{filename}."

2. **Update `_meta/processing-log.md`**:
   - Add row: `| YYYY-MM-DD | review-generated | rev-YYYYMMDD-{period} | {period} review covering {date range}. X sources, Y concepts. |`

## Quality Standards

- The "What I Learned" section must be **narrative**, not a reformatted bullet list. Write it as if explaining to a smart friend what you spent the day/week/month studying.
- Every claim must link to a vault source. No unsourced statements.
- Study questions must be answerable from the vault's content — don't ask about things not covered.
- The document should be self-contained: someone reading ONLY this review should understand the period's learning without needing to read every individual source note.
- Use the owner's framing and language style when possible.

## Report to User

After generating, display:

```
Review: {period} — {date_range}
Domains active: {list}
Sources reviewed: {count}
Concepts added: {count}
Key insight: {1-2 sentence top insight}
Study questions: {count}
Saved to: 09-reviews/{period}/{filename}
```
