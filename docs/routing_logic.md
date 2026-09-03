# Routing Logic: Destination Decoder

## Purpose
The Destination Decoder is a purely combinational block that inspects incoming packets and requests access to the appropriate output port. Four instances of this decoder will eventually sit at the front end of the router (one for each input port).

## Packet Format & Mapping
* **Format:** `[9:8]` Destination, `[7:0]` Payload
* **Mapping:**
  * `00` -> OP0
  * `01` -> OP1
  * `10` -> OP2
  * `11` -> OP3

## Request Equations & Truth Table
Requests are strictly gated by the `valid` signal to prevent garbage routing.

| valid | packet[9:8] | req_op0 | req_op1 | req_op2 | req_op3 |
| :---: | :---: | :---: | :---: | :---: | :---: |
| 0 | XX | 0 | 0 | 0 | 0 |
| 1 | 00 | 1 | 0 | 0 | 0 |
| 1 | 01 | 0 | 1 | 0 | 0 |
| 1 | 10 | 0 | 0 | 1 | 0 |
| 1 | 11 | 0 | 0 | 0 | 1 |

* `req_op0 = valid & (packet[9:8] == 2'b00)`
* `req_op1 = valid & (packet[9:8] == 2'b01)`
* `req_op2 = valid & (packet[9:8] == 2'b10)`
* `req_op3 = valid & (packet[9:8] == 2'b11)`

## Implementation & Verification Strategy
The logic is implemented using continuous assignments for zero-latency combinational routing. 

Verification confirms three critical properties:
1. **One-hot routing:** A valid packet requests exactly one output.
2. **Valid gating:** An invalid packet (`valid=0`) triggers no requests.
3. **Payload independence:** Variations in `packet[7:0]` do not alter destination requests.

**Test Results:** Simulated via self-checking testbench in Vivado. All corner cases and payload independence tests passed.
