# STOK-CORE: State-Time Option Kernels

> STATUS: HYPOTHESIS, PROTOTYPE
> STATE: PROTOTYPE

GPU-accelerated feasibility maps of what can be reached from here. STOK-CORE
studies planning by viability rather than proxy reward.

## The problem

An agent needs to choose among futures when time is local, models are
incomplete, and no external reward can faithfully compress what matters.

## The approach

A kernel maps an initial state and time to a distribution over final states and
times. Kernels compose, so locally solved possibilities can form longer-horizon
possibilities without assuming one global clock.

The implementation is written in Rust and uses Burn for GPU acceleration. Its
technical programme includes Option Kernel Bellman equations, exact option
composition, high-dimensional factorisation, and feasibility-based search
pruning.

Jump-form kernels remain exact under deterministic evolution. Local logical
clocks and harmonic coherence provide the time structure; a residual ledger
records the difference between declared and realised time as a model-error
signal.

## Research status

STOK-CORE is a prototype and hypothesis-led research programme. The key open
questions concern compositional optionality, kernel repair under continuous
change, and a control law connecting plasticity with empowerment.

## Why it matters

Reward-maximising planning can collapse the conditions that make the reward
meaningful. STOK-CORE asks instead which actions preserve, transform, or create
viable future possibilities.

This is the route toward **embedded intent**: action grounded in what an agent
can actually reach and sustain, rather than in an externally assigned score.

## Related

`TECHNOLOGY/Abzu`, `PROBLEMS/Planning`, and `RESEARCH/Open Problems`.
