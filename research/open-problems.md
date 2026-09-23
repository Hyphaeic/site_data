# Open Problems

> STATUS: OPEN PROBLEM

Where confidence stops, deliberately public. Each problem names the missing
result, why it matters, and the current line of attack.

---

## 01. Representation with a free counting base

**Problem.** Standard numeration fixes a base. What algebraic and geometric
structure survives when the base at each position depends on position, earlier
digits, or state?

**Why it matters.** A variable base makes representation itself adaptive. It
may reveal structure invisible to a fixed-radix view.

**Current line of attack.** FDRS treats radix as a free parameter and records
which properties survive. The formal corpus is machine-checked in Lean 4.

## 02. Arithmetic in an ultrametric geometry

**Problem.** Mixed-radix numbers can be close when they share a long prefix.
We need a complete account of which arithmetic operations remain continuous and
local in this geometry, including the state required for Markovian evolution.

**Why it matters.** It makes shared history, rather than Euclidean distance,
the relevant notion of locality for discrete time.

**Current line of attack.** Tick, predecessor, and addition are studied as
prefix-preserving operations; radix phase is included as state.

## 03. Discoverable hierarchical state spaces

**Problem.** How can a system infer useful partitions of state and time from
its own transitions, rather than inheriting a hierarchy from a designer?

**Why it matters.** Open-ended planning requires discovering what counts as a
place, a skill, or a useful level of description.

**Current line of attack.** OctSet segments and FDRS provenance provide a
grammar for partitions, with kernels solved locally and joined at boundaries.

## 04. Compositional optionality on local clocks

**Problem.** Construct readable, compositional kernels over state and time that
operate without external reward or a global clock.

**Why it matters.** Long-horizon planning usually restores a shared clock or
collapses its decision into a scalar objective.

**Current line of attack.** Local clocks, harmonic coherence, jump-form
kernels, and a declared-versus-realised residual ledger.

## 05. Plasticity and empowerment across scale

**Problem.** Plasticity measures how observation changes action; empowerment
measures how action changes reachable futures. Their formal relationship must
be extended to hierarchical, multi-rate systems and made useful for control.

**Why it matters.** It would relate a system's capacity to learn from the world
to its capacity to act within it.

**Current line of attack.** Meter and journal both quantities on a common
ladder, then use residuals to adapt the kernels themselves.

## 06. Formal collective intelligence

**Problem.** Give a mathematical account of how competent local parts generate
memory, goals, and problem-solving capacities at the scale of the whole.

**Why it matters.** Biology, robotics, and distributed computing all require
coherence without a central possessor of global state.

**Current line of attack.** Local representation, harmonic propagation, and
the non-commuting structure of FDRS.

## 07. Partition-invariant deterministic propagation

**Problem.** Define local propagation whose global result is bit-for-bit
identical despite network partition and message delay, subject to the stated
local-clock and re-synchronisation rules.

**Why it matters.** It would offer reproducibility stronger than eventual
consistency for systems that cannot rely on continuous connectivity.

**Current line of attack.** Local memory, deterministic simulation, and
ultrametric locality.

## 08. Incremental repair under continuous change

**Problem.** How should option kernels be repaired when a world model changes
locally on every tick, rather than through rare discrete edits?

**Why it matters.** Real environments change continuously; rebuilding a plan
from scratch is neither practical nor coherent.

**Current line of attack.** Residual ledgers, belief fingerprints, and FDRS
provenance.

## 09. Epistemology of pure local representation

**Problem.** If local representation is all that physically exists, which
global claims remain meaningful and which are observer-relative?

**Why it matters.** It removes the assumed God's-eye view from the foundations
of time, observation, and coherence.

**Current line of attack.** Mixed-radix ultrametrics, local clocks, and
harmonic islands as a mathematical embodiment of the stance.
