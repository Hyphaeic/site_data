# Abzu

> STATUS: HYPOTHESIS, PROTOTYPE
> STATE: PROTOTYPE

Embodied agency and control built on the option kernels.

## The problem

A body is not one controller. It is a collection of local sensor, actuator,
reflex, and planning loops with different rates, partial state, and real
consequences.

## The approach

Abzu brings state-time optionality into embodied action. Local models maintain
their own relevant histories and logical clocks; coherence is propagated across
control islands instead of supplied by a permanent global model.

Its deterministic reflex loop operates at the rate of the world, while a
language model may set or revise objectives at a slower rate. The stack is not
limited to robotics: it can be coupled to any sensor and actuation plane.

The programme treats residuals between prediction and outcome as information
that can alter belief and planning while preserving continuity of purpose.

## Bounded senses and protocol coupling

An Abzu agent does not read privileged world state. A connected environment
exposes defined sense organs, and the agent constructs beliefs from what those
organs report. The current approach uses interval consensus over integer
set-membership covers rather than assuming a single perfect estimate.

Abzu and a world do not depend on each other's process. They couple through a
protocol: frames, sink identities, and sequence discipline. That preserves the
boundary between an agent and its environment, while making their relationship
testable.

Modulus is the first world used for this work, but the core crates are designed
to remain independent of any one world.

## Research status

Abzu is a prototype. Its central open problem is how local competencies scale
into safe, intelligible whole-body behaviour under latency, novelty, and
partial failure.

## Why it matters

Embodiment makes locality unavoidable. An agent must act from bounded
perception without losing the ability to be corrected by the world.

## Related
`TECHNOLOGY/STOK-CORE`, `PROBLEMS/Embodiment`, and `PROBLEMS/Alignment`.
