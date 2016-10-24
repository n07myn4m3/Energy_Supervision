/*
Division de las direcciones usar

4'h0 go
4'h2 dividend [31:16]   
4'h4 dividend [15:0]
4'h6 divisor  [31:16]   
4'h8 divisor  [15:0]   

4'hA done
4'hC quotient [31:16]
4'hE quotient [15:0]

*/

`timescale 1ns / 1ps

`define SIMULATION


module peripheral_division32_TB;

  
   reg         clk;
   reg         rst;
   reg         reset;
   reg         start;
   reg  [15:0] d_in;
   reg         cs;
   reg   [3:0] addr;
   reg         rd;
   reg         wr;
   wire [15:0] d_out;

   peripheral_division32 uut (.clk(clk) , .rst(rst) , .d_in(d_in) , .cs(cs) , .addr(addr) , .rd(rd) , .wr(wr), .d_out(d_out) );


   parameter PERIOD          = 20;
   parameter real DUTY_CYCLE = 0.5;
   parameter OFFSET          = 0;
   reg [20:0] i;
   event reset_trigger;




   initial begin  // Initialize Inputs
      clk = 0; rst = 1; start = 0; d_in = 16'd0000; addr = 16'h0000; cs=1; rd=0; wr=1;
   end

   initial  begin  // Process for clk
     #OFFSET;
     forever
       begin
         clk = 1'b0;
         #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
         #(PERIOD*DUTY_CYCLE);
       end
   end

   initial begin // Reset the system, Start the image capture process
      forever begin 
        @ (reset_trigger);
        @ (posedge clk);
        start = 0;
        @ (posedge clk);
        start = 1;

       for(i=0; i<2; i=i+1) begin
         @ (posedge clk);
       end
          start = 0;

//--------------------------------------------------------------
// Aqui inician los estimulos
//--------------------------------------------------------------
      rst = 0;      
       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------
			d_in = 16'd0000;	//envio dividend [31:16]    
			addr = 16'h6802;
			cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------
			d_in = 16'd1000;	//envio dividend [15:0] 
			addr = 16'h6804;
			cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------
			d_in = 16'd0000;	//envio divisor [31:16]
			addr = 16'h6806;
			cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------
			d_in = 16'd5;	   //envio divisor [15:0]
			addr = 16'h6808;
			cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------
			d_in = 16'd1;	   //envio go
			addr = 16'h6800;
			cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------
			d_in = 16'd0;	   //envio go
			addr = 16'h6800;
			cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end

//------------------------------------
	while(d_out==0) begin
			d_in = 16'd0000;	//recivo dato
			addr = 16'h680A;
			cs=1; rd=1; wr=0;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
	end
//------------------------------------

			d_in = 16'd0000;	//recivo dato
			addr = 16'h680C;
			cs=1; rd=1; wr=0;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end

//------------------------------------

			d_in = 16'd0000;	//recivo dato
			addr = 16'h680E;
			cs=1; rd=1; wr=0;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end


      end
   end
	 

   initial begin: TEST_CASE
     $dumpfile("peripheral_division32_TB.vcd");
     $dumpvars(-1, uut);
	
     #10 -> reset_trigger;
     #((PERIOD*DUTY_CYCLE)*200) $finish;
   end

endmodule

