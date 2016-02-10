`timescale 1ns/10ps
`include "opcode.h"
`include "register.v"
`include "fix.v"
`include "byte.v"
`include "permute.v"
`include "ls.v"
`include "branch.v"
`include "SPU_DECODE.v"

`include "wb_even.v"
`include "wb_odd.v"
`include "fwd_even.v"
`include "fwd_odd.v"
// `include "forwardcheck.v"
`include "localstore.v"
`include "fetch.v"
`include "ilb.v"
`include "lut.v"

module top(/*inputs*/  clk,reset,instuction_address,inst_2_local,write);
          
input clk,reset;
input [0:6] instuction_address;
input [0:1023] inst_2_local;
input write;


// SPU Decode Inputs
wire [0:31] instruction1,instruction2;




//Execution Unit outputs
wire [0:127] fix_output, byte_output, ls_output, permute_output;
wire [0:6] branch_output; /*op_addr of branch module*/
wire [0:6] fix_addr_rt, byte_addr_rt, permute_addr_rt, load_addr_rt;
wire fix_out_availible, byte_out_availible, ls_out_availible, premute_out_availible, branch_taken, unit_reset;


//permenent declaration
wire [0:127] ra_data_even_1, rb_data_even_1, rc_data_even_1;
wire [0:127] ra_data_odd_1,rb_data_odd_1,rc_data_odd_1;

wire [0:6] addr_ra_even, addr_rb_even, addr_rc_even;
wire [0:6] addr_ra_odd, addr_rb_odd, addr_rc_odd;
wire [0:31] inst_out_even,inst_out_odd;
wire op_11_even_1, op_8_even_1;
wire op_11_odd_1, op_8_odd_1, op_9_odd_1, op_7_odd_1;
wire fix_sel, byte_sel;
wire permute_sel, branch_sel,  ls_sel;
wire branch_num;
wire [0:134] fwd_even_data,fw_chk_even_1,fw_chk_even_2,fw_chk_even_3,fw_chk_even_4,fw_chk_even_5;
wire [0:134] fwd_odd_data,fw_chk_odd_1,fw_chk_odd_2,fw_chk_odd_3,fw_chk_odd_4,fw_chk_odd_5;
wire [0:6] addr_odd,addr_even,addr_rt_even,addr_rt_odd,addr_lsops;
wire  wr_odd,wr_even,wr_en_data;
wire [0:127] data_odd, data_even,data_lsops,ip_mem_data;
wire [0:4] PC;
wire [0:1023] inst_set;
wire is_struct_hazard;
wire regstatus_1_a,regstatus_1_b,regstatus_2_a,regstatus_2_b, inst1_datanotfound,inst2_datanotfound;
reg  [0:1] is_raw_hazard;
wire [0:2] inst1_reg,inst2_reg;
wire inst1pipe,inst2pipe;
reg  universal_reset,fetch_reset;
wire start;
wire struct_hazard_0;
always @ (*)
begin
    if(reset) {is_raw_hazard,universal_reset,fetch_reset} = 0;
    else 
    begin
        //RAW HAZARD CHECK
        {is_raw_hazard,universal_reset,fetch_reset} = 0;
        if     (regstatus_1_a | regstatus_1_b/* | inst1_datanotfound*/)  is_raw_hazard = 2'b01;
        else if(regstatus_2_a | regstatus_2_b /*| inst2_datanotfound*/)  is_raw_hazard = 2'b10;
        else   {is_raw_hazard,universal_reset} = 0;
        
        
        //CONTROL HAZARD CHECK
        /*if(is_struct_hazard) universal_reset = 1'b1;
        else*/ if(branch_taken) begin universal_reset = 1'b1; fetch_reset = 1'b1; end 
        else begin universal_reset = 1'b0; fetch_reset = 1'b0; end 
    end
    
    
end

fetch      inst_fetch(//INPUTS   
                        .clk(clk), 
                        .reset(reset),
                        .fetch_reset(fetch_reset),
                        .is_struct_hazard(is_struct_hazard), //Signal used to indicate structural hazard. comes from main module
                        .is_raw_hazard(is_raw_hazard),   //Signal used to indicate RAW data hazard. comes from main module
                        .active(start),
                      //OUTPUT   
                        .PC(PC),// goes to ILB instruction number
                        .struct_hazard_0(struct_hazard_0)
                        );  
                    

ilb         inst_ilb(//INPUTS   
                        .reset(reset),
                        .fetch_reset(fetch_reset),
                        .inst_number(PC), //comes from fetch module 
                        .inst_set(inst_set),// comes from local store unit
                        
                    //OUTPUTS  
			.instruction1(instruction1), 
			.instruction2(instruction2)); // to decode unit   

DECODE_SPU  inst_decode(//inputs 
                               .clk(clk),
                               .reset(reset),
                               .universal_reset(universal_reset),
                               .inst_in_1(instruction1),
                               .inst_in_2(instruction2),
                               
                  //outputs
                              .addr_ra_even(addr_ra_even), 
                              .addr_rb_even(addr_rb_even), 
                              .addr_rc_even(addr_rc_even), 
                              .addr_rt_even(addr_rt_even),                                      
                              .inst_out_even(inst_out_even), 
                              .fix_sel(fix_sel), 
                              .byte_sel(byte_sel),
	                      
	                      .addr_ra_odd(addr_ra_odd),  
	                      .addr_rb_odd(addr_rb_odd),  
	                      .addr_rc_odd(addr_rc_odd),  
	                      .addr_rt_odd(addr_rt_odd),
	                      .inst_out_odd(inst_out_odd),  
	                      .permute_sel(permute_sel), 
	                      .branch_sel(branch_sel), 
	                      .ls_sel(ls_sel),
	                      .branch_num(branch_num), 
	                      
	                      .op_11_even(op_11_even_1),
	                      .op_8_even(op_8_even_1),
	                      
	                      .op_11_odd(op_11_odd_1),
	                      .op_8_odd(op_8_odd_1), 
	                      .op_9_odd(op_9_odd_1),
	                      .op_7_odd(op_7_odd_1),
	                      .struct_hazard_0(struct_hazard_0),
	                      .is_struct_hazard(is_struct_hazard));          

fixedpoint_unit  inst_fix(//inputs
                        .clk(clk),
                        .reset(reset),
                        .unit_reset(unit_reset),
		
		      //inputs from even pipe out
    		        .inst_in_even(inst_out_even), 
    		        .op_11_even(op_11_even_1), 
    		        .op_8_even(op_8_even_1), 
    		        .fix_unit_sel(fix_sel),

		      //inputs from register file out (address datas)
			.ra_data_even(ra_data_even_1), 
			.rb_data_even(rb_data_even_1),
			
                      //output
                      .fix_output(fix_output), 
                                  .addr_rt_even(fix_addr_rt), 
                                  .fix_out_availible(fix_out_availible));
          
byte_unit      inst_byte(//INPUTS 
                                .clk(clk),
                                .reset(reset),
                                .unit_reset(unit_reset),
		   
		   //INPUTS from Register File
		   .ra_data_even(ra_data_even_1), 
		   .rb_data_even(rb_data_even_1),

                    //INPUTS from Decode Unit   
		   .op_11_even(op_11_even_1), 
		   .byte_unit_sel(byte_sel), 
		   .inst_even(inst_out_even),
		   
		   //OUTPUTS to EVEN output select pipe
		   .byte_output(byte_output), 
		   .byte_out_availible(byte_out_availible), 
		   .byte_addr_rt(byte_addr_rt));
		   
permute_unit    inst_permute(//INPUTS 
                            .clk(clk),
                            .reset(reset),
                            .unit_reset(unit_reset),

                    //INPUTS from Decode Unit   
                            .op_11_odd(op_11_odd_1), 
                            .permute_unit_sel(permute_sel), 
                            .inst_odd(inst_out_odd),

                            //INPUTS from Register File
                            .ra_data_odd(ra_data_odd_1), 
                            .rb_data_odd(rb_data_odd_1),
                            
                            //OUTPUTS to ODD output select pipe
                            .permute_output(permute_output), 
                            .premute_out_availible(premute_out_availible), 
                            .permute_addr_rt(permute_addr_rt));
       
loadstore_unit    inst_ls(//INPUTS 
                    .clk(clk),
                    .reset(reset),
                    .unit_reset(unit_reset),
						   
		   //INPUTS from Decode Unit
		   .op_11_odd(op_11_odd_1), 
		   .op_9_odd(op_9_odd_1), 
		   .op_8_odd(op_8_odd_1), 
		   .op_7_odd(op_7_odd_1), 
		   .ls_unit_sel(ls_sel), 
		   .inst_odd(inst_out_odd),

		   //INPUTS from Register File
		   .ra_data_odd(ra_data_odd_1), 
		   .rb_data_odd(rb_data_odd_1), 
		   .rc_data_odd(rc_data_odd_1),

		   //INPUT from Local Store Unit//
		   .ip_mem_data(ip_mem_data),                           
		   
		   //OUTPUTS to Local Store Unit//   
		   .addr_final(addr_lsops),                             
		   .select_op(wr_en_data),                              
		   .op_rt_data(data_lsops),                            

		   //OUTPUTS to ODD output select pipe
		   .ls_output(ls_output), 
		   .ls_out_availible(ls_out_availible), 
		   .addr_rt(load_addr_rt));
		   
branch_unit       inst_branch(//input from SPU_decode 	
                  .inst_in_odd(inst_out_odd), 
                  .branch_unit_sel(branch_sel), 
                  .op_9_odd(op_9_odd_1), 
                  .branch_number(branch_num),
                    
                  //input from register file
                  .ra_data_odd(ra_data_odd_1),
                        
                  //input from top level testbench
                  .addr_inst_ip(instuction_address), 
                        
                  //output
                  .branch_taken(branch_taken), //goes to mux for branch and in top module for hazard check
                  .unit_reset(unit_reset), //goes in to top module for other unit's reset connection.
                  .op_addr(branch_output),
                  .clk(clk),
                  .reset(reset)) ;
                  //goes to local store unit);
                        
                      
REGISTER          inst_reg( //input
                    .clk(clk),
                    .reset(reset),

		  //input from Write Back Even module out
		 .data_even(data_even), 
		 .wr_even(wr_even), 
		 .addr_even(addr_even),
		  
		  //input from Write Back Odd module out
		 .data_odd(data_odd),  
		 .wr_odd(wr_odd), 
		 .addr_odd(addr_odd),

		  //input from Pipe Even module out
		 .addr_ra_even(addr_ra_even),
		 .addr_rb_even(addr_rb_even),
		 .addr_rc_even(addr_rc_even),

		  //input from Pipe Even module out
		 .addr_ra_odd(addr_ra_odd),
		 .addr_rb_odd(addr_rb_odd),
		 .addr_rc_odd(addr_rc_odd),

		  //output for even data
		 .ra_data_even(ra_data_even_1), 
		 .rb_data_even(rb_data_even_1), 
		 .rc_data_even(rc_data_even_1),

		  //output for odd data
		 .ra_data_odd(ra_data_odd_1), 
		 .rb_data_odd(rb_data_odd_1), 
		 .rc_data_odd(rc_data_odd_1));

fwd_even        inst_fwdeven ( //INPUTS from FIX Unit
		.fix_output(fix_output), 
                .addr_rt_fix(fix_addr_rt), 
                .fix_out_availible(fix_out_availible),

		//INPUTS from BYTE Unit
		.byte_output(byte_output), 
                .addr_rt_byte(byte_addr_rt), 
                .byte_out_availible(byte_out_availible), 
                .clk(clk), 
                .reset(reset),
                  

                 //OUTPUTS  
                .fwd_even_data(fwd_even_data), 
                .fw_chk_even_1(fw_chk_even_1), 
                .fw_chk_even_2(fw_chk_even_2), 
                .fw_chk_even_3(fw_chk_even_3), 
                .fw_chk_even_4(fw_chk_even_4), 
                .fw_chk_even_5(fw_chk_even_5));
                
fwd_odd         inst_fwdodd( //INPUTS from LS Unit
		.ls_output(ls_output), 
                .addr_rt_ls(load_addr_rt), 
                .ls_out_availible(ls_out_availible),

		//INPUTS from PERMUTE Unit
		.permute_output(permute_output), 
                .addr_rt_permute(permute_addr_rt), 
                .permute_out_availible(premute_out_availible), 
                .clk(clk), 
                .reset(reset),

                //OUTPUTS  
                .fwd_odd_data(fwd_odd_data), 
                .fw_chk_odd_1(fw_chk_odd_1), 
                .fw_chk_odd_2(fw_chk_odd_2), 
                .fw_chk_odd_3(fw_chk_odd_3), 
                .fw_chk_odd_4(fw_chk_odd_4), 
                .fw_chk_odd_5(fw_chk_odd_5));


writeback_even         inst_wbeven( //INPUTS from Forwarding_Even Network   
                        .fwd_even_data(fwd_even_data), 
                        .reset(reset),
                        
                        //OUTPUTS to Register File 
                        .addr_even(addr_even), 
                        .wr_even(wr_even), 
                        .data_even(data_even));

writeback_odd          inst_wbodd( //INPUTS from Forwarding_Odd Network  
                        .fwd_odd_data(fwd_odd_data), 
                        .reset(reset),

                       //OUTPUTS to Register File 
                        .addr_odd(addr_odd), 
                        .wr_odd(wr_odd), 
                        .data_odd(data_odd));
                    
/*forwardcheck     inst_fwdcheck( //INPUTS
		     .inst1_rt(addr_rt_even), // comes from even_pipe module (SPU_decode)
		     .inst2_rt(addr_rt_odd), // comes from odd_pipe module (SPU_decode)
		     .fwreg_even_1(fw_chk_even_1),
		     .fwreg_even_2(fw_chk_even_2),
		     .fwreg_even_3(fw_chk_even_3),
		     .fwreg_even_4(fw_chk_even_4),
		     .fwreg_even_5(fw_chk_even_5), // comes from fwd_even.v outputs
		     .fwreg_odd_1(fw_chk_odd_1),
		     .fwreg_odd_2(fw_chk_odd_2),
		     .fwreg_odd_3(fw_chk_odd_3),
		     .fwreg_odd_4(fw_chk_odd_4),
		     .fwreg_odd_5(fw_chk_odd_5),// comes from fwd_odd.v outputs
		     
		     
		     //OUTPUTS
		     .inst1_datanotfound(inst1_datanotfound),                                               
		     .inst2_datanotfound(inst2_datanotfound), // used to check RAW hazards in top module     
	  	     .inst1pipe(inst1pipe),                                                      
	  	     .inst2pipe(inst2pipe), //goes in top module, just declare as wire             
	             .inst1_reg(inst1_reg),                                                        
	             .inst2_reg(inst2_reg)); //goes in top module, just declare as wire)        */    
	             
localstore         inst_localstore( //INPUTS
                    .clk(clk),
                    .reset(reset),

                    //INPUT comes from load_store unit (ls.v)(select_op port)
                    .wr_en_data(wr_en_data),

                    //INPUT comes from top level testbench
                    .wr_en_inst(write),                                           
                    .ip_inst_packet(inst_2_local),                
                    
                    //INPUT comes from load_store unit (ls.v)(addr_final port)
                    .addr_lsops(addr_lsops),
                    
                    //INPUT comes from branch unit (op_addr port)
                    .addr_inst(branch_output),
                    
                    //INPUT comes from load_store unit (ls.v)(op_rt_data port)
                    .data_lsops(data_lsops),
                    
                    //OUTPUT to ILB
                    .op_inst(inst_set),.start(start),

                    //OUTPUT to load_store unit (ls.v)(ip_mem_data port)
                    .op_lsops(ip_mem_data));

lut          inst_lut(//INPUTS
             .clk(clk), 
             .reset(reset), 
	     
	     .ra_even_addr(addr_ra_even), 
	     .rb_even_addr(addr_rb_even), // comes from even_pipe module (SPU_decode) 
	     
	     .ra_odd_addr(addr_ra_odd), 
	     .rb_odd_addr(addr_rb_odd), // comes from odd_pipe module (SPU_decode)
             
             .dest_1(addr_rt_even), // comes from even_pipe module rt address (SPU_decode) 
             .dest_2(addr_rt_odd), // comes from odd_pipe module rt address(SPU_decode) 
             
             .ogaddr_1(addr_even),//comes from writeback_even rt address output 
             .ogaddr_2(addr_odd),//comes from writeback_odd rt address output 
             
	     //OUTPUTS
	     .regstatus_1_a(regstatus_1_a),                                                                
	     .regstatus_1_b(regstatus_1_b),                                                                
	     .regstatus_2_a(regstatus_2_a),                                                                    
	     .regstatus_2_b(regstatus_2_b)); // all outputs are used to check RAW hazards in top module     
          
endmodule
