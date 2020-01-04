module top_GPDI_mirror
(
  input [6:0] btn,
  output [3:0] gpdi_dp,
  input gp9,gp10,gp11,gp12, // differential input
  output gn7,gp7,gn8,gp8,  // more PMOD pins
  output wifi_gpio0
);
    parameter C_ddr = 1'b1; // 0:SDR 1:DDR

    // wifi_gpio0=1 keeps board from rebooting
    // hold btn0 to let ESP32 take control over the board
    assign wifi_gpio0 = btn[0];
    wire [3:0] serial_data;

// We can use Input Output buffer 
// ILVDS ilvds_I3(.A(gp[12]), /*.AN(gn[12]),*/ .Z(serial_data[3])); 
// ILVDS ilvds_I2(.A(gp11), /*.AN(gn[11]),*/ .Z(serial_data[2])); 
// ILVDS ilvds_I1(.A(gp10), /*.AN(gn[10]),*/ .Z(serial_data[1])); 
// ILVDS ilvds_I0(.A(gp9), /*.AN(gn[9]),*/ .Z(serial_data[0]));

// OLVDS olvds_O3(.A(serial_data[3]), /*.ZN(gpdi_dn[3]),*/ .Z(gpdi_dp[3]));
// OLVDS olvds_O2(.A(serial_data[2]), .ZN(gpdi_dn[2]), .Z(gpdi_dp[2]));
// OLVDS olvds_O1(.A(serial_data[1]), .ZN(gpdi_dn[1]), .Z(gpdi_dp[1]));
// OLVDS olvds_O0(.A(serial_data[0]), .ZN(gpdi_dn[0]), .Z(gpdi_dp[0]));

// OLVDS olvds_clock (.A(/*clk_clk_phase*/clk_recovery), .Z(gpdi_dp[3]) /*,.ZN(gpdi_dn[3]) */);

assign gpdi_dp[3] = clk_recovery;
assign gpdi_dp[2] = gp11;
assign gpdi_dp[1] = gp10;
assign gpdi_dp[0] = gp9;

wire clk_phase,clk_recovery;

clk_25_25_25        
clock_instance
(
    .clki(gp12),
    .clko(clk_recovery), 
    .clko1(clk_phase)
  );

reg [23:0] blink;
always @(posedge gp12)
  blink <= blink+1;

// LED on PMOD
assign gn7 = blink[23];

// Other PMOD pins
assign gp7 = 1'b1;
assign gp8 = 1'b1;
assign gn8 = 1'b1;

endmodule
