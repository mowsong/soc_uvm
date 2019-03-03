module dut(
    input PCLK,
    input PRESETn,
    input [31:0] PADDR,
    input [31:0] PWDATA,
    input PSEL,
    input PENABLE,
    input PWRITE,

    output PREADY,
    output [31:0] PRDATA
);

assign PREADY = 1'b1;
assign PRDATA = 32'hACCE55;


endmodule

