`timescale 1ns/10ps
`include "opcode.h"

module branch_unit (/*input from SPU_decode */	inst_in_odd, branch_unit_sel, op_9_odd, branch_number,
                    /*input from register file*/ ra_data_odd,
                    /*input from top level testbench*/ addr_inst_ip,
		    /*output*/  branch_taken, //goes to mux for branch and in top module for hazard check
                                unit_reset, //goes in to top module for other unit's reset connection.
                                op_addr,clk,reset /*goes to local store unit*/ );
input clk,reset;
input [0:31] inst_in_odd;
input branch_unit_sel, op_9_odd,branch_number;
input [0:127] ra_data_odd;
input [0:6] addr_inst_ip;
output reg branch_taken;
output reg unit_reset;
output reg [0:6] op_addr;
reg branch_taken_d;
reg new;
reg op_9_odd_d,branch_unit_sel_d,branch_number_d;
reg [0:31] PC_out;
reg [0:127] ra_data_odd_d;
reg  [0:31] inst_in_odd_d;
wire [0:31] PC,lslr;
wire [0:15] I16;

assign PC = 32'h01;
assign lslr = 32'h0003ffff;
assign I16 = inst_in_odd_d[9:24];

always  @ (posedge clk or posedge reset)
begin
    if(reset)
    begin
    op_9_odd_d <= 0;
    inst_in_odd_d <= 0;
    branch_unit_sel_d <= 0;
    branch_number_d <= 0;
    ra_data_odd_d <= 0; 
    branch_taken_d <= 0;
    end
    
    else begin
    
    if (branch_taken)
    begin
        branch_taken_d <= 0;
    end
    
    else begin
    branch_taken_d <= branch_taken;
    end
    
    
    
    
    branch_unit_sel_d <= branch_unit_sel;
    if (branch_unit_sel)
    begin
    op_9_odd_d <= op_9_odd;
    inst_in_odd_d <= inst_in_odd;
    branch_number_d <= branch_number;
    ra_data_odd_d <= ra_data_odd;
    end
    
    else begin
    op_9_odd_d <= 0;
    inst_in_odd_d <= 0;
    branch_number_d <= 0;
    ra_data_odd_d <= 0;
    end
    end

end


always @ (*)
begin
if (reset)
begin
op_addr = 0;
PC_out = 0;
branch_taken = 1'b0;
new = 0;
unit_reset = 0;
end




else begin
unit_reset = 0;
op_addr = 0;
PC_out = 0;
branch_taken = 1'b0;
new = 0;
	if(branch_unit_sel_d)
	begin
                if(op_9_odd_d)
                begin
		case(inst_in_odd_d[0:8])
		  `BRA: begin
			  PC_out = ({2'b00,{14{I16[0]}},I16}) && lslr;
			  branch_taken = 1'b1;
			  new =1;
			  
			end
		  `BRZ: begin
			  if(ra_data_odd_d[96:127] == 0) 
			    begin
				PC_out = ( PC + ({2'b00,{14{I16[0]}},I16}) )/* && lslr && 32'hfffffffc*/;
			        new =1;
			        branch_taken = 1'b1;
			        
			    end

			  else
			    begin
			    	PC_out = (PC + 4) && lslr;
				branch_taken = 1'b0;
				
			    end
			end

		  `BRNZ: begin
			  if(ra_data_odd_d[96:127] != 0) 
			    begin
				PC_out = ( PC + ({2'b00,{14{I16[0]}},I16}) )/* && lslr && 32'hfffffffc*/;
			        branch_taken = 1'b1;
			        new =1;
			    end

			  else
			    begin
			    	PC_out = (PC + 4) && lslr;
				branch_taken = 1'b0;
			    end
			end
	        endcase
	        end
	        
	        else {branch_taken,PC_out} = 0;
	end

	else
	begin
	  branch_taken = 0;
	  PC_out = 0;

	end  
	
	if((branch_number_d==0) && (branch_taken==1'b1))
	begin
            unit_reset = 1'b1;
	end
	
	else unit_reset = 1'b0;
	
	case(branch_taken)
	1'b1: begin op_addr = PC_out [25:31];/* branch_taken = 0; */end
	1'b0: if (!new) op_addr = addr_inst_ip; // comes from top level testbench code
	default:op_addr = addr_inst_ip;
	endcase
end	
end
endmodule