# Time

> STATUS: OPEN PROBLEM

Different clocks at different resolutions; a system must stay one system across all of them.

## The problem

A fingertip, vision loop, motor controller, and planner do not share a useful
clock. Neither do peers in a distributed system. What does coherence mean when
time is local and rates differ?

## Failure mode

External time sources, tight synchronisation, and a single reference clock are
often treated as prerequisites. Under latency, partition, or interference,
those assumptions fail.

## Direction

Local logical clocks decouple ordering from hardware speed. FDRS records phase
and scale within representation itself; harmonic relationships allow local
systems to stay internally coherent and later re-harmonise.

## Related

`TECHNOLOGY/FDRS`, `TECHNOLOGY/HyphaFabric`, and `RESEARCH/Open Problems`.
