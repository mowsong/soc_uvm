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
int count;

//------------------------------------------
// Constraints
//------------------------------------------



//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "ahb_pipelined_seq");
extern task body;
extern function void response_handler(uvm_sequence_item response);

endclass:ahb_pipelined_seq

function ahb_pipelined_seq::new(string name = "ahb_pipelined_seq");
  super.new(name);
endfunction

task ahb_pipelined_seq::body;
  ahb_seq_item req;
  ahb_seq_item rsp;
  count = 0;
  use_response_handler(1);

  req = ahb_seq_item::type_id::create("req");
  for (int i=0; i<10; i++) begin
    start_item(req);
    if(!req.randomize() with {addr == i; data == i; delay == 0;}) begin
      `uvm_error("body", "req randomization failure")
    end
    finish_item(req);
  end
  
  wait(count == 10);
  `uvm_info("body", "Complete", UVM_MEDIUM)

endtask:body

function void ahb_pipelined_seq::response_handler(uvm_sequence_item response);
    count++;
    `uvm_info("response handler", response.convert2string(), UVM_MEDIUM)
endfunction

