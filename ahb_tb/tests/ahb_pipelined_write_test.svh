class ahb_pipelined_write_test extends ahb_base_test;

`uvm_component_utils(ahb_pipelined_write_test)

extern function new(string name = "ahb_pipelined_write_test", uvm_component parent = null);
extern task main_phase(uvm_phase phase);

endclass : ahb_pipelined_write_test


//--------------------------------------------------------------------
// Function/Task Body
//--------------------------------------------------------------------
function ahb_pipelined_write_test::new(string name = "ahb_pipelined_write_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task ahb_pipelined_write_test::main_phase(uvm_phase phase);
  ahb_pipelined_seq seq;

  phase.raise_objection(this);

  for (int i=0; i<20; i++) begin
    seq = ahb_pipelined_seq::type_id::create("seq");
  
    seq.start(m_env.m_ahb_agent.m_sequencer);

    repeat (5) @(posedge m_ahb_agent_cfg.AHB.HCLK);

  end

  phase.drop_objection(this);
endtask


