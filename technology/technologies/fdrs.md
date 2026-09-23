# FDRS: Function-Defined Radix Systems

> STATUS: FORMAL RESULT, IMPLEMENTED
> STATE: ACTIVE · SOURCE

What does “here” mean? FDRS is a mathematical substrate in which the numerical
base at any position is a context-dependent function. It provides a
variable-resolution geometry across orthogonal timelines.

## The problem

Standard number systems fix a base. FDRS asks what structure remains when the
base at each position may depend on position, earlier digits, or state.

## The construction

FDRS treats radix as a function, not a fixed convention. This changes the
geometry of representation: two values are ultrametrically close when they
share a long prefix, and arithmetic can be studied by the locality with which
it preserves that prefix.

Addition and multiplication need not commute in the resulting structure. That
non-commutation is not a defect; it records information neither operation
captures alone.

## Established work

The mathematical corpus is machine-checked in Lean 4. Phase 1 establishes that
Tick, predecessor, and addition are 1-Lipschitz in the stated ultrametric
setting. They preserve prefixes, which correspond to congruence classes modulo
place-value products.

## Why it matters

FDRS makes scale, phase, and locality part of representation rather than
external metadata. It supplies the mathematical language for local logical
clocks and later work on harmonic coherence.

## Applied substrate

The same representation discipline is used to investigate exact integer state,
predictable resolution, and bounded time relationships in distributed physics,
robotics, and simulation. It is the mathematical substrate beneath Modulus and
the multiclock model used by HyphaFabric.

## What remains open

The full continuity of arithmetic, the correct Markov state, and the
implications of the non-commuting structure remain active research questions.

## Related
`TECHNOLOGY/HyphaFabric`, `TECHNOLOGY/Modulus`,
`FOUNDATIONS/Representation`, and `RESEARCH/Open Problems`.
