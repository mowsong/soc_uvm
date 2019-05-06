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

semaphore address_phase_lock = new(1);

//------------------------------------------
// Methods
//------------------------------------------
extern function int sel_lookup(logic[31:0] address);
// Standard UVM Methods:
extern function new(string name = "ahb_driver", uvm_component parent = null);
extern task run_phase(uvm_phase phase);
extern function void build_phase(uvm_phase phase);

extern task do_pipelined_transfer_get(input int id);
extern task do_pipelined_transfer_try(input int id);

endclass: ahb_driver

function ahb_driver::new(string name = "ahb_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction

task ahb_driver::run_phase(uvm_phase phase);
 
  AHB.HADDR  = 32'h0;
  AHB.HWRITE = 1'h0;
  AHB.HWDATA = 32'h0;
  AHB.HTRANS = 2'h0;

  // Wait for reset to clear
  @(posedge AHB.HRESETn);
  @(posedge AHB.HCLK);

  fork

    do_pipelined_transfer_get(0);
    do_pipelined_transfer_get(1);
    
    //do_pipelined_transfer_try(0);
    //do_pipelined_transfer_try(1);

  join
  
endtask: run_phase

task automatic ahb_driver::do_pipelined_transfer_get(input int id);
  ahb_seq_item req;
  ahb_seq_item rsp;
  int delay;

  `uvm_info(this.get_name(), "using do_pipelined_transfer_get()", UVM_HIGH)

  forever begin

    // lock address phase bus access
    address_phase_lock.get();
  
    // retrieve sequence item from seqeunce (via sequencer)
    seq_item_port.get(req);  

    // delay the bus cycle
    delay = req.delay;
    `uvm_info(this.get_name(), $sformatf("Delay for %0d cycle", delay), UVM_MEDIUM)
    repeat (delay) @(posedge AHB.HCLK);

    `uvm_info(this.get_name(), $sformatf("Address phase starts (%0d)",id), UVM_MEDIUM)
    AHB.HADDR = req.addr;
    AHB.HTRANS = req.trans;
    AHB.HWRITE = req.we;

    @(posedge AHB.HCLK);
    while (!AHB.HREADY == 1) @(posedge AHB.HCLK);

    // stop driving the address phase signals before releasing the bus
    AHB.HADDR = 32'h0;
    AHB.HTRANS = IDLE;
    AHB.HWRITE = 1'b1;

    // release address phase bus access
    address_phase_lock.put();
 
    `uvm_info(this.get_name(), $sformatf("Data phase starts (%0d)", id), UVM_MEDIUM)
    AHB.HWDATA = req.data;
  
    @(posedge AHB.HCLK);
    while (!AHB.HREADY == 1) @(posedge AHB.HCLK);
    
    // stop driving the data phase signals before releasing the bus
    AHB.HWDATA = 32'h0;

    // sent response item to sequence (via sequencer)
    $cast(rsp, req.clone());
    rsp.set_id_info(req);
    seq_item_port.put(rsp);
  
  end

endtask: do_pipelined_transfer_get

task automatic ahb_driver::do_pipelined_transfer_try(input int id);
  ahb_seq_item req;
  ahb_seq_item rsp;
  int delay;
  
  `uvm_info(this.get_name(), "using do_pipelined_transfer_try()", UVM_HIGH)

  forever begin

    // lock address phase bus access
    address_phase_lock.get();
  
    // retrieve sequence item from seqeunce (via sequencer)
    seq_item_port.try_next_item(req);  
  
    if (req != null) begin

      seq_item_port.item_done(); // unblock sequence's finsih_item()

      // delay the bus cycle
      delay = req.delay;
      `uvm_info(this.get_name(), $sformatf("Delay for %0d cycle", delay), UVM_MEDIUM)
      repeat (delay) @(posedge AHB.HCLK);

      `uvm_info(this.get_name(), $sformatf("Address phase starts (%0d)",id), UVM_MEDIUM)
      AHB.HADDR = req.addr;
      AHB.HTRANS = req.trans;
      AHB.HWRITE = req.we;

      @(posedge AHB.HCLK);
      while (!AHB.HREADY == 1) @(posedge AHB.HCLK);

      // release address phase bus access
      address_phase_lock.put();
   
      `uvm_info(this.get_name(), $sformatf("Data phase starts (%0d)", id), UVM_MEDIUM)
      AHB.HWDATA = req.data;
    
      @(posedge AHB.HCLK);
      while (!AHB.HREADY == 1) @(posedge AHB.HCLK);
      
      // sent response item to sequence (via sequencer)
      $cast(rsp, req.clone());
      rsp.set_id_info(req);
      seq_item_port.put(rsp);
  
    end
    else begin
      // drive IDLE state signals in address phase
      AHB.HADDR = 32'h0;
      AHB.HTRANS = IDLE;
      AHB.HWRITE = 1'b1;

      @(posedge AHB.HCLK);
      while (!AHB.HREADY == 1) @(posedge AHB.HCLK);

      address_phase_lock.put();

      // drive IDLE state signals in data phase
      AHB.HWDATA = 32'h0;

      @(posedge AHB.HCLK);
      while (!AHB.HREADY == 1) @(posedge AHB.HCLK);

      // no response for IDLE cycle
    end

  end

endtask: do_pipelined_transfer_try


function void ahb_driver::build_phase(uvm_phase phase);
  if(!uvm_config_db #(ahb_agent_config)::get(this, "", "ahb_agent_config", m_cfg)) begin
    `uvm_error("build_phase", "Unable to get ahb_agent_config")
  end
endfunction: build_phase

// Looks up the address and returns HSEL line that should be activated
// If the address is invalid, a non positive integer is returned to indicate an error
function int ahb_driver::sel_lookup(logic[31:0] address);
  for(int i = 0; i < m_cfg.no_select_lines; i++) begin
    if((address >= m_cfg.start_address[i]) && (address <= (m_cfg.start_address[i] + m_cfg.range[i]))) begin
      return i;
    end
  end
  return -1; // Error: Address not found
endfunction: sel_lookup
