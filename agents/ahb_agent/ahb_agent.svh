//
// Class Description:
//
//
class ahb_agent extends uvm_component;

// UVM Factory Registration Macro
//
`uvm_component_utils(ahb_agent)

//------------------------------------------
// Data Members
//------------------------------------------
ahb_agent_config m_cfg;

//------------------------------------------
// Component Members
//------------------------------------------
uvm_analysis_port #(ahb_seq_item) ap;
ahb_monitor          m_monitor;
ahb_sequencer        m_sequencer;
ahb_driver           m_driver;
ahb_coverage_monitor m_fcov_monitor;
//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM methods:
extern function new(string name = "ahb_agent", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass : ahb_agent


function ahb_agent::new(string name = "ahb_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void ahb_agent::build_phase(uvm_phase phase);
  if (!uvm_config_db #(ahb_agent_config)::get(this, "", "ahb_agent_config", m_cfg)) begin
    `uvm_error("build_phase", "Agent config not found")
  end

  `uvm_info("build_phase", m_cfg.convert2string(), UVM_LOW)

  // Monitor is always present
  m_monitor = ahb_monitor::type_id::create("m_monitor", this);
  // Only build the driver and sequencer if active
  if (m_cfg.active == UVM_ACTIVE) begin
    m_driver = ahb_driver::type_id::create("m_driver", this);
    m_sequencer = ahb_sequencer::type_id::create("m_sequencer", this);
  end
  
  if (m_cfg.has_functional_coverage) begin
    m_fcov_monitor = ahb_coverage_monitor::type_id::create("m_fcov_monitor", this);
  end
  ap = new("ap", this);
  `uvm_info("build_phase", "done", UVM_MEDIUM)
endfunction : build_phase


function void ahb_agent::connect_phase(uvm_phase phase);
  m_monitor.AHB = m_cfg.AHB;
  m_monitor.ahb_index = m_cfg.ahb_index;
  m_monitor.ap.connect(ap);
  if (m_cfg.active == UVM_ACTIVE) begin
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    m_driver.AHB = m_cfg.AHB;
  end
  if(m_cfg.has_functional_coverage) begin
    m_monitor.ap.connect(m_fcov_monitor.analysis_export);
  end

endfunction : connect_phase

