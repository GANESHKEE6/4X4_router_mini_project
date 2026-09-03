# 4×4 Router Integration

## Integration Objective
To integrate the fully verified destination decoders, arbiters, and switch fabric into a single cohesive hierarchical top-level module (`router_4x4`), maintaining strict separation between the control path and data path.

## Module Hierarchy
                         router_4x4
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
  4 Decoders           4 Arbiters         Switch Fabric
        │                    │                    │
        ▼                    ▼                    ▼
     Requests              Grants             Outputs

## Request & Grant Matrices
* **Decoders (Input Centric):** Each of the 4 inputs generates 4 requests, yielding 16 total request lines.
* **Arbiters (Output Centric):** The 16 request lines are transposed. `arbiter_op0` groups `req_ip0_to_op0` through `req_ip3_to_op0` and outputs 4 grants dictating access to `OP0`.

## End-to-End Data Flow
1. `IP1` receives valid packet with destination `10`.
2. `decoder_ip1` parses destination and asserts `req_ip1_to_op2 = 1`.
3. `arbiter_op2` resolves requests and asserts `grant_ip1_to_op2 = 1`.
4. `switch_fabric` receives grant and routes `ip1_data` through the `OP2` multiplexer.

## Contention Behavior & Version 1 Limitations
In contention, the fixed-priority arbiters determine the winner (`IP0 > IP1`). 
**Limitation:** Because V1 is purely combinational and lacks input FIFOs or a `READY` backpressure signal, any packet that loses arbitration is dropped. The router does not buffer or hold un-granted packets. This is a known limitation of the V1 architectural foundation.

## Simulation Results
Self-checking behavioral simulation passed cross-routing, payload integrity, max-contention, and 4-way independent routing, proving successful integration.
