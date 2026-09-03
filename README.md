# 4×4 RTL Router

## Objective

Design and verify a 4-input, 4-output digital packet router
using Verilog RTL.

## Tools

- Xilinx Vivado
- Verilog HDL
- GitHub

## Initial Specification

Inputs  : 4
Outputs : 4
Payload : 8 bits
Destination : 2 bits
Packet size : 10 bits

## Destination Mapping

00 → Output 0
01 → Output 1
10 → Output 2
11 → Output 3

## Arbitration

Fixed priority:

IP0 > IP1 > IP2 > IP3

## Packet Format

Each input port sends a 10-bit packet.

| Field | Width | Bits |
|-------|-------|------|
| Destination | 2 bits | [9:8] |
| Payload | 8 bits | [7:0] |

### Packet Structure

[ DESTINATION ][ PAYLOAD ]

### Destination Mapping

00 -> OP0
01 -> OP1
10 -> OP2
11 -> OP3

### Input Valid Signals

Each input port has a corresponding valid signal.

IP0_packet[9:0], IP0_valid  
IP1_packet[9:0], IP1_valid  
IP2_packet[9:0], IP2_valid  
IP3_packet[9:0], IP3_valid

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
