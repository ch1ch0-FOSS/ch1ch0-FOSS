# ADR-001: External SSD Strategy

**Status**: Accepted  
**Date**: 2025-11-23  
**Deciders**: user  

## Context
Need persistent storage strategy that survives OS reinstall and hardware migration.

## Decision
Use external SSDs for all persistent data. OS partition contains zero unique state.

## Consequences

Positive:
- OS reinstall: 15 minutes
- Hardware portability: plug SSD into new machine
- Data loss risk: eliminated

Negative:
- USB throughput vs NVMe performance
- Physical cable dependency
- Additional power requirements

## Validation
- Successfully migrated between hardware 3 times
- OS reinstall verified in 18 minutes
- Zero data loss across migrations

