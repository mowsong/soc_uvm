//
// Class Description:
//
//
class ahb_pipelined_seq extends uvm_sequence #(ahb_seq_item);

// UVM Factory Registration Macro
//
`uvm_object_utils(ahb_pipelined_seq)

//------------------------------------------
// Data Members (Outputs rand, inputs non-rand)
//------------------------------------------

//------------------------------------------
// Constraints 
//------------------------------------------


//------------------------------------------
// Methods 
//------------------------------------------

extern function new(string name = "ahb_pipelined_seq");
extern task body;

endclass: ahb_pipelined_seq

function ahb_pipelined_seq::new(string name = "ahb_pipelined_seq");
  super.new();
endfunction

task ahb_pipelined_seq::body;
  ahb_seq_item req;
  ahb_seq_item rsp;

  begin
    req = ahb_seq_item::type_id::create("req");
    start_item(req);
    if(!req.randomize() with {delay == 0;}) begin
      `uvm_error("body", "req randomization failure")
    end
    finish_item(req);
    
    get_response(req);
    `uvm_info("body", rsp.convert2string(), UVM_MEDIUM)
  end

endtask: body


