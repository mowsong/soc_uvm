//
// Class Description:
//
//
class ahb_agent_config extends uvm_object;

// UVM Factory Registration Macro
//
`uvm_object_utils(ahb_agent_config)

// Virtual Interface
virtual ahb_if AHB;

//------------------------------------------
// Data Members
//------------------------------------------
// Is the agent active or passive
uvm_active_passive_enum active = UVM_ACTIVE;
// Include the AHB functional coverage monitor
bit has_functional_coverage = 0;
// Include the AHB RAM based scoreboard
bit has_scoreboard = 0;

// Address decode for the select lines:
int no_select_lines = 1;
int ahb_index = 0;  // Which HSEL is the monitor connected to
logic [31:0] start_address[15:0];
logic [31:0] range[15:0];

bit print_address = 0;

//------------------------------------------
// Methods
//------------------------------------------
// Standard UVM Methods:
extern function new(string name = "ahb_agent_config");

extern function string convert2string();

endclass : ahb_agent_config

//--------------------------------------------------------------------
//
//--------------------------------------------------------------------
function ahb_agent_config::new(string name = "ahb_agent_config");
  super.new(name);
endfunction

function string ahb_agent_config::convert2string();
  string s;

  s = super.convert2string();
  $sformat(s, "\n");
  $sformat(s, "%s-------------------------------------------------\n", s);
  $sformat(s, "%s  AHB AGENT CONFIG                               \n", s);
  $sformat(s, "%s-------------------------------------------------\n", s);
  $sformat(s, "%s  active                  = %s\n", s, active.name());
  $sformat(s, "%s  has_functional_coverage = %b\n", s, has_functional_coverage);
  $sformat(s, "%s  has scoreboard          = %b\n", s, has_scoreboard);
  if (print_address) begin
    foreach (start_address[i]) begin
      $sformat(s, "%s  start_address[%2d]    = %32h (%32h)\n",
        s, i, start_address[i], range[i]);
    end
  end
  return s;

endfunction

