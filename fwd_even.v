
`timescale 1ns/10ps
module fwd_even(/*OUTPUTS*/  fwd_even_data, fw_chk_even_1, fw_chk_even_2, fw_chk_even_3, fw_chk_even_4, fw_chk_even_5, 
                
                /*INPUTS from FIX Unit*/
		fix_output, addr_rt_fix, fix_out_availible,

		/*INPUTS from BYTE Unit*/
		byte_output, addr_rt_byte, byte_out_availible, clk, reset);
                
input clk,reset;
input [0:127] fix_output, byte_output;
input fix_out_availible, byte_out_availible;
input [0:6] addr_rt_fix, addr_rt_byte;

reg [0:127] even_pipe_data;
reg [0:6] even_pipe_addr;

output reg [0:134] fwd_even_data;
output reg [0:134] fw_chk_even_1, fw_chk_even_2, fw_chk_even_3, fw_chk_even_4, fw_chk_even_5;
wire [0:134] fullvalue;

assign fullvalue={even_pipe_addr,even_pipe_data};

always @(*) 
begin
	casez({fix_out_availible, byte_out_availible})
	2'b1?: begin
	even_pipe_data = fix_output;
	even_pipe_addr = addr_rt_fix;
	end

	2'b01: begin
	even_pipe_data = byte_output;
	even_pipe_addr = addr_rt_byte;
	end

	default: begin
	even_pipe_data = 0;
	even_pipe_addr = 0;
	end
	endcase
end
always @ (posedge clk or posedge reset) 
begin
if(reset)
    begin
    {fw_chk_even_1, fw_chk_even_2, fw_chk_even_3, fw_chk_even_4, fw_chk_even_5} <= 0;
    fwd_even_data <= 0;
    end
else
    begin    
    fw_chk_even_1  <= fullvalue;
    fw_chk_even_2  <= fw_chk_even_1;
    fw_chk_even_3  <= fw_chk_even_2;
    fw_chk_even_4  <= fw_chk_even_3;
    fw_chk_even_5  <= fw_chk_even_4;
    fwd_even_data  <= fw_chk_even_4;
    end
end    
endmodule

