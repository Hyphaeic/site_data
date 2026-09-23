# Hyphacom

> STATUS: IMPLEMENTED
> STATE: ACTIVE

Hyphacom is the HyphaeicOS communications and HyphaFabric console interface.

## What it is

An operator-facing surface for communication and inspection across a running
HyphaFabric.

## How it works

Hyphacom is a peer-to-peer communication system built from refreshable,
locally owned identities and information structures. No peer needs to persist a
complete copy of global chat state.

During a live session, peers project and host the segments that make up the
shared history. Writing does not require one central server to receive and
redistribute a message: a peer injects a changed local segment, and connected
peers compose that change into their relevant projection.

As peers appear, leave, or reconnect, the active graph of shared history
changes. Relevant peers can bring an out-of-date projection forward when they
meet again.

## What it demonstrates

Hyphacom is a live, human-scale demonstration of HyphaFabric across varied
hardware and connectivity. It is a temporary shared lobby, not a permanent
global inbox. Messages sent while no one is connected are not delivered.

## Related

`TECHNOLOGY/HyphaeicOS` and `TECHNOLOGY/HyphaFabric`.
