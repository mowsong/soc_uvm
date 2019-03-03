class apb_write_test extends apb_base_test;

`uvm_component_utils(apb_write_test)

string report_id = "apb_write_test";

apb_write_seq w_seq;

extern function new(string name = "apb_write_test", uvm_component parent = null);
extern task main_phase(uvm_phase phase);

endclass : apb_write_test


//--------------------------------------------------------------------
// Function/Task Body
//--------------------------------------------------------------------
function apb_write_test::new(string name = "apb_write_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task apb_write_test::main_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info(report_id, "main phase starting", UVM_MEDIUM)
  
  w_seq = apb_write_seq::type_id::create("w_seq");

  wait(APB.PRESETn);

  repeat(10) @(posedge APB.PCLK);
  
  for (int i = 0; i<10; i++) begin
    
    w_seq.randomize() with { addr>= 32'h0; addr <=32'h100; };
    w_seq.start(m_env.m_apb_agent.m_sequencer);

  end

  repeat(100) @(posedge APB.PCLK);
  
  for (int i = 0; i<10; i++) begin
    
    w_seq.randomize() with { addr == 32'h10; };
    w_seq.start(m_env.m_apb_agent.m_sequencer);

  end

  phase.drop_objection(this);
  `uvm_info(report_id, "main phase ending", UVM_MEDIUM)
endtask


