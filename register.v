/* This module is for 128X128 byte Register file to store the output data
   of instruction execution or read the data from the register file. This 
   module accepts write & output data for the data from the Writeback module 
   and address from even and odd pipe module and writes data to its appropriate 
   register address.*/

`timescale 1ns/10ps
module REGISTER ( /*input*/	
		    clk,reset,

		  /*input from Write Back Even module out*/
		 data_even, wr_even, addr_even,
		  
		  /*input from Write Back Odd module out*/
		 data_odd,  wr_odd, addr_odd,

		  /*input from Pipe Even module out*/
		 addr_ra_even,addr_rb_even,addr_rc_even,

		  /*input from Pipe Even module out*/
		 addr_ra_odd,addr_rb_odd,addr_rc_odd,

		  /*output for even data*/
		 ra_data_even, rb_data_even, rc_data_even,

		  /*output for odd data*/
		 ra_data_odd, rb_data_odd, rc_data_odd);
integer i;

input clk,reset;
input wr_even, wr_odd;

input [0:127] data_even, data_odd;

input [0:6] addr_ra_even, addr_rb_even, addr_rc_even, addr_even;
input [0:6] addr_ra_odd,  addr_rb_odd,  addr_rc_odd,  addr_odd;

output [0:127] ra_data_even, rb_data_even, rc_data_even;
output [0:127] ra_data_odd,  rb_data_odd,  rc_data_odd;
// output reg write_done;
// reg [0:127] ra_data_even_d, rb_data_even_d, rc_data_even_d;
// reg [0:127] ra_data_odd_d,  rb_data_odd_d,  rc_data_odd_d;

reg [0:127] register [127:0];
reg [0:127] data_even_d, data_odd_d;
reg [0:6] addr_ra_even_d, addr_rb_even_d, addr_rc_even_d, addr_even_d;
reg [0:6] addr_ra_odd_d,  addr_rb_odd_d,  addr_rc_odd_d,  addr_odd_d;
reg wr_even_d, wr_odd_d;
//-- READ OPERATION FOR EVEN DATA IN . . ALWAYS PROVIDES READ DATA       

	assign ra_data_even = register[addr_ra_even];
	assign rb_data_even = register[addr_rb_even];
	assign rc_data_even = register[addr_rc_even];

//-- READ OPERATION FOR ODD DATA IN . . ALWAYS PROVIDES READ DATA       

	assign ra_data_odd = register[addr_ra_odd];
	assign rb_data_odd = register[addr_rb_odd];
	assign rc_data_odd = register[addr_rc_odd];

initial begin
register[0] = 0;
register[1] = 128'h333;  // AH data
register[2] = 128'h666;
register[4] = 128'd1;   // SHLQBI data
register[5] = 128'd8;

register[7] = 128'd7;  // CNTB data
register[9] = 128'd2;  // SHLQBY data
register[10] = 128'd15;

register[12] = 128'd45; // XORHI data
register[14] = 128'd5;  // ROTQBI data
register[15] = 128'd256;

register[17] = 128'h101; // GBB data
register[19] = 128'd2;   // ROTQBY data
register[20] = 128'd16;

register[22] = 128'd45; // ANDHI data
register[24] = 128'd34; //ROTQMBY data
register[25] = 128'd8;

register[27] = 128'h100000001; // GB data
register[29] = 128'd8; //SFH data
register[30] = 128'd8;

register[32] = 128'h11; // AVGB data
register[33] = 128'h11;

register [34] = 128'd1; // for branching data
// $monitor($time, "      destination address is %d and written data is %h  ",addr_even, register[addr_even] );
// for(i=0;i<64;i=i+1)
// begin
// register[i] = 128'h33; 
// end
// 
// for(i=64;i<128;i=i+1)
// begin
// register[i] = 128'h66; 
// end

end
always @ (posedge (clk) or posedge reset) 
  begin
     if(reset)
     begin
{data_even_d, data_odd_d} <= 0;
{wr_even_d, wr_odd_d} <= 0;
{addr_ra_even_d, addr_rb_even_d, addr_rc_even_d, addr_even_d} <= 0;
{addr_ra_odd_d,  addr_rb_odd_d,  addr_rc_odd_d,  addr_odd_d} <= 0;
// {ra_data_even_d,rb_data_even_d,rc_data_even_d} <= 0;
// {ra_data_odd_d,rb_data_odd_d,rc_data_odd_d} <= 0;
end
     else
       begin
{data_even_d, data_odd_d} <= {data_even, data_odd};
{wr_even_d, wr_odd_d} <= {wr_even, wr_odd};
{addr_ra_even_d, addr_rb_even_d, addr_rc_even_d, addr_even_d} <= {addr_ra_even, addr_rb_even, addr_rc_even, addr_even};
{addr_ra_odd_d,  addr_rb_odd_d,  addr_rc_odd_d,  addr_odd_d} <= {addr_ra_odd,  addr_rb_odd,  addr_rc_odd,  addr_odd};

/*	 ra_data_even_d <= register[addr_ra_even_d];
	 rb_data_even_d <= register[addr_rb_even_d];
	 rc_data_even_d <= register[addr_rc_even_d];

//-- READ OPERATION FOR ODD DATA IN . . ALWAYS PROVIDES READ DATA       

	 ra_data_odd_d <= register[addr_ra_odd_d];
	 rb_data_odd_d <= register[addr_rb_odd_d];
	 rc_data_odd_d <= register[addr_rc_odd_d];  */ 

//-- WRITE OPERATION FOR EVEN DATA OUT	
	if (wr_even) 
	  begin register[addr_even] <= data_even;
//                 write_done <= 1'b1;
                $monitor("destination address is %d and written data is %h  ",addr_even_d, register[addr_even_d] );
          end
      /*  else write_done <= 0; */ 
//-- WRITE OPERATION FOR ODD DATA OUT
	if(wr_odd)
	begin
	  register[addr_odd] <= data_odd;
	  $display("destination address is %d and written data is %h  ",addr_odd_d, register[addr_odd_d] );
// 	  write_done <= 1'b1;
        end
//         else write_done <= 0;  
  end
  end
endmodule