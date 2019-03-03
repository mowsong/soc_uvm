
class ahb_env_config extends uvm_object;

`uvm_object_utils(ahb_env_config)

ahb_agent_config m_ahb_agent_cfg;

extern function new(string name = "ahb_env_config");

endclass : ahb_env_config

function ahb_env_config::new(string name = "ahb_env_config");
  super.new(name);
endfunction


