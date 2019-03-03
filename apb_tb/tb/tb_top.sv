
module tb_top;

parameter HALF_PERIOD = 10ns;

logic PCLK;
logic PRESETn;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_agent_pkg::*;

`include "apb_env_config.svh"
`include "apb_env.svh"

`include "apb_base_test.svh"
`include "apb_write_test.svh"

string report_id = "tb_top";

apb_if APB(.PCLK(PCLK), .PRESETn(PRESETn));

dut dut_inst (
    .PCLK       (PCLK), 
    .PRESETn    (PRESETn),
    .PADDR      (APB.PADDR),
    .PWDATA     (APB.PWDATA),
    .PSEL       (),
    .PENABLE    (APB.PENABLE),
    .PWRITE     (APB.PWRITE),
    .PREADY     (APB.PREADY),
    .PRDATA     (APB.PRDATA)
);

initial begin
  `uvm_info(report_id, "starts", UVM_MEDIUM)
  uvm_config_db #(virtual apb_if)::set(null, "uvm_test_top", "APB", APB);
  run_test();
end

initial begin 
  PCLK = 0;
  PRESETn = 0;
  repeat(10) begin
    #(HALF_PERIOD) PCLK = ~PCLK;
  end
  PRESETn = 1;
  forever begin
    #(HALF_PERIOD) PCLK = ~PCLK;
  end    
end

endmodule

