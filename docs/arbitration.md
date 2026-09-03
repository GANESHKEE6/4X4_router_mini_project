# Fixed-Priority Arbitration

## Purpose
The arbiter resolves contention when multiple input ports attempt to send packets to the same output port simultaneously. It ensures that only one input is granted access at any given time, preventing data collisions in the switch fabric.

## Why Arbitration Is Required
Without an arbiter, concurrent requests would cause multiple data streams to route to a single destination port, corrupting the packet payloads and invalidating the router's internal multiplexer logic.

## Priority Policy
This router implements a Fixed-Priority scheme: **IP0 > IP1 > IP2 > IP3**.

## Request and Grant Signals
* **Request (`req_ipX`):** Asserted by the destination decoder when an input wants access.
* **Grant (`grant_ipX`):** Asserted by the arbiter to authorize the input to proceed.

## Truth Table
Bit ordering: `IP0, IP1, IP2, IP3` (MSB to LSB).
* `1111` -> `1000` (IP0 wins)
* `0111` -> `0100` (IP1 wins)
* `0011` -> `0010` (IP2 wins)
* `0001` -> `0001` (IP3 wins)

## Boolean Logic
The combinational logic ensures lower priorities are suppressed by higher priorities:
* `grant_ip0 = req_ip0`
* `grant_ip1 = ~req_ip0 & req_ip1`
* `grant_ip2 = ~req_ip0 & ~req_ip1 & req_ip2`
* `grant_ip3 = ~req_ip0 & ~req_ip1 & ~req_ip2 & req_ip3`

## RTL Implementation
Implemented using continuous Verilog assignments for zero-cycle latency combinational resolution.

## Verification Strategy
Verified via an exhaustive, self-checking testbench that tests all $2^4 = 16$ possible request combinations. The testbench actively asserts three properties:
1. No false grants.
2. At most one grant active.
3. Strict adherence to priority hierarchy.

## Test Results
All 16 combinations passed behavioral simulation in Vivado. Zero property violations detected.

## Limitations
Fixed priority easily leads to **starvation**. If IP0 and IP1 continuously request an output port, IP3 will theoretically be blocked indefinitely and never receive a grant.

## Future Improvement
To resolve starvation, the router could be upgraded to use **Round-Robin Arbitration**, which requires state tracking (flip-flops) to rotate the highest priority to the last-granted port.
