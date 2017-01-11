//
// Class Description:
//
//
class ahb_monitor extends uvm_component;

// UVM Factory Registration Macro
//
`uvm_component_utils(ahb_monitor);

// Virtual Interface
virtual ahb_if AHB;

//------------------------------------------
// Data Members
//------------------------------------------
int ahb_index = 0; // Which PSEL line is this monitor connected to
//------------------------------------------
// Component Members
//------------------------------------------
uvm_analysis_port #(ahb_seq_item) ap;

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:

extern function new(string name = "ahb_monitor", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);

endclass: ahb_monitor

function ahb_monitor::new(string name = "ahb_monitor", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void ahb_monitor::build_phase(uvm_phase phase);
  ap = new("ap", this);
endfunction: build_phase

task ahb_monitor::run_phase(uvm_phase phase);
  ahb_seq_item item;
  ahb_seq_item cloned_item;

  item = ahb_seq_item::type_id::create("item");

  forever begin
    // Detect the protocol event on the TBAI virtual interface
    @(posedge AHB.HCLK);
  end
endtask: run_phase

function void ahb_monitor::report_phase(uvm_phase phase);
// Might be a good place to do some reporting on no of analysis transactions sent etc

endfunction: report_phase
