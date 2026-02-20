set origin_dir "../SRC"
set proc_path "./procedures"
#User does not allow to change Block design directory
set BlockDesigndir "../SRC/common/BD"
set FPGA_part "xc7a200tsbv484-1"
set Board_part ""
set project_name "vivado"
set useBoard 0
set topmodule "UUT"
set gen_dir "../"
set top_sim_name "UUT_TB"
set target_language "VHDL"

#include all header files 
source ./procedures/buildProcedures.tcl

# creating project 
[gen_project $project_name $FPGA_part $useBoard $Board_part $gen_dir]
set_property target_language $target_language [current_project]


# read all dirs in dictionary 
set directories [glob -nocomplain -directory $origin_dir *]
set mainDirs {}
foreach dir $directories {
    set fileList [getFiles $dir]
    dict set mainDirs $dir $fileList
}

# adding hdl source files 
foreach dir $directories {
	set fileList [dict get $mainDirs $dir] 
	foreach newdir_src $fileList {
		if { ![ string match $origin_dir/TB $dir ] } {
			if {[string match $dir/HDL $newdir_src]} {
				set allvhdlfiles [glob -nocomplain -directory $newdir_src *.vhd]
				set allverilogfils [glob -nocomplain -directory $newdir_src *.v]
				if { [llength $allvhdlfiles] != 0 } {
					set evaluated_path [subst -nocommands -nobackslashes $allvhdlfiles]
					add_files -fileset sources_1 $evaluated_path
				}
				if { [llength $allverilogfils] != 0 } {
					set evaluated_path [subst -nocommands -nobackslashes $allverilogfils]
					add_files -fileset sources_1 $evaluated_path
				}
			} 
		}
	}
} 
[set_top_module $topmodule]


# adding hdl simulation files 
foreach dir $directories {
	set fileList [dict get $mainDirs $dir] 
	foreach newdir_src $fileList {
		if { [ string match $origin_dir/TB $dir ] } {
			if {[string match $dir/HDL $newdir_src]} {
				set allvhdlfiles [glob -nocomplain -directory $newdir_src *.vhd]
				if { [llength $allvhdlfiles] != 0 } {
					set evaluated_path [subst -nocommands -nobackslashes $allvhdlfiles]
					add_files -fileset sim_1 $evaluated_path
				}
			} 
		}
	}
}
[set_top_sim $top_sim_name]

# adding coe cores to the project
foreach dir $directories {
	set fileList [dict get $mainDirs $dir]
	foreach newdir $fileList {
		if {[string match $dir/COE $newdir]} {
			set allcoefiles [glob -nocomplain -directory $newdir *.coe]
			if { [llength $allcoefiles] != 0 } {
				set evaluated_path [subst -nocommands -nobackslashes $allcoefiles]
				add_files -fileset sources_1 $evaluated_path
			}
		} 
	}
}

# adding XDC files to the project
foreach dir $directories {
	set fileList [dict get $mainDirs $dir]
	foreach newdir $fileList {
		if {[string match $dir/XDC $newdir]} {
			set allxdclfiles [glob -nocomplain -directory $newdir *.xdc]
			if { [llength $allxdclfiles] != 0 } {
				set evaluated_path [subst -nocommands -nobackslashes $allxdclfiles]
				add_files -fileset constrs_1 $evaluated_path
			}
		} 
	}
}

source ./procedures/ipGenerator.tcl
set_property SOURCE_SET sources_1 [get_filesets sim_1]

add_files -fileset sim_1 -norecurse ../SRC/TB/TestFiles/data_imag.txt
add_files -fileset sim_1 -norecurse ../SRC/TB/TestFiles/data_real.txt




