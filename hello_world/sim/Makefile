timescale=1ns/1ns

COM_OPTIONS=

SIM_OPTIONS='+UVM_TESTNAME=hello_world'

CC=/usr/bin/gcc-4.4
CPP=/usr/bin/g++-4.4

all: comp run

comp:
	vcs -cc $(CC) -cpp $(CPP) \
		-sverilog -debug_all -timescale=$(timescale) \
		+vcs+vcdpluson \
        -ntb_opts uvm-1.1 \
		-CFLAGS -DVCS \
		+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
		-f file.f \
		-full64 \
		-l comp.log \
		$(COM_OPTIONS)

run:
	./simv -l run.log $(SIM_OPTIONS) 

run_gui:
	./simv -gui -l run.log ${SIM_OPTIONS} 

dve:
	dve -full64 -vpd vcdplus.vpd &

clean:
	@echo "Cleaning sim"
	@rm -rf DVEfiles inter.vpd vcdplus.vpd csrc simv simv.cst simv.daidir simv.vdb vcdplus.v ucli.key vc_hdrs.h *.log
