# ----------------------------------------------------------------------------------
# Requirements:
#	QuestaSim - We use vcom and vsim.
#	Each test bench must contain an instantiation called dut.
#	Each test bench must call std.env.stop when it's finished testing.
# ----------------------------------------------------------------------------------

# set the default target to be all. Otherwise it's the first target it finds
.DEFAULT_GOAL := all

# some variables to use later
VLIB_DIR 	= ./sim/work
VLIB_NAME	= work
VCOM_FLAGS 	= -work $(VLIB_NAME)

# VSIM args to log waves
# Use DEBUG=1 to log all waves
# otherwise it just logs the waves in the top level module
ifeq ($(DEBUG),1)
ADD_DEBUG_WAVES				=	add wave -r /*
else
ADD_DEBUG_WAVES				=	add wave dut/*
endif

# commands to run once vsim starts
VSIM_DO_CMDS				=	log -r /*; $(ADD_DEBUG_WAVES); \
								run 1000000000; \
								quit -f

# flags to pass to VSIM_CMD
VSIM_FLAGS					=	-sv_seed random \
								-novopt \
								$(EXTRA_VSIM_FLAGS) \
								-do "$(VSIM_DO_CMDS)"


# the run the test command.
#	Takes one arguments:
#		1) Top level module name
VSIM_CMD = $(call COLOURIZE, vsim $(VSIM_FLAGS) $(1))


# pull in some macros
# this has: colour codes for outputting messages in colour
#			a macro to turn the source path into the object path
#			a macro to create a target based on a source file name
include ../../herramientas/helper.mk

# src files directory
SRCS				= $(wildcard src/*.vhd) \
					  $(wildcard src/*.vhdl)

# default rule is to create the library, and compile all the components
all: $(VLIB_DIR) srcs

# create the questaSim library if it's not already there
$(VLIB_DIR):
	vlib $(VLIB_DIR)
	vmap $(VLIB_NAME) $(VLIB_DIR)
	@echo -e "$(COLOUR_GREEN)Created the $(VLIB_DIR) library mapped to $(VLIB_NAME)$(COLOUR_NONE)\n"

# create targets for all our sources
# this loops through all of our source files in the $(SRCS) var
# and foreach one evaluates as makefile rules the results of calling
# the create_target_for macro on the source file.
# this macro is in the helper.mk file
# note with this method we can't set dependencies within a single directory
$(foreach src,$(SRCS),$(eval $(call create_target_for, $(src))))

# define a phony target per directory so we can specify compile order
srcs: $(VLIB_DIR) $(call src2obj, $(SRCS))
	@echo -e "$(COLOUR_GREEN)Compiled all sources.$(COLOUR_NONE)\n"

fullAdder: srcs
	@echo -e "$(COLOUR_GREEN)Running simulation.$(COLOUR_NONE)\n"
	@$(call VSIM_CMD, fullAdder_tb)

rippleAdder: srcs
	@echo -e "$(COLOUR_GREEN)Running simulation.$(COLOUR_NONE)\n"
	@$(call VSIM_CMD, rippleAdder_tb)

twosComplement: srcs
	@echo -e "$(COLOUR_GREEN)Running simulation.$(COLOUR_NONE)\n"
	@$(call VSIM_CMD, twosComplement_tb)

sumaResta: srcs
	@echo -e "$(COLOUR_GREEN)Running simulation.$(COLOUR_NONE)\n"
	@$(call VSIM_CMD, sumaResta_tb)

flipFlop1_srst: srcs
	@echo -e "$(COLOUR_GREEN)Running simulation.$(COLOUR_NONE)\n"
	@$(call VSIM_CMD, flipFlop1_srst_tb)

flipFlopN_srst: srcs
	@echo -e "$(COLOUR_GREEN)Running simulation.$(COLOUR_NONE)\n"
	@$(call VSIM_CMD, flipFlopN_srst_tb)

contador2: srcs
	@echo -e "$(COLOUR_GREEN)Running simulation.$(COLOUR_NONE)\n"
	@$(call VSIM_CMD, contador2_tb)

contador4: srcs
	@echo -e "$(COLOUR_GREEN)Running simulation.$(COLOUR_NONE)\n"
	@$(call VSIM_CMD, contador4_tb)

contadorN: srcs
	@echo -e "$(COLOUR_GREEN)Running simulation.$(COLOUR_NONE)\n"
	@$(call VSIM_CMD, contadorN_tb)

contaCerosN: srcs
	@echo -e "$(COLOUR_GREEN)Running simulation.$(COLOUR_NONE)\n"
	@$(call VSIM_CMD, contaCerosN_tb)

view_saved_waves:
	@questasim -do "vsim -view vsim.wlf; $(ADD_DEBUG_WAVES)"

# delete the library and all compiled files
clean:
	if [ -d $(VLIB_DIR) ]; then vdel -lib $(VLIB_DIR) -all; fi;
	if [ -e modelsim.in ]; then rm modelsim.ini; fi;

.PHONY: clean all srcs fullAdder1 view_saved_waves
