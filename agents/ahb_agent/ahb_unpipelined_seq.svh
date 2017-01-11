//
// Class Description:
//
//
class ahb_unpipelined_seq extends uvm_sequence #(ahb_seq_item);

// UVM Factory Registration Macro
//
`uvm_object_utils(ahb_unpipelined_seq)

//------------------------------------------
// Data Members (Outputs rand, inputs non-rand)
//------------------------------------------

//------------------------------------------
// Constraints
//------------------------------------------



//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "ahb_unpipelined_seq");
extern task body;

endclass:ahb_unpipelined_seq

function ahb_unpipelined_seq::new(string name = "ahb_unpipelined_seq");
  super.new(name);
  `uvm_info("new", "done", UVM_MEDIUM)
endfunction

task ahb_unpipelined_seq::body;
  ahb_seq_item req;
  ahb_seq_item rsp;

  begin
    req = ahb_seq_item::type_id::create("req");
    start_item(req);
    if(!req.randomize()) begin
      `uvm_error("body", "req randomization failure")
    end
    finish_item(req);
    
    if (req.trans != IDLE) begin
      req = ahb_seq_item::type_id::create("req");
      start_item(req);
      if(!req.randomize()) begin
        `uvm_error("body", "req randomization failure")
      end
      req.trans = IDLE;
      req.addr = 32'h0;
      req.data = 32'h0;

      finish_item(req);
    
      get_response(rsp);
    end
  end

endtask:body

