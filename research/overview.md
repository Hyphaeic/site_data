# Research Overview

> STATUS: POSITION

Hyphaeic investigates a single question across mathematics, computing,
embodiment, and institutions.

> How do purposeful systems made of partially informed, independently acting
> parts remain coherent, viable, and corrigible through change without complete
> representation, central control, or terminal optimisation?

The research is not an attempt to replace one coordination algorithm with
another. It asks which architecture can keep a system coupled to what its
models omit.

---

## Where the current stack fails

### Swarm and multi-robot systems

**Problem.** Large groups of robots lose collective coherence when communication
is intermittent, positioning is unreliable, or clocks drift.

**Current limitation.** Central coordination and tight time synchronisation can
become single points of failure; partitions can lead to conflict or deadlock.

**Research relevance.** Local clocks and harmonic propagation describe
coherent islands that can separate, continue, and re-establish relationships
without a global clock or central state.

---

### Edge multi-agent systems

**Problem.** Fleets of agents need to cooperate while cloud connectivity is
intermittent or absent.

**Current limitation.** Many frameworks assume eventual shared state or periodic
central reconciliation. When it is unavailable, independent agents diverge.

**Research relevance.** Local representation is primary; coherence is studied
as an emergent consequence of local propagation rather than shared memory or a
leader.

---

### Autonomous vehicles and vehicle infrastructure

**Problem.** Vehicle coordination must remain safe under interference, latency,
and network partition.

**Current limitation.** Existing designs often depend on external timing and
relatively tight synchronisation.

**Research relevance.** Locally coherent time can support internally consistent
vehicle groups that later re-establish broader coordination without a master
clock.

---

### Distributed energy resources

**Problem.** Inverters, batteries, chargers, and generation must coordinate
phase, frequency, and power flow at the grid edge.

**Current limitation.** Hierarchical control can create cascading failure
points; peer approaches struggle with coherence under asymmetric information.

**Research relevance.** The programme studies local harmonic coordination among
independent nodes, where broader coherence does not require one central
controller.

---

### Satellite constellations and space systems

**Problem.** Constellations coordinate sensing, communication, and manoeuvres
across latency, component failure, and unreliable time references.

**Current limitation.** Ground-segment dependence and brittle synchronisation
limit operation when communication is constrained.

**Research relevance.** Deterministic local propagation and harmonic islands
map directly to systems that must continue from local memory and later
reconcile.

---

### Industrial IoT and smart manufacturing

**Problem.** Factory sensors, actuators, and controllers must preserve process
coherence through jitter, partial failure, and imperfect clocks.

**Current limitation.** Top-down orchestration grows fragile as the number and
heterogeneity of controllers increase.

**Research relevance.** Local representation and deterministic propagation aim
at reproducible, partition-tolerant process coherence.

---

### Contested and denied environments

**Problem.** Critical systems must operate when positioning is disrupted,
networks are partitioned, and central command is unavailable or compromised.

**Current limitation.** Many architectures degrade sharply when their assumed
global references disappear.

**Research relevance.** The architecture treats the absence of global
references as a native condition, not a fallback mode.

---

### Synthetic and bio-hybrid systems

**Problem.** Living or hybrid components must form coherent morphology and
behaviour without a controller that possesses the whole.

**Current limitation.** Current approaches are commonly either top-down or
purely evolutionary, with no general account of competence scaling from parts
to wholes.

**Research relevance.** Local representation, harmonic coherence, and the
non-commuting structure of FDRS offer a formal vocabulary for this
local-to-global problem.

---

### Large-scale sensor and monitoring networks

**Problem.** Environmental, structural, and security networks must form useful
situational awareness from independent nodes with intermittent connectivity.

**Current limitation.** Central aggregation adds latency, cost, and a single
point of failure; decentralised designs can lose coherence.

**Research relevance.** Locally coherent models can be maintained and later
reconciled without continuous global synchronisation.

---

### Real-time embodied control

**Problem.** A complex body contains independently operating joints, sensors,
reflex loops, and controllers that must produce whole-body behaviour through
latency, noise, and fault.

**Current limitation.** Global optimisers assume broad state visibility and
tight synchronisation; purely learned control can degrade unpredictably under
distribution shift or hardware failure.

**Research relevance.** Local models and clocks, coupled through harmonic
propagation, make coherence a property of the local rules rather than a
permanent central planner.

---

## Adjacent research fields

The programme intersects with several active fields. These are not separate
product categories; they are different expressions of the same questions about
coherence, recovery, and bounded agency.

| Field | The unresolved issue | Hyphaeic connection |
| :-- | :-- | :-- |
| **Long-horizon agents** | Recoverable execution, skill composition, and coherence across tool use | Local state, residual ledgers, and compositional option kernels |
| **Reasoning and inference-time search** | Verifiable intermediate reasoning across long chains | Deterministic local structure and machine-checked representation theory |
| **World models** | Persistent, replayable state under partial views and long horizons | Mixed-radix time and deterministic local propagation |
| **Research agents** | Verification and safe self-modification | Formal foundations, replay, residuals, and bounded authority |
| **Multi-agent systems** | Conflicting plans and cascading errors under partial observability | Local-to-global coherence as the central research question |
| **Physical AI** | Asynchronous control, latency, and sim-to-real failure | Multiclock execution and embodied local control |
| **AI for science** | Reliable long-horizon experimentation and judgement | Coherent agents coupled to formal and empirical evidence |
| **Runtime safety** | Recovery and verification once agents act in the world | Explicit bounds, residual accounting, and feasibility-based planning |

---

## Applied research threads

Some work applies the representation and coherence programme to specific
industrial questions without being presented as a finished product line.

| Thread | Research question |
| :-- | :-- |
| **Magnon** | How can FDRS-informed representation contribute to micromagnetic simulation? |
| **SIGIL** | How can high-speed signal-integrity simulation for PCIe 5 and 6 benefit from exact, bounded representation? |
| **Geometry and manufacturing** | Can exact integer geometry improve repeatability in digital twins, remote operation, and constructive geometry? |

---

## The research record

- `RESEARCH/Programmes`: the broad lines of inquiry and their questions.
- `RESEARCH/Open Problems`: where confidence stops and what progress would
  require.
- `RESEARCH/Results`: formal, implemented, and experimental work, clearly
  distinguished.
- `RESEARCH/Math Experiments`: the automated record of individual experiments.
