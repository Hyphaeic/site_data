# Modulus

> STATUS: IMPLEMENTED, LIVE
> STATE: ACTIVE · LIVE · SOURCE

Deterministic physical state: the layer that pins the fabric to repeatable,
well-bounded computation.

## The problem

Distributed and embodied systems need their state transitions to remain
inspectable and reproducible across hardware and network boundaries.

## The approach

Modulus provides the deterministic physical-state layer beneath the fabric. It
anchors local computation to repeatable transitions so that propagation and
replay can be evaluated against an exact history.

Its integer substrate is derived from FDRS research. Unlike conventional
floating-point simulations, where independent executions can drift apart,
Modulus is designed to reproduce state exactly across participating machines.

## Current demonstrators

- **Peer replication.** A decentralised double-pendulum demonstration tests
  byte-exact replication of a chaotic simulation across connected peers.
- **Scale.** Geometry demonstrations span from nanometre-scale inputs to
  galactic-scale scenes while retaining the same representation discipline.
- **Rendering.** The engine renders through Vulkan while preserving an exact,
  integer simulation substrate beneath the visual layer.

These demonstrations are evidence of the implementation, not a proof that every
distributed execution is correct under every network condition.

## Research directions

Exact spatial state can support prefix-local tokenisation for model ingestion,
composable action sequences, exact state deduplication, lossless symmetry
augmentation, and bounded error tracking. Integer geometry may also provide a
more robust basis for repeated constructive solid geometry operations than
floating-point mesh pipelines.

## Status

Modulus is implemented and live. Its role in the broader proof of
partition-invariant propagation remains part of the research programme.

## Why it matters

Without a well-bounded record of realised state, disagreement between prediction
and outcome cannot become a reliable signal for correction.

## Related
`TECHNOLOGY/FDRS`, `TECHNOLOGY/HyphaFabric`, and `PROBLEMS/Time`.
