
module tb_top;

parameter HALF_PERIOD = 10ns;

logic HCLK;
logic HRESETn;

import uvm_pkg::*;
`include "uvm_macros.svh"

import ahb_agent_pkg::*;

`include "ahb_env_config.svh"
`include "ahb_env.svh"

`include "ahb_base_test.svh"
`include "ahb_unpipelined_write_test.svh"
`include "ahb_pipelined_write_test.svh"

ahb_if AHB(.HCLK(HCLK), .HRESETn(HRESETn));

dut dut_inst (
  .HCLK       (AHB.HCLK),
  .HRESETn    (AHB.HRESETn),
  .HWDATA     (AHB.HWDATA),
  .HWRITE     (AHB.HWRITE),
  .HTRANS     (AHB.HTRANS),
  .HREADY     (AHB.HREADY),
  .HRESP      (AHB.HRESP),
  .HRDATA     (AHB.HRDATA)
);

initial begin
  uvm_config_db #(virtual ahb_if)::set(null, "uvm_test_top", "AHB", AHB);
  run_test();
end

initial begin 
  HCLK = 0;
  HRESETn = 0;
  repeat(10) begin
    #(HALF_PERIOD) HCLK = ~HCLK;
  end
  HRESETn = 1;
  forever begin
    #(HALF_PERIOD) HCLK = ~HCLK;
  end    
end

endmodule

