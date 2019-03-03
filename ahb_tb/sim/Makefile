timescale=1ns/1ns

export UVM_HOME=/eda/uvm/uvm-1.1c
export AHB_AGENT=../../agents/ahb_agent
export APB_AGENT=../../agents/apb_agent

COM_OPTIONS=

SIM_OPTIONS="+UVM_TESTNAME=ahb_base_test"

CC=/usr/bin/gcc-4.4
CPP=/usr/bin/g++-4.4

all: comp run

comp:
	vcs -cc $(CC) -cpp $(CPP) \
		-sverilog -debug_all -timescale=$(timescale) \
		+vcs+vcdpluson \
		-CFLAGS -DVCS \
		+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
		-f file.f \
		-full64 \
		-l comp.log \
		$(COM_OPTIONS)

run:
	./simv -l run.log $(SIM_OPTIONS) 

run_gui:
	./simv -gui -l run.log $(SIM_OPTIONS) 

dve:
	dve -full64 -vpd vcdplus.vpd &

clean:
	@echo "Cleaning sim"
	@rm -rf DVEfiles inter.vpd vcdplus.vpd csrc simv simv.cst simv.daidir simv.vdb vcdplus.v ucli.key vc_hdrs.h *.log
