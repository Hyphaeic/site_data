# HyphaFabric

> STATUS: DEMONSTRATED, IMPLEMENTED
> STATE: ACTIVE · LIVE · SOURCE

Distributed state and computation across peers: the compute fabric
HyphaKernels compose into being.

## The problem

Peers need to remain useful and mutually coherent when network links fail,
messages are delayed, and no node has a complete view of the system.

## The approach

HyphaFabric provides a unified, hierarchical address space across participating
peers. Its topology follows operation rather than a fixed configuration. Local
state, local clocks, and bounded relationships are primary.

The intended model is not continuous global agreement. It is coherent local
operation, partition tolerance, and re-establishment of relationships when
communication resumes.

## Multiclock resource control

Each peer has an adjustable activity rate. Peers need not run at the same speed;
their rates need only remain within known bounds. Changing a local clock changes
the rate at which that peer consumes compute, memory, and network transport.

This makes resource demand a controllable property of the fabric rather than a
fixed consequence of deployment. A system can scale activity to current need,
hardware limits, and local preference while retaining a deterministic account of
the change.

## Local cost and execution

The fabric studies local pricing as a representation of computational and
temporal cost. Routing cost is measured close to the substrate, and peer roles
may be adjusted through that local cost model rather than a fixed hierarchy.

The current public system uses WebAssembly across heterogeneous peers. Work is
in progress on a bare-metal RISC-V substrate, hardware translation for WASM
bytecode, and FPGA targets for lower-latency execution.

## Status

HyphaFabric is implemented and demonstrated. The stronger claims about
partition-invariant, bit-level propagation remain research problems with
explicit conditions and tests.

## Why it matters

The fabric makes distributed coherence an architectural property, rather than a
service supplied by one coordinator or one authoritative store.

## Related
`TECHNOLOGY/FDRS`, `TECHNOLOGY/Phax`, and `PROBLEMS/Coordination`.
