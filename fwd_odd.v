
`timescale 1ns/10ps
module fwd_odd(/*OUTPUTS*/  fwd_odd_data, fw_chk_odd_1, fw_chk_odd_2, fw_chk_odd_3, fw_chk_odd_4, fw_chk_odd_5, 
                
                /*INPUTS from LS Unit*/
		ls_output, addr_rt_ls, ls_out_availible,

		/*INPUTS from PERMUTE Unit*/
		permute_output, addr_rt_permute, permute_out_availible, clk, reset);
                
input clk,reset;
input [0:127] ls_output, permute_output;
input ls_out_availible, permute_out_availible;
input [0:6] addr_rt_ls, addr_rt_permute;

reg [0:127] odd_pipe_data;
reg [0:6] odd_pipe_addr;

output reg [0:134] fwd_odd_data;
output reg [0:134] fw_chk_odd_1, fw_chk_odd_2, fw_chk_odd_3, fw_chk_odd_4, fw_chk_odd_5;
wire [0:134] fullvalue;

assign fullvalue={odd_pipe_addr,odd_pipe_data};

always @(*) 
begin
	casez({ls_out_availible, permute_out_availible})
	2'b1?: begin
	odd_pipe_data = ls_output;
	odd_pipe_addr = addr_rt_ls;
	end

	2'b01: begin
	odd_pipe_data = permute_output;
	odd_pipe_addr = addr_rt_permute;
	end

	default: begin
	odd_pipe_data = 0;
	odd_pipe_addr = 0;
	end
	endcase
end
always @ (posedge clk or posedge reset) 
begin
if(reset)
    begin
    {fw_chk_odd_1, fw_chk_odd_2, fw_chk_odd_3, fw_chk_odd_4, fw_chk_odd_5} <= 0;
    fwd_odd_data <= 0;
    end
else
    begin    
    fw_chk_odd_1  <= fullvalue;
    fw_chk_odd_2  <= fw_chk_odd_1;
    fw_chk_odd_3  <= fw_chk_odd_2;
    fw_chk_odd_4  <= fw_chk_odd_3;
    fw_chk_odd_5  <= fw_chk_odd_4;
    fwd_odd_data  <= fw_chk_odd_4;
    end
end    
endmodule

