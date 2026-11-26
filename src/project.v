/*
 * Copyright (c) 2026 Silicon Edge
 * SPDX-License-Identifier: Apache-2.0
 *
 * Blackbox stub for the analog/mixed-signal macro tt_um_silicon_edge_ns_sar_adc.
 * The design itself is delivered as GDS (gds/) and LEF (lef/).
 */

`default_nettype none

module tt_um_silicon_edge_ns_sar_adc (
    input  wire       VGND,
    input  wire       VDPWR,    // 1.8 V power supply
    input  wire [7:0] ui_in,    // Dedicated inputs: ui_in[0] NS_EN, ui_in[1] AMP_SHARE
    output wire [7:0] uo_out,   // Dedicated outputs: B[7:0]
    input  wire [7:0] uio_in,   // IOs input path: uio_in[1] SCAN_EN, uio_in[2] SCAN_IN
    output wire [7:0] uio_out,  // IOs output path: uio_out[0] EOC, uio_out[3] SCAN_OUT
    output wire [7:0] uio_oe,   // IOs enable path (active high: 0=input, 1=output)
    inout  wire [7:0] ua,       // Analog pins, only ua[5:0] used
    input  wire       ena,      // EN
    input  wire       clk,      // conversion clock (96 kHz)
    input  wire       rst_n     // RST_N
);

endmodule
