//256kB LS is single port RAM, implemented here as pseudo DPRAM.

//First priority is DMA(128-bytes), then load-store ops(128-bits), and finally instructions(fetched in 128 bytes and then passed on to ILB). DMA is not implemented here.
`timescale 1ns/10ps
module localstore ( //OUTPUT to ILB
                    op_inst,

                    //OUTPUT to load_store unit (ls.v)(ip_mem_data port)
                    op_lsops,

                    //INPUTS
                    clk,  reset,

                    //INPUT comes from load_store unit (ls.v)(select_op port)
                    wr_en_data,

                    //INPUT comes from top level testbench
                    wr_en_inst, ip_inst_packet,
                    
                    //INPUT comes from load_store unit (ls.v)(addr_final port)
                    addr_lsops,
                    
                    //INPUT comes from branch unit (op_addr port)
                    addr_inst, start,
                    
                    //INPUT comes from load_store unit (ls.v)(op_rt_data port)
                    data_lsops);

 input clk, reset, wr_en_data, wr_en_inst;
 input [0:6] addr_lsops, addr_inst; 
 input [0:127] data_lsops;
 input [0:1023] ip_inst_packet;
 output  start; 
 output [0:127] op_lsops;
 output [0:1023] op_inst; 
 integer i;
 //Actual memory declared here
 reg [0:127] lsmem[0:127];  //7 bit address (addrs_lsops and addr_inst) i.e top value can be 7'h1111 i.e 128 in decimal
 
 
 
 // for testing which memory location gets what data
//  reg [0:127] a_lsmem,b_lsmem,c_lsmem,d_lsmem,e_lsmem,f_lsmem,g_lsmem,h_lsmem;



 assign start = (op_inst==0 || reset) ? 0 : 1; 
 assign op_lsops = reset?0:lsmem[addr_lsops];

//  // for testing in reverse order addresing 
//  assign op_inst[0:127] = reset?0:lsmem[addr_inst];
//  assign op_inst[128:255] = reset?0:lsmem[addr_inst+1];
//  assign op_inst[256:383] = reset?0:lsmem[addr_inst+2];
//  assign op_inst[384:511] = reset?0:lsmem[addr_inst+3];
//  assign op_inst[512:639] = reset?0:lsmem[addr_inst+4];
//  assign op_inst[640:767] = reset?0:lsmem[addr_inst+5];
//  assign op_inst[768:895] = reset?0:lsmem[addr_inst+6];
//  assign op_inst[896:1023] = reset?0:lsmem[addr_inst+7]; 
 
 
assign op_inst[896:1023] = reset?0:lsmem[addr_inst];
 assign op_inst[768:895] = reset?0:lsmem[addr_inst+1];
 assign op_inst[640:767] = reset?0:lsmem[addr_inst+2];
 assign op_inst[512:639] = reset?0:lsmem[addr_inst+3];
 assign op_inst[384:511] = reset?0:lsmem[addr_inst+4];
 assign op_inst[256:383] = reset?0:lsmem[addr_inst+5];
 assign op_inst[128:255] = reset?0:lsmem[addr_inst+6];
 assign op_inst[0:127] = reset?0:lsmem[addr_inst+7]; 

 
 
 
// assign op_inst = reset?0:({lsmem[addr_inst],lsmem[addr_inst+1],lsmem[addr_inst+2],lsmem[addr_inst+3],lsmem[addr_inst+4],lsmem[addr_inst+5],lsmem[addr_inst+6],lsmem[addr_inst+7]}) ;
always @ (posedge clk or posedge reset) 
begin
    if (reset) 
    begin 
        for (i=0;i<=127;i=i+1) lsmem[i] <= 0;  
    end

    else 
    begin
//     $monitor ("memory 5 is %h ", lsmem[5]);
        if (wr_en_data)
            begin 
            lsmem[addr_lsops] <= data_lsops;
            end

        else if (wr_en_inst) 
        begin
            lsmem[addr_inst+7]   <= ip_inst_packet[0:127];
            lsmem[addr_inst+6] <= ip_inst_packet[128:255];
            lsmem[addr_inst+5] <= ip_inst_packet[256:383];
            lsmem[addr_inst+4] <= ip_inst_packet[384:511];
            lsmem[addr_inst+3] <= ip_inst_packet[512:639];
            lsmem[addr_inst+2] <= ip_inst_packet[640:767];
            lsmem[addr_inst+1] <= ip_inst_packet[768:895];
            lsmem[addr_inst+0] <= ip_inst_packet[896:1023];
            
            
            
//             // for testing which memory location gets what data
//             h_lsmem <= ip_inst_packet[0:127];
//             g_lsmem <= ip_inst_packet[128:255];
//             f_lsmem <= ip_inst_packet[256:383];
//             e_lsmem <= ip_inst_packet[384:511];
//             d_lsmem <= ip_inst_packet[512:639];
//             c_lsmem <= ip_inst_packet[640:767];
//             b_lsmem <= ip_inst_packet[768:895];
//             a_lsmem <= ip_inst_packet[896:1023];
//             
        end
        
        else begin
            lsmem[addr_inst] <= lsmem[addr_inst];
        end
    end 
end



endmodule
