---
name: knowledge-brief
description: |
  Generate output documents (landing pages, articles, threads, emails, presentations)
  grounded in your personal knowledge base. Every claim backed by your sources.

  Triggers on: knowledge brief, create brief, generate brief from knowledge,
  landing page brief, article brief, write brief, create from my knowledge
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Knowledge Brief

Generate output documents (briefs) grounded in the user's personal knowledge vault. Every message and claim is backed by specific sources.

## Vault Location

`/Users/nunoduarte/Desktop/FeeltheVibe/theKnowledge/`

## Before Starting

1. Read `memory.md` (lightweight index), then read `memory-positions.md` and `memory-patterns.md`.
2. Read `_meta/tags-registry.md` for the tag landscape.

## Brief Types

- `landing-page` — key messages, value propositions, structure for a landing page
- `article` — outline, key arguments, evidence for a blog post or essay
- `thread` — Twitter/X thread outline with hooks and key points
- `email` — email sequence or single email with persuasion points
- `presentation` — slide deck outline with speaker notes

## Brief Generation Process

1. **Clarify scope**: If the user's request is vague, ask:
   - What's the topic/product?
   - Who's the audience?
   - What's the desired output type?
   - What tone? (technical, casual, persuasive, educational)

2. **Search the vault**:
   - Grep for key terms related to the brief topic
   - Read relevant MOCs
   - Load synthesis notes on the topic (most valuable — already cross-referenced)
   - Load relevant concept and argument notes
   - Check source notes for specific evidence and quotes

3. **Gather grounding material**: From loaded notes, collect:
   - Key arguments and claims (with source attribution)
   - Supporting evidence
   - Counterarguments (to address objections)
   - Relevant mental models and frameworks
   - The user's Evolving Position on the topic

4. **Generate the brief**: Using `_templates/brief.md`:
   - UID: `brf-YYYYMMDD-<slug>`
   - Every key message must link to at least one source
   - Include a "Supporting Evidence" section with full source chain
   - Suggest structure appropriate to the brief type
   - Recommend tone based on domain knowledge and audience

5. **Save** to `06-briefs/`.

6. **Update Memory**:
   - Session Log: Log what brief was generated
   - If the brief process revealed gaps, add to Knowledge Gaps

## Quality Standards

- A brief without source grounding is just generic AI output. Every claim MUST link to a vault source.
- If the vault lacks material for a good brief, say so and suggest content to ingest first.
- The brief should reflect the user's actual positions and sources, not generic marketing wisdom.
- Tone should be calibrated to the user's voice as understood from their notes, `memory-positions.md`, and `memory-patterns.md`.

## Report to User

```
Brief generated: <title>
Type: <brief_type>
Grounded in: <count> sources
Key messages: <count>
Saved to: 06-briefs/<filename>

[Print the brief content for review]
```
