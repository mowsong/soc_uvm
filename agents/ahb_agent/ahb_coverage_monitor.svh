//
// Class Description:
//
// Functional coverage monitor for the AHB agent
//
// Collects basic coverage information
//
class ahb_coverage_monitor extends uvm_subscriber #(ahb_seq_item);

// UVM Factory Registration Macro
//
`uvm_component_utils(ahb_coverage_monitor);


//------------------------------------------
// Cover Group(s)
//------------------------------------------
covergroup ahb_cov;
OPCODE: coverpoint analysis_txn.we {
  bins write = {1};
  bins read = {0};
}
endgroup

//------------------------------------------
// Component Members
//------------------------------------------
ahb_seq_item analysis_txn;

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:

extern function new(string name = "ahb_coverage_monitor", uvm_component parent = null);
extern function void write(T t);
extern function void report_phase(uvm_phase phase);

endclass: ahb_coverage_monitor

function ahb_coverage_monitor::new(string name = "ahb_coverage_monitor", uvm_component parent = null);
  super.new(name, parent);
  ahb_cov = new();
endfunction

function void ahb_coverage_monitor::write(T t);
  analysis_txn = t;
  ahb_cov.sample();
endfunction:write

function void ahb_coverage_monitor::report_phase(uvm_phase phase);
// Might be a good place to do some reporting on no of analysis transactions sent etc

endfunction: report_phase
