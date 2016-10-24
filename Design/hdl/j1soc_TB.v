`timescale 1ns / 1ps
`define SIMULATION
// ============================================================================
// TESTBENCH FOR TINYCPU
// ============================================================================

module j1soc_TB ();

reg 	       sys_clk_i, sys_rst_i;
wire  	     uart_tx, ledout; 
wire 	[15:0] gp_out0, gp_out1;
reg 	[15:0] gp_in0, gp_in1;
reg          sda_out = 1'bz;
reg   [8:0]  count;
reg   [3:0]  count_aux = 9;
reg   [1:0]  direc = 0;     // FLAG


wire sda;
wire scl;


reg   [7:0]  vamo_a_leer = 8'h02;
reg          start = 1'b0;  // FLAG
reg          wr = 1'b0;     // FLAG



j1soc uut (
	 .uart_tx(uart_tx), .ledout(ledout), .gp_out0(gp_out0), .gp_out1(gp_out1), .gp_in0(gp_in0), .gp_in1(gp_in1), .sys_clk_i(sys_clk_i), .sys_rst_i(sys_rst_i), .sda(sda), .scl(scl)
);

assign sda = sda_out; 


initial begin
  sys_clk_i   = 1;
  sys_rst_i = 1;
  #10 sys_rst_i = 0;
  gp_in0 = 16'd12;
  gp_in1 = 16'd465;
  count = 9;
end

always sys_clk_i = #5 ~sys_clk_i;   //100MHz
//always sys_clk_i = #10 ~sys_clk_i;    //50MHz



    always @(negedge sda) begin
       @ (negedge sys_clk_i) begin
         if(scl == 1'b1) begin
            start = 1'b1;   
//            sda_out <= 1'b1;
          end
       end
    end
   
  always @(negedge scl) begin
    #2505 
      if(start) begin
         count = count-1;
         if(count == 0) begin
            start = 1'b0;
            count = 9;
            $display("start = %b,sda = %h, wr = %h",start,sda,wr);
              if(sda == 1'b0)begin  
                wr = 0;
              end else begin
                wr = 1;
                direc = 0;      
              end            
        end
     end
  end
               
  always @(negedge scl) begin    
     #2505                             //Espera 250 para cambiar los datos cuando slc esta en
       if (wr  && (direc < 2)) begin 
           count_aux = count_aux-1; 
           if (count_aux <= 8) begin
               sda_out = vamo_a_leer[count_aux-1] ? 1'b1:1'b0;
               if(count_aux == 0) begin
                  count_aux = 9;
                  sda_out = 1'bz;
                  vamo_a_leer = $random;  //Después de la primer escritura precargada en el TB, precarga nuevos data_wr
                  $display("VALORES RAMDON = %b,VALORES RAMDON = %h",vamo_a_leer, vamo_a_leer); 
                  direc = direc+1;
               end  
           end
       end 
    end

     

initial begin: TEST_CASE
  $dumpfile("j1soc_TB.vcd");
  $dumpvars(-1, uut);
  //#80000 $finish;
    #10000000 $finish;
end

endmodule
