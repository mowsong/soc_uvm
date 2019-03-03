
class apb_env extends uvm_env;

`uvm_component_utils(apb_env)

apb_env_config  m_env_cfg;

apb_agent       m_apb_agent;

extern function new(string name = "apb_env", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass : apb_env

//--------------------------------------------------------------------
// Function/Task Body
//--------------------------------------------------------------------
function apb_env::new(string name = "apb_env", uvm_component parent = null);
  super.new(name, parent);
endfunction

//--------------------------------------------------------------------
function void apb_env::build_phase(uvm_phase phase);
  if (!uvm_config_db #(apb_env_config)::get(this, "", "apb_env_config", m_env_cfg)) begin
    `uvm_fatal("build_phase", "Unable to get apb_env_config")
  end

  m_apb_agent = apb_agent::type_id::create("m_apb_agent", this);
  uvm_config_db #(apb_agent_config)::set(this, "m_apb_agent*", "apb_agent_config", m_env_cfg.m_apb_agent_cfg);

endfunction


//--------------------------------------------------------------------
function void apb_env::connect_phase(uvm_phase phase);
endfunction


//--------------------------------------------------------------------
task apb_env::run_phase(uvm_phase phase);
endtask


