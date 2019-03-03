
class ahb_env extends uvm_env;

`uvm_component_utils(ahb_env)

ahb_env_config  m_env_cfg;

ahb_agent       m_ahb_agent;

extern function new(string name = "ahb_env", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass : ahb_env

//--------------------------------------------------------------------
// Function/Task Body
//--------------------------------------------------------------------
function ahb_env::new(string name = "ahb_env", uvm_component parent = null);
  super.new(name, parent);
endfunction

//--------------------------------------------------------------------
function void ahb_env::build_phase(uvm_phase phase);
  if (!uvm_config_db #(ahb_env_config)::get(this, "", "ahb_env_config", m_env_cfg)) begin
    `uvm_fatal("build_phase", "Unable to get ahb_env_config")
  end

  m_ahb_agent = ahb_agent::type_id::create("m_ahb_agent", this);
  uvm_config_db #(ahb_agent_config)::set(this, "m_ahb_agent*", "ahb_agent_config", m_env_cfg.m_ahb_agent_cfg);
  `uvm_info("build_phase", "done", UVM_MEDIUM)
endfunction


//--------------------------------------------------------------------
function void ahb_env::connect_phase(uvm_phase phase);
endfunction


//--------------------------------------------------------------------
task ahb_env::run_phase(uvm_phase phase);
endtask


