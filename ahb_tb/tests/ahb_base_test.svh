class ahb_base_test extends uvm_test;

`uvm_component_utils(ahb_base_test)

ahb_env           m_env;
ahb_env_config    m_env_cfg;

ahb_agent_config  m_ahb_agent_cfg;

// virtual interface is in scope because tests are *** included *** in the tb_top
virtual interface ahb_if AHB; 

extern function new(string name = "ahb_base_test", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task main_phase(uvm_phase phase);

endclass : ahb_base_test


//--------------------------------------------------------------------
// Function/Task Body
//--------------------------------------------------------------------
function ahb_base_test::new(string name = "ahb_base_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void ahb_base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  // environment configs
  m_env_cfg = ahb_env_config::type_id::create("m_env_cfg");

  m_ahb_agent_cfg = ahb_agent_config::type_id::create("m_ahb_agent_cfg");
  if (!uvm_config_db #(virtual ahb_if)::get(this, "", "AHB", m_ahb_agent_cfg.AHB)) begin
    `uvm_fatal("build_phase", "Unable to find AHB interface")
  end
  
  AHB = m_ahb_agent_cfg.AHB;
  m_env_cfg.m_ahb_agent_cfg = m_ahb_agent_cfg;
  m_ahb_agent_cfg.start_address[0] = 0;
  m_ahb_agent_cfg.range[0] = 32'h100;

  m_env = ahb_env::type_id::create("m_env", this);
  uvm_config_db #(ahb_env_config)::set(this, "m_env*", "ahb_env_config", m_env_cfg);
  `uvm_info("build_phase", "done", UVM_MEDIUM)
  
endfunction

function void ahb_base_test::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction

task ahb_base_test::main_phase(uvm_phase phase);
  phase.raise_objection(this);

  #1000;
  
  phase.drop_objection(this);
endtask


