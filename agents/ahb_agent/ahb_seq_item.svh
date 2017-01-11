//
// Class Description:
//
//
class ahb_seq_item extends uvm_sequence_item;

// UVM Factory Registration Macro
//
`uvm_object_utils(ahb_seq_item)

//------------------------------------------
// Data Members (Outputs rand, inputs non-rand)
//------------------------------------------
rand logic[31:0] addr;
rand logic[31:0] data;
rand logic we;
rand ahb_trans_e trans;
rand ahb_resp_e resp;

rand int delay;
bit error = 0;

//------------------------------------------
// Constraints
//------------------------------------------

constraint delay_bounds {
  delay inside {[1:20]};
}

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "ahb_seq_item");
extern function void do_copy(uvm_object rhs);
extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
extern function string convert2string();
extern function void do_print(uvm_printer printer);
extern function void do_record(uvm_recorder recorder);

endclass:ahb_seq_item

function ahb_seq_item::new(string name = "ahb_seq_item");
  super.new(name);
endfunction

function void ahb_seq_item::do_copy(uvm_object rhs);
  ahb_seq_item rhs_;

  if(!$cast(rhs_, rhs)) begin
    `uvm_fatal("do_copy", "cast of rhs object failed")
  end
  super.do_copy(rhs);
  // Copy over data members:
  addr = rhs_.addr;
  data = rhs_.data;
  we = rhs_.we;
  trans = rhs_.trans;
  resp = rhs_.resp;
  delay = rhs_.delay;

endfunction:do_copy

function bit ahb_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  ahb_seq_item rhs_;

  if(!$cast(rhs_, rhs)) begin
    `uvm_error("do_copy", "cast of rhs object failed")
    return 0;
  end
  return super.do_compare(rhs, comparer) &&
         addr  == rhs_.addr &&
         data  == rhs_.data &&
         we    == rhs_.data &&
         trans == rhs_.trans &&
         resp  == rhs_.resp;
  // Delay is not relevant to the comparison
endfunction:do_compare

function string ahb_seq_item::convert2string();
  string s;

  $sformat(s, "%s\n", super.convert2string());
  // Convert to string function reusing s:
  $sformat(s, "%s\n addr\t%0h\n data\t%0h\n we\t%0b\n trans\t%0h\n resp\t%0h\n delay\t%0d\n", s, addr, data, we, trans, resp, delay);
  return s;

endfunction:convert2string

function void ahb_seq_item::do_print(uvm_printer printer);
  if(printer.knobs.sprint == 0) begin
    $display(convert2string());
  end
  else begin
    printer.m_string = convert2string();
  end
endfunction:do_print

function void ahb_seq_item:: do_record(uvm_recorder recorder);
  super.do_record(recorder);

  // Use the record macros to record the item fields:
  `uvm_record_field("addr", addr)
  `uvm_record_field("data", data)
  `uvm_record_field("we", we)
  `uvm_record_field("trans", trans)
  `uvm_record_field("resp", resp)
  `uvm_record_field("delay", delay)
endfunction:do_record
