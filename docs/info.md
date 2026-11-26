## How it works

This is an 8-bit fully differential successive-approximation (SAR) ADC with a first-order
error-feedback noise-shaping loop (NS-SAR). It is built from:

- a split charge-redistribution capacitor DAC (CDAC) with bottom-plate switching,
- a dynamic comparator with preamplifier,
- an error-feedback loop (residue amplifier and switches) that, when enabled, shapes the
  quantisation noise to high frequencies so that decimation by OSR = 8 raises the in-band
  resolution,
- a synthesised digital SAR controller (sky130 standard cells) with a full scan chain
  (41 flip-flops, mux-scan) for production test.

Each conversion takes 12 cycles of `clk`. With `clk` = 96 kHz the raw sample rate is 8 kS/s.
The 8-bit result is on `uo_out[7:0]` (B[7] = MSB) and `uio_out[0]` pulses EOC (end of conversion).

`ui_in[0]` (NS_EN) turns the noise-shaping loop on (1) or off (0). `ui_in[1]` (AMP_SHARE) selects
the amplifier sharing mode. Keep it low for the standard mode.

### Scan test

The controller's flip-flops form one scan chain:
`uio_in[2]` = SCAN_IN, `uio_out[3]` = SCAN_OUT, `uio_in[1]` = SCAN_EN (active high, shifts on `clk`).
**SCAN_EN must be held low (driven, not floating) for normal ADC operation.**

## How to test

1. Power: VDPWR = 1.8 V, VGND = 0 V.
2. Analog references: VREF_P (`ua[3]`) = 1.8 V, VREF_N (`ua[4]`) = 0 V, VCM (`ua[2]`) = 0.9 V.
3. Bias: drive the bias current into IBIAS (`ua[5]`).
4. Drive `uio_in[1]` (SCAN_EN) low. Set `ui_in[0]` (NS_EN) = 1 for noise shaping or 0 for plain SAR,
   and `ui_in[1]` (AMP_SHARE) = 0.
5. Apply a differential input on V_P (`ua[1]`) and V_N (`ua[0]`), 0–1.8 V each around 0.9 V.
6. Apply a 96 kHz clock to `clk`, hold `rst_n` high and set `ena` high.
7. Capture `uo_out[7:0]` on each rising edge of EOC (`uio_out[0]`). For noise-shaped operation,
   decimate the 8 kS/s codes by 8 (sinc² recommended) to get the 1 kS/s high-resolution output.

Scan test: set SCAN_EN = 1, shift a pattern in on SCAN_IN with `clk` and read it back on SCAN_OUT
after 41 clocks.

## External hardware

- Precision 1.8 V / 0 V / 0.9 V references for VREF_P, VREF_N and VCM
- Current source for IBIAS
- Differential signal source (e.g. a low-distortion sine generator with a differential driver)
- Logic analyser or MCU to capture `uo_out[7:0]` on EOC
