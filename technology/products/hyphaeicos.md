# HyphaeicOS

> STATUS: IMPLEMENTED, LIVE
> STATE: ACTIVE · LIVE

An instance of HyphaeicOS exists across the bounds of the network its peers can
access.

## The problem

Autonomous systems need a substrate that stays deterministic and coherent across
heterogeneous hardware, different rates, and bounded network access.

## The approach

HyphaeicOS is defined by participating peers, not a particular physical
computer. In an isolated body, its instance ends at the internal network
boundary. That boundary is a functional part of the system, not an incidental
deployment detail.

The substrate is designed for real-time, deterministic operation across peers
and for hardware-agnostic embodiment.

## Current platform and runtime work

The current public platform is a browser OS built with WebAssembly and SolidJS.
It runs through a host operating system, which is useful for access but adds
abstraction between an agent and the machine it inhabits.

Hyphos is the developing real-time backend for direct execution of raw WASM
bytecode. An early prototype includes a deterministic memory scheduler, logical
clock, keyboard input, audio output, and graphical output. The longer-term
direction is a standalone, decentralised MiniOS that can communicate directly
with accessible peers over raw Ethernet frames.

## Status

HyphaeicOS is implemented and live. Its broader theory of embodied,
multiclock coherence remains an active research programme.

## Why it matters

Computation becomes native to an autonomous system when state, timing, and
network boundary are part of its own organisation.

## Related
`TECHNOLOGY/HyphaFabric`, `TECHNOLOGY/Phax`, and `PROBLEMS/Embodiment`.
