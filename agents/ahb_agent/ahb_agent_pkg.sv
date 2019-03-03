package ahb_agent_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum {IDLE, BUSY, SEQ, NONSEQ} ahb_trans_e;
typedef enum {OKAY, ERROR} ahb_resp_e;


`include "ahb_seq_item.svh"
typedef uvm_sequencer #(ahb_seq_item) ahb_sequencer;
`include "ahb_agent_config.svh"
`include "ahb_driver.svh"
`include "ahb_coverage_monitor.svh"
`include "ahb_monitor.svh"
`include "ahb_agent.svh"

// Utility Sequences
`include "ahb_pipelined_seq.svh"
`include "ahb_unpipelined_seq.svh"

endpackage: ahb_agent_pkg

