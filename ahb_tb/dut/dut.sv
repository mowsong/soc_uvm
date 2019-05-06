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
reg HREADY;
assign HRDATA = 32'hACCE55;

always @(posedge HCLK, negedge HRESETn) begin
  if (!HRESETn)
    HREADY <= 0;
  else if (HWDATA == 2 || HWDATA == 5 || HWDATA == 6) begin
    HREADY <= 0;
    @(posedge HCLK);
    @(posedge HCLK);
    @(posedge HCLK);
    HREADY <= 1;
  end
  else
    HREADY <= 1;
end

endmodule
