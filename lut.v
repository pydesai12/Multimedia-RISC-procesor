//LUT for dealing with RAW data hazards.
//A status 0 indicates its OK to issue any dependent instruction, status 1 indicates that the instruction can't be issued yet.

`timescale 1ns/10ps

module lut(  /*INPUTS*/clk, reset, 
	     ra_even_addr, rb_even_addr, // comes from even_pipe module (SPU_decode) 
	     ra_odd_addr, rb_odd_addr, // comes from odd_pipe module (SPU_decode)
             dest_1, // comes from even_pipe module rt address (SPU_decode) 
             dest_2, // comes from odd_pipe module rt address(SPU_decode) 
             ogaddr_1,//comes from writeback_even rt address output 
             ogaddr_2,//comes from writeback_odd rt address output 
             
	     /*OUTPUTS*/
	     regstatus_1_a, regstatus_1_b, regstatus_2_a,regstatus_2_b); // all outputs are used to check RAW hazards in top module
	     
input clk, reset;
input [0:6] ra_even_addr, rb_even_addr, ra_odd_addr, rb_odd_addr; //Addresses of the read registers to be checked for hazard
input [0:6] dest_1, dest_2; //Addresses for destination registers for both even and odd pipes
input [0:6] ogaddr_1, ogaddr_2; //Addresses that tell what was the original

output regstatus_1_a, regstatus_1_b, regstatus_2_a, regstatus_2_b;

//Declare the actual LUT here
reg [0:127] reglut,reglut_d;


assign regstatus_1_a = reset?0: ((ra_even_addr==0)?0:reglut[ra_even_addr]);
assign regstatus_2_a = reset?0:((ra_odd_addr==0)?0:reglut[ra_odd_addr]);
assign regstatus_1_b = reset?0:((rb_even_addr==0)?0:reglut[rb_even_addr]);
assign regstatus_2_b = reset?0:((ra_odd_addr==0)?0:reglut[rb_odd_addr]);

always @ (*) 
begin
  reglut[ogaddr_1] = 1'b0;
  reglut[ogaddr_2] = 1'b0;
  reglut = reglut_d;
end

always @ (posedge clk or posedge reset) 
begin
  if (reset) begin
  reglut_d <= 128'd0;
  end

  else 
  begin
  
  
    if((dest_1 | dest_2)==0) 
    begin
 	reglut_d[dest_1] <= 1'b0;
	reglut_d[dest_2] <= 1'b0;
    end

    else 
    begin
	reglut_d[dest_1] <= 1'b1;
	reglut_d[dest_2] <= 1'b1;
// 	$display ("reglut's %d and %d bit is set to 1  ", dest_1,dest_2);
    end
  end
end

endmodule 