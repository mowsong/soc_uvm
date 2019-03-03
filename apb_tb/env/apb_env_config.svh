
class apb_env_config extends uvm_object;

`uvm_object_utils(apb_env_config)

apb_agent_config m_apb_agent_cfg;

extern function new(string name = "apb_env_config");

endclass : apb_env_config

function apb_env_config::new(string name = "apb_env_config");
  super.new(name);
endfunction


