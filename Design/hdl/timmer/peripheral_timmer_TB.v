/*
Division de las direcciones usar

4'h0 enable
4'h2 data     

4'h4 tho
4'h6 hun
4'h8 ten
4'hA uni
4'hC done

*/

`timescale 1ns / 1ps

`define SIMULATION


module peripheral_timmer_TB;

  
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

   peripheral_timmer uut (.clk(clk) , .rst(rst) , .d_in(d_in) , .cs(cs) , .addr(addr) , .rd(rd) , .wr(wr), .d_out(d_out) );


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
			d_in = 16'd9999;	//recivo data
			addr = 16'h6302;
			cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------
			d_in = 16'd0001;	//recivo enable
			addr = 16'h6300;
			cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------
			d_in = 16'd0000;	//recivo enable
			addr = 16'h6300;
			cs=1; rd=0; wr=1;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------
			d_in = 16'd0000;	//tho
			addr = 16'h6304;
			cs=1; rd=1; wr=0;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------
			d_in = 16'd0000;	//hun
			addr = 16'h6306;
			cs=1; rd=1; wr=0;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------
			d_in = 16'd0000;	//ten
			addr = 16'h6308;
			cs=1; rd=1; wr=0;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------
			d_in = 16'd0000;	//uni
			addr = 16'h630A;
			cs=1; rd=1; wr=0;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------
			d_in = 16'd0000;	//done
			addr = 16'h630C;
			cs=1; rd=1; wr=0;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end
//------------------------------------

      end
   end
	 

   initial begin: TEST_CASE
     $dumpfile("peripheral_timmer_TB.vcd");
     $dumpvars(-1, uut);
	
     #10 -> reset_trigger;
     #((PERIOD*DUTY_CYCLE)*50000000) $finish;
   end

endmodule

