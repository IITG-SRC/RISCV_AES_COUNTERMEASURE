
 #############################################################
 ##                 Synopsys Primetime                       		               ##
 #############################################################

 #############################################################
 ##                 Set the power analysis mode                                                  ##
 #############################################################

set power_enable_analysis TRUE
set power_analysis_mode time_based

 #############################################################
 ##                 Link design		                                                  ##
 #############################################################

set target_library "/home/src/UMC65/UMK65LSCLLMVBBR_B03_TAPEOUTKIT/synopsys/uk65lscllmvbbr_108c125_wc.db"
set link_library "$target_library *"
read_db $target_library
#change cpu_aes to the new file name when required
read_verilog cpu_aes.dc.v   
current_design cpu_aes    
link

 #############################################################
 ##                 Set transition time/ annotate parasitics                                    ##
 #############################################################


 #############################################################
 ##                 Read swtiching activity file                                                      ##
 #############################################################

#change cpu_aes to the new file name when required
read_sdc  cpu_aes.sdc           
#read_vcd aes_12clk.vcd-strip_path testbench_12aes/aes1
read_vcd top.vcd -strip_path tb_main/cpuaes_inst

 #############################################################
 ##                 Analyze power		                                                  ##
 #############################################################

set_power_analysis_options -waveform_format fsdb -waveform_output riscv_42delay_cc_mul.fsdb
update_power


