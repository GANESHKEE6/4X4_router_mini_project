# Router Internal Architecture

## Overview
The 4x4 RTL Router uses a crossbar topology divided into three modular stages: Destination Decoding, Arbitration, and Switch Fabric.

## Block Diagram

             INPUTS (IP0-IP3: 10-bit Data + Valid)
                │      │      │      │
          ┌─────▼──────▼──────▼──────▼─────┐
          │                                │
          │    DESTINATION DECODERS (4)    │  <-- Extracts 2-bit dest
          │                                │
          └─────┬──────┬──────┬──────┬─────┘
                │      │      │      │        16 Request Wires 
                │      │      │      │        (req_ipX_to_opY)
          ┌─────▼──────▼──────▼──────▼─────┐
          │                                │
          │      FIXED-PRIORITY            │  <-- Resolves contention
          │      ARBITERS (4)              │      (IP0 > IP1 > IP2 > IP3)
          │                                │
          └─────┬──────┬──────┬──────┬─────┘
                │      │      │      │        16 Grant Wires
                │      │      │      │        (grant_ipX_to_opY)
          ┌─────▼──────▼──────▼──────▼─────┐
          │                                │
          │       4x4 SWITCH FABRIC        │  <-- Routes 10-bit Data
          │       (Multiplexers)           │
          │                                │
          └─────┬──────┬──────┬──────┬─────┘
                │      │      │      │
             OUTPUTS (OP0-OP3: 10-bit Data + Valid)

## Data Path vs. Control Path
* **Control Path:** Destination Decoders and Arbiters. They process the `valid` bits and the 2 `dest` bits to generate `grant` signals.
* **Data Path:** The Switch Fabric. It uses the `grant` signals as select lines to multiplex the full 10-bit packets to the correct output.

## Combinational Design
In Version 1, the core routing logic is fully combinational. Packets are evaluated and routed in the same clock cycle.

