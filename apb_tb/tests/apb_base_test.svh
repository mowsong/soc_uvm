class apb_base_test extends uvm_test;

`uvm_component_utils(apb_base_test)

string report_id = "apb_base_test";

apb_env           m_env;
apb_env_config    m_env_cfg;

apb_agent_config  m_apb_agent_cfg;

// virtual interface is in scope because tests are included in the tb_top
virtual interface apb_if APB; 

extern function new(string name = "apb_base_test", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task main_phase(uvm_phase phase);

endclass : apb_base_test


//--------------------------------------------------------------------
// Function/Task Body
//--------------------------------------------------------------------
function apb_base_test::new(string name = "apb_base_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void apb_base_test::build_phase(uvm_phase phase);
  `uvm_info(report_id, "build phase starting", UVM_MEDIUM)
  super.build_phase(phase);
  
  // environment configs
  m_env_cfg = apb_env_config::type_id::create("m_env_cfg");

  m_apb_agent_cfg = apb_agent_config::type_id::create("m_apb_agent_cfg");
  if (!uvm_config_db #(virtual apb_if)::get(this, "", "APB", m_apb_agent_cfg.APB)) begin
    `uvm_fatal(report_id, "Unable to find APB interface")
  end
  
  APB = m_apb_agent_cfg.APB;
  m_env_cfg.m_apb_agent_cfg = m_apb_agent_cfg;
  m_apb_agent_cfg.start_address[0] = 0;
  m_apb_agent_cfg.range[0] = 32'h100;

  m_env = apb_env::type_id::create("m_env", this);
  uvm_config_db #(apb_env_config)::set(this, "m_env*", "apb_env_config", m_env_cfg);
  
  `uvm_info(report_id, "build phase ending", UVM_MEDIUM)

endfunction

function void apb_base_test::connect_phase(uvm_phase phase);
  `uvm_info(report_id, "connect phase", UVM_MEDIUM)
  super.connect_phase(phase);
  `uvm_info(report_id, "connect phase ending", UVM_MEDIUM)
endfunction

task apb_base_test::main_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info(report_id, "main phase starting", UVM_MEDIUM)
  
  wait (APB.PRESETn);

  #1000;
  
  phase.drop_objection(this);
  `uvm_info(report_id, "main phase ending", UVM_MEDIUM)
endtask


