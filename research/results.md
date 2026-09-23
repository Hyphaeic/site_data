# Results

> STATUS: FORMAL RESULT, EXPERIMENTAL RESULT

This page distinguishes formal results from implementation and experimental
work. It does not treat a prototype as a theorem.

---

## Formal results

### FDRS foundations

The FDRS mathematical corpus is machine-checked in Lean 4. Its Phase 1 work
establishes prefix-preservation results for Tick, predecessor, and addition:
each is 1-Lipschitz in the stated ultrametric setting.

Prefixes correspond to congruence classes modulo place-value products. This
connects the operational notion of local arithmetic to the geometry used by
later coherence work.

## Implemented systems

### Deterministic substrate

The current substrate runs on x86, ARM, and RISC-V without a host operating
system, drives IO controllers directly, and is designed to produce replicable
results across platforms.

### Local propagation

The simulation uses local memory and deterministic propagation. Its claims
about partition tolerance and bit-level reproducibility remain active research
subjects, with the precise conditions stated in `RESEARCH/Open Problems`.

## Demonstrated systems

### HyphaeicOS

The public browser platform demonstrates a peer-oriented operating environment
built with WebAssembly and SolidJS. The bare-metal runtime remains in active
development.

### Modulus

Modulus provides live integer-substrate physics demonstrations, including
peer-replicated chaotic motion and geometry at widely different scales.

### Hyphacom

Hyphacom demonstrates a live peer-to-peer communications surface in which
connected peers project the relevant shared history rather than relying on one
permanent global store.

### ChessBender

ChessBender is an interactive deterministic game world used to test reward-free
planning and peer-based simulation.

## Experimental record

The automated mathematics stream contains individual experiment reports,
results, and negative controls. A result there should be read with the status
assigned by that experiment, not as a general theorem.
