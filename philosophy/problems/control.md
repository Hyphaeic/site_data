# Control

> STATUS: OPEN PROBLEM

Control by total specification reproduces the sim-to-real gap at every new boundary.

## The problem

How should a system control what it cannot completely specify, observe, or
predict?

## Failure mode

Increasing specification cannot close the gap between a finite description and
a changing world. A controller that suppresses evidence against its model
becomes less correct as it becomes more capable.

## Direction

Control must remain coupled to consequence. Local actors act within bounds,
receive evidence from outcomes, and adapt without requiring a central complete
model. The aim is corrigible control, not total control.

## Related

`TECHNOLOGY/STOK-CORE`, `TECHNOLOGY/Abzu`, and `FOUNDATIONS/Representation`.
