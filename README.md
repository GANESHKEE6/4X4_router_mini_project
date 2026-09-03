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
