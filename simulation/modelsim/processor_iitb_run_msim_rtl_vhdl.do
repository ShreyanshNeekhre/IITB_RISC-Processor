transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/intelFPGA_lite/18.1/project files/processor_iitb/Instruction_Memory.vhd}
vcom -93 -work work {C:/intelFPGA_lite/18.1/project files/processor_iitb/essential_components.vhd}
vcom -93 -work work {C:/intelFPGA_lite/18.1/project files/processor_iitb/alu.vhd}
vcom -93 -work work {C:/intelFPGA_lite/18.1/project files/processor_iitb/register_file.vhd}
vcom -93 -work work {C:/intelFPGA_lite/18.1/project files/processor_iitb/pipeline_registers.vhd}
vcom -93 -work work {C:/intelFPGA_lite/18.1/project files/processor_iitb/data_memory.vhd}
vcom -93 -work work {C:/intelFPGA_lite/18.1/project files/processor_iitb/processor_iitb.vhd}
vcom -93 -work work {C:/intelFPGA_lite/18.1/project files/processor_iitb/Instruction_decoder.vhd}
vcom -93 -work work {C:/intelFPGA_lite/18.1/project files/processor_iitb/write_back.vhd}
vcom -93 -work work {C:/intelFPGA_lite/18.1/project files/processor_iitb/forwarding_RR_Ex.vhd}
vcom -93 -work work {C:/intelFPGA_lite/18.1/project files/processor_iitb/forwarding_RR_MM.vhd}
vcom -93 -work work {C:/intelFPGA_lite/18.1/project files/processor_iitb/forwarding_RR_WB.vhd}

vcom -93 -work work {C:/intelFPGA_lite/18.1/project files/processor_iitb/test.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  test

add wave *
view structure
view signals
run -all
