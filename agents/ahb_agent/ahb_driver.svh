//
// Class Description:
//
//
class ahb_driver extends uvm_driver #(ahb_seq_item, ahb_seq_item);

// UVM Factory Registration Macro
//
`uvm_component_utils(ahb_driver)

// Virtual Interface
virtual ahb_if AHB;

//------------------------------------------
// Data Members
//------------------------------------------
ahb_agent_config m_cfg;
//------------------------------------------
// Methods
//------------------------------------------
extern function int sel_lookup(logic[31:0] address);
// Standard UVM Methods:
extern function new(string name = "ahb_driver", uvm_component parent = null);
extern task run_phase(uvm_phase phase);
extern function void build_phase(uvm_phase phase);


endclass: ahb_driver

function ahb_driver::new(string name = "ahb_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction

task ahb_driver::run_phase(uvm_phase phase);
  ahb_seq_item req;
  ahb_seq_item rsp;

  `uvm_info(this.get_name(), "run_phase starts...", UVM_MEDIUM)

  // Wait for reset to clear
  @(posedge AHB.HRESETn);

  forever begin
    seq_item_port.get_next_item(req);
    
    @(posedge AHB.HCLK);
     
    seq_item_port.item_done();
  end

endtask: run_phase

function void ahb_driver::build_phase(uvm_phase phase);
  if(!uvm_config_db #(ahb_agent_config)::get(this, "", "ahb_agent_config", m_cfg)) begin
    `uvm_error("build_phase", "Unable to get ahb_agent_config")
  end
endfunction: build_phase

// Looks up the address and returns PSEL line that should be activated
// If the address is invalid, a non positive integer is returned to indicate an error
function int ahb_driver::sel_lookup(logic[31:0] address);
  for(int i = 0; i < m_cfg.no_select_lines; i++) begin
    if((address >= m_cfg.start_address[i]) && (address <= (m_cfg.start_address[i] + m_cfg.range[i]))) begin
      return i;
    end
  end
  return -1; // Error: Address not found
endfunction: sel_lookup
