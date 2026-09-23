# ChessBender

> STATUS: DEMONSTRATED
> STATE: ACTIVE · INTERACTIVE · SOURCE

ChessBender is a four-element tactics game and a reward-free AI research
platform built on the deterministic substrate.

## The world

Humans and agents are the same kind of participant. Both author plans; a
deterministic integer simulation is the only resolver. The game runs as
WebAssembly over the peer fabric, where participants move through a persistent
world on local step-clocks. When two participants meet, the ground between them
becomes a shared turn.

## The research use

ChessBender provides a bounded world in which plans can be evaluated without a
hand-authored reward function. Training rows begin with real positions and
candidate plans. The deterministic resolver is run forward to measure how the
position's available potential changes.

This makes the game a testbed for STOK-CORE, Abzu, and FDRS: option composition,
commitment, self-play, local clocks, and deterministic peer agreement can be
examined in the same system.

## Research status

ChessBender is demonstrated and interactive. The agent architecture, including
models of self-attribution, promise tracking, and composition of learned plans,
remains ongoing research.

## Why it matters

A game is small enough to inspect completely, but rich enough to expose the
difference between maximising a score and preserving a capacity for coherent,
revisable action.

## Related

`TECHNOLOGY/HyphaFabric`, `TECHNOLOGY/STOK-CORE`, and `TECHNOLOGY/Abzu`.
