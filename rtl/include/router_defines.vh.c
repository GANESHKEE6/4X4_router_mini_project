// router_defines.vh
// Global parameters for the 4x4 RTL Router

`ifndef ROUTER_DEFINES_VH
`define ROUTER_DEFINES_VH

// Packet Configuration
`define PAYLOAD_WIDTH 8
`define DEST_WIDTH    2
`define PKT_WIDTH     (`PAYLOAD_WIDTH + `DEST_WIDTH)

// Packet Field Boundaries (for slicing)
// Destination: bits [9:8]
// Payload: bits [7:0]
`define DEST_MSB      (`PKT_WIDTH - 1)
`define DEST_LSB      `PAYLOAD_WIDTH
`define PAYLOAD_MSB   (`PAYLOAD_WIDTH - 1)
`define PAYLOAD_LSB   0

`endif
