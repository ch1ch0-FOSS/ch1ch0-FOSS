---
title: "{{title}}"
uid: "{{id}}"
created: "{{format-date now}}"
updated: "{{format-date now}}"
tags: []
type: "decision"
author: "{{env.USER}}"
status: "raw"
---

# Decision: {{title}}

## Status
**Status**: Proposed | Decided | Deprecated
**Date**: {{format-date now}}
**Decider(s)**: {{env.USER}}

## Context
What situation prompted this decision? What constraints exist?

## Decision
Clear statement of what was decided.

## Rationale
Why this choice over alternatives?

### Pros
- Benefit 1
- Benefit 2

### Cons
- Tradeoff 1
- Tradeoff 2

## Alternatives Considered
1. **Option A**: Why rejected
2. **Option B**: Why rejected

## Consequences
- What changes as a result
- What becomes easier/harder
- Technical debt introduced/removed

## Implementation
- [ ] Step 1
- [ ] Step 2
- [ ] Step 3

## Related Decisions
[[Prior Decision]]
[[Superseded Decision]]

---
Decision Date: {{decision_date}}
Status: {{status}}
UID: {{id}}
