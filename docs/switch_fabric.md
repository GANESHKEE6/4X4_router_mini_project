# 4×4 Switch Fabric

## Purpose
The switch fabric serves as the primary **Data Path** for the router. While the decoder and arbiter decide *who* gets to go *where*, the switch fabric physically executes that decision, connecting the chosen input packet to the requested output port.

## Data Path & Crossbar Architecture
The module implements a 4×4 Crossbar Topology. Conceptually, it is constructed from four independent 4:1 multiplexers (one dedicated to each output). This allows complete non-blocking connectivity, meaning multiple inputs can be routed to multiple distinct outputs simultaneously.

```text
       IP0   IP1   IP2   IP3
        │     │     │     │
OP0 ────┼─────┼─────┼─────┼───► (4:1 MUX driven by OP0 Grants)
        │     │     │     │
OP1 ────┼─────┼─────┼─────┼───► (4:1 MUX driven by OP1 Grants)
