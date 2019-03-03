module dut (
  input HCLK,
  input HRESETn,
  input [1:0] HTRANS,
  input [31:0] HWDATA,
  input HWRITE,
  output HREADY,
  output HRESP,
  output [31:0] HRDATA
);

assign HRESP = 1'b1;
assign HREADY = 1'b1;
assign HRDATA = 32'hACCE55;

endmodule
