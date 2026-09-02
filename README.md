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
