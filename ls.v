//256kB LS is single port RAM, implemented here as pseudo DPRAM.
//First priority is DMA(128-bytes), then load-store ops(128-bits), and finally
//instructions(fetched in 128 bytes and then passed on to ILB). DMA is not
//implemented here.

`timescale 1ns/10ps
`include "opcode.h"
module loadstore_unit (/*OUTPUTS to Local Store Unit*/   addr_final, select_op, op_rt_data,

		   /*OUTPUTS to ODD output select pipe*/
		   ls_output, ls_out_availible, addr_rt,
		   
		   /*INPUTS*/ clk,reset,unit_reset,
						   
		   /*INPUTS from Decode Unit*/    
		   op_11_odd, op_9_odd, op_8_odd, op_7_odd, ls_unit_sel, inst_odd,

		   /*INPUTS from Register File*/
		   ra_data_odd, rb_data_odd, rc_data_odd,

		   /*INPUT from Local Store Unit*/
		   ip_mem_data);

input clk,reset,unit_reset;

//--------------INPUTS from Decode Unit
input ls_unit_sel, op_11_odd, op_9_odd, op_8_odd, op_7_odd;
input [0:31] inst_odd;
reg [0:31] inst_odd_d;
//--------------INPUTS from Register File
input [0:127] ra_data_odd, rb_data_odd, rc_data_odd;
reg [0:127] ra_data_odd_d, rb_data_odd_d, rc_data_odd_d;
//--------------INPUTS from Local Store
input [0:127] ip_mem_data;

//-------------- OUTPUTS to Local Store
output reg [0:6] addr_final;
output reg select_op;
output [0:127] op_rt_data;
reg ls_unit_sel_d, op_11_odd_d, op_9_odd_d, op_8_odd_d, op_7_odd_d;
//-------------- OUTPUTS to ODD output select pipe
output reg [0:127] ls_output; 
output reg ls_out_availible; 
output reg [0:6] addr_rt;
//-------------------------------------------------------------------------------------------------------------------
reg unit_op_0, unit_op_1, unit_op_2, unit_op_3, unit_op_4, unit_op_5, unit_op_6, unit_op_7; 
reg [0:127] temp_0,temp_1,temp_2,temp_3,temp_4,temp_5;
reg [0:31] op_ls_addr; 
reg [0:31] ip_store_addr ;
wire [0:127] ip_ls_data;
reg [0:127] ip_store_data;
reg [0:6] addr_rt_0,addr_rt_1,addr_rt_2,addr_rt_3,addr_rt_4,addr_rt_5,addr_rt_6;
reg wr_en_op;

//-----------Load inst exchange declaration
wire [0:127] op_rt_data;
wire [0:6] op_mem_addr_store;
wire wr_en;

//-----------Store inst exchange declaration
wire [0:6] op_mem_addr_load;


//-----------Load inst exchange unit
assign op_rt_data = reset?0:ip_store_data;
assign op_mem_addr_store = reset?0:op_ls_addr[21:27];
assign wr_en = reset?0:wr_en_op;

//-----------Store inst exchange unit
assign op_mem_addr_load = reset?0:addr_rt;
assign ip_ls_data = reset?0:ip_mem_data;


always @ (*)
begin

    if (reset)
    begin
              temp_0 = 0;
  	  ip_store_addr = 0;
	  wr_en_op = 0;
	  op_ls_addr = 0;
	  ip_store_data = 0;
	  addr_final = 0;
	  unit_op_0 = 0;
	   select_op = 0;
    
    end
          else begin
          temp_0 = 0;
  	  ip_store_addr = 0;
	  wr_en_op = 0;
	  op_ls_addr = 0;
	  ip_store_data = 0;
	  addr_final =0;
	   select_op = 0;
          
	  
	if(ls_unit_sel_d)
	begin
		unit_op_0 = 1'b1;
		if(op_7_odd_d)    //-----------------ILA Instruction
		  begin
		  temp_0 = {14'd0,inst_odd_d[7:24],14'd0,inst_odd_d[7:24],14'd0,inst_odd_d[7:24],14'd0,inst_odd_d[7:24]};
		  wr_en_op = 1'b0;
		  ip_store_addr = 0;
		  end
		
		else if(op_9_odd_d)
		  begin
		  case(inst_odd_d[0:8])
		  `LQA:begin
		       op_ls_addr = {{14{inst_odd_d[9]}},inst_odd_d[9:24],2'b00} & 32'h00003fff & 32'hfffffff0;
		       temp_0 = ip_ls_data;
		       wr_en_op = 1'b0;
		       ip_store_addr = 0;
		       end 

		  `STQA:begin
			temp_0 = {{14{inst_odd_d[9]}},inst_odd_d[9:24],2'b00} & 32'h00003fff & 32'hfffffff0;
			ip_store_addr = {{14{inst_odd_d[9]}},inst_odd_d[9:24],2'b00} & 32'h00003fff & 32'hfffffff0;
			ip_store_data = rc_data_odd_d;
			wr_en_op = 1'b1;
			end

		  `ILH:begin
		       temp_0 = {8{inst_odd_d[9:24]}};
		       wr_en_op = 1'b0;
		       ip_store_addr = 0;
		       end

		  `IL:begin
		      temp_0 = {4{{16{inst_odd_d[9]}},inst_odd_d[9:24]}};
		      wr_en_op = 1'b0;	
		      ip_store_addr = 0;
		      end
		      
                    default:begin
                            temp_0 = 0;
                            wr_en_op = 1'b0;	
                            ip_store_addr = 0;
                            ip_store_addr = 0;
                            ip_store_addr = 0;
                            end
		  endcase
		  end

		else if(op_8_odd_d)
		  begin
		  case(inst_odd_d[0:7])
		  `LQD:begin
		       op_ls_addr = ({{18{inst_odd_d[8]}},inst_odd_d[8:17],4'd00} + ra_data_odd_d[96:127]) & 32'h00003fff & 32'hfffffff0;
		       temp_0 = ip_ls_data;
		       wr_en_op = 1'b0;
		       ip_store_addr = 0;
		       end

		  `STQD:begin
			temp_0 = ({{18{inst_odd_d[8]}},inst_odd_d[8:17],4'd00} + ra_data_odd_d[96:127]) & 32'h00003fff & 32'hfffffff0;
			ip_store_addr = ({{18{inst_odd_d[8]}},inst_odd_d[8:17],4'd00} + ra_data_odd_d[96:127]) & 32'h00003fff & 32'hfffffff0;
			ip_store_data = rc_data_odd_d;
			wr_en_op = 1'b1;
			end
			
                   default:begin
                            temp_0 = 0;
                            wr_en_op = 1'b0;	
                            ip_store_addr = 0;
                            ip_store_addr = 0;
                            ip_store_addr = 0;
                            end
		  endcase
		  end

		else if(op_11_odd_d)
		  begin
		  case(inst_odd_d[0:10])
		  `LQX:begin
		       op_ls_addr = (ra_data_odd_d[96:127] + rb_data_odd_d[96:127]) & 32'h00003fff & 32'hfffffff0;
		       temp_0 = ip_ls_data;
		       wr_en_op = 1'b0;
		       ip_store_addr = 0;
		       end

		  `STQX:begin
			temp_0 = (ra_data_odd_d[96:127] + rb_data_odd_d[96:127]) & 32'h00003fff & 32'hfffffff0;
			ip_store_addr = (ra_data_odd_d[96:127] + rb_data_odd_d[96:127]) & 32'h00003fff & 32'hfffffff0;
			ip_store_data = rc_data_odd_d;
			wr_en_op = 1'b1;
			end
			
                   default:begin
                            temp_0 = 0;
                            wr_en_op = 1'b0;	
                            ip_store_addr = 0;
                            ip_store_addr = 0;
                            ip_store_addr = 0;
                            end
		  endcase
		  end

		else 
		  begin
			temp_0 = 0;
			ip_store_addr = 0;
			ip_store_data = 0;
			wr_en_op = 0; 
			unit_op_0 = 1'b0;
		  end
	end

	else 
	begin
	  temp_0 = 0;
  	  ip_store_addr = 0;
	  ip_store_data = 0;
	  wr_en_op = 0;
	  unit_op_0 = 1'b0;
	  select_op = 0;
	end

	if(wr_en)
	begin
	  addr_final = op_mem_addr_store;
	  select_op = 1'b1;
	end

	else
	begin
	  addr_final = op_mem_addr_load;
	  select_op = 1'b0;
	end	
end
end


always @(posedge clk or posedge reset or posedge unit_reset) 
begin
	if(reset)
	begin
	  temp_1 <=  128'd0;
	  addr_rt_0 <=  32'd0;
	  unit_op_1 <=  1'b0;
	  {ra_data_odd_d, rb_data_odd_d, rc_data_odd_d} <=  0;
	  inst_odd_d <=  0;
	  ls_output <= 0;
	  addr_rt <= 0;
	  ls_out_availible <= 0;
	{ls_unit_sel_d, op_11_odd_d, op_9_odd_d, op_8_odd_d, op_7_odd_d} <= 0;
        temp_2 <=  0;
	temp_3 <=  0;
	temp_4 <=  0;
	temp_5 <=  0;
	addr_rt_0 <=  0;
	addr_rt_1 <=  0;
	addr_rt_2 <=  0;
	addr_rt_3 <=  0;
	addr_rt_4 <=  0;
	addr_rt_5 <=  0;
	addr_rt_6 <=  0;
        unit_op_1 <=  0;	
	unit_op_2 <=  0;	
	unit_op_3 <=  0;	
	unit_op_4 <=  0;	
	unit_op_5 <=  0;	
	unit_op_6 <=  0;	
	unit_op_7 <=  0;
	end

	else if (unit_reset)
	begin
	  	  temp_1 <=  128'd0;
	  addr_rt_0 <=  32'd0;
	  unit_op_1 <=  1'b0;
	  {ra_data_odd_d, rb_data_odd_d, rc_data_odd_d} <=  0;
	  inst_odd_d <=  0;
	  ls_output <= 0;
	  addr_rt <= 0;
	  ls_out_availible <= 0;
	{ls_unit_sel_d, op_11_odd_d, op_9_odd_d, op_8_odd_d, op_7_odd_d} <= 0;
        temp_2 <=  0;
	temp_3 <=  0;
	temp_4 <=  0;
	temp_5 <=  0;
	addr_rt_0 <=  0;
	addr_rt_1 <=  0;
	addr_rt_2 <=  0;
	addr_rt_3 <=  0;
	addr_rt_4 <=  0;
	addr_rt_5 <=  0;
	addr_rt_6 <=  0;
        unit_op_1 <=  0;	
	unit_op_2 <=  0;	
	unit_op_3 <=  0;	
	unit_op_4 <=  0;	
	unit_op_5 <=  0;	
	unit_op_6 <=  0;	
	unit_op_7 <=  0;
	end

	else
	begin
	
		
                {ls_unit_sel_d, op_11_odd_d, op_9_odd_d, op_8_odd_d, op_7_odd_d} <= {ls_unit_sel, op_11_odd, op_9_odd, op_8_odd, op_7_odd};
                
                
                
	if(ls_unit_sel) begin
	addr_rt <=  inst_odd_d[25:31];
	
        inst_odd_d <=  inst_odd;

	{ra_data_odd_d, rb_data_odd_d, rc_data_odd_d} <=  {ra_data_odd, rb_data_odd, rc_data_odd};
	end
	
	else
	begin
        addr_rt <=  0;
	ls_out_availible <=  0;	
        inst_odd_d <=  0;
// 	ls_output <=  0;
	{ra_data_odd_d, rb_data_odd_d, rc_data_odd_d} <=  0;
	end
	
	if(ls_unit_sel_d) begin
	ls_out_availible <=  unit_op_0;	
		ls_output <=  temp_0;
	end
	else  begin
	ls_out_availible <=  0;	
		ls_output <=  0;
	end
// 	temp_2 <=  temp_1;
// 	temp_3 <=  temp_2;
// 	temp_4 <=  temp_3;
// 	temp_5 <=  temp_4;
// 	ls_output <=  temp_5;

	
	
	
// 	addr_rt_1 <=  addr_rt_0;
// 	addr_rt_2 <=  addr_rt_1;
// 	addr_rt_3 <=  addr_rt_2;
// 	addr_rt_4 <=  addr_rt_3;
// 	addr_rt <=  addr_rt_4;

	
// 	unit_op_2 <=  unit_op_1;	
// 	unit_op_3 <=  unit_op_2;	
// 	unit_op_4 <=  unit_op_3;	
// 	unit_op_5 <=  unit_op_4;		
// 	ls_out_availible <=  unit_op_5;
	end
end
endmodule
