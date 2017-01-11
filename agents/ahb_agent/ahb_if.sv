//--------------------------------------------------------------------
// AHB-lite bus interface
//-------------------------------------------------------------------- 

interface ahb_if (input HCLK, input HRESETn);

logic [1:0]   HTRANS;
logic [2:0]   HBURST;
logic [3:0]   HPROT;
logic [2:0]   HSIZE;
logic [31:0]  HADDR;
logic [31:0]  HWDATA;
logic [31:0]  HRDATA;
logic         HWRITE;
logic         HREADY;
logic         HRESP;

logic         HMASTLOCK;

logic [15:0]  HSEL;

endinterface
