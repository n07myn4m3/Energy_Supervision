`timescale 10ns / 1ps
`define SIMULATION


module peripheral_i2c_TB;

  
   reg clk;
   reg rst = 0;
   reg  start;
   reg [15:0]d_in;
   reg cs;
   reg [3:0]addr;
   reg rd;
   reg wr;
   reg [15:0] rw = 16'd0001;
   reg sda_out = 1'bz;
   wire [15:0]d_out;
   wire sda;
   wire scl;
   reg [4:0] count_aux = 9;
   reg [7:0] vamo_a_leer = 8'h25;
   reg       direc = 1'b0;
   

   peripheral_i2c uut (.clk(clk) , .rst(rst) , .d_in(d_in) , .cs(cs) , .addr(addr) , .rd(rd) , .wr(wr), .d_out(d_out), .sda(sda), .scl(scl));

   assign sda = sda_out;
   parameter PERIOD          = 1;
   parameter real DUTY_CYCLE = 0.5;
   parameter OFFSET          = 0;
   reg [20:0] i;
   event reset_trigger;
   parameter  input_clk = 100000000;
   parameter  bus_clk = 100000;
   localparam divider = (input_clk/bus_clk)/4;


   initial begin  // Initialize Inputs
      clk = 0; start = 0; cs=1; rd=0; wr=1; rst = 1;
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

       for(i=0; i<8; i=i+1) begin
         @ (posedge clk);
       end
          start = 0;

				// stimulus here
       for(i=0; i<8; i=i+1) begin
         @ (posedge clk);
       end

	      d_in = rw;  //envio rw
        addr = 16'h0002;
	      cs=1; rd=0; wr=1;rst=0;

       for(i=0; i<8; i=i+1) begin
         @ (posedge clk);
       end

	      d_in = 16'd5236;	//envio addr
	      addr = 16'h0004;
	      cs=1; rd=0; wr=1;rst=0;

       for(i=0; i<4; i=i+1) begin
         @ (posedge clk);
       end

	      d_in = 16'd1111;	//envio data_wr
	      addr = 16'h0006;
	      cs=1; rd=0; wr=1;

       for(i=0; i<8; i=i+1) begin
         @ (posedge clk);
       end
        d_in = 16'd0001;	//envio ena
	      addr = 16'h0000;
	      cs=1; rd=0; wr=1;

      end
   end




    always @(negedge scl) begin
       @ (negedge clk) begin
       #250                             //Espera 250 para cambiar los datos cuando slc esta en 
       count_aux = count_aux-1;
           if (!rw[0] || !direc) begin  //permite escribir la dirección para después poder leer el modulo
                if (count_aux == 0) begin
                  sda_out = 1'b1;    //Permite verificar si la señal ACK_ERROR esta funcionando
                  count_aux = 9;
                  direc = 1'b1;         
                  addr = 16'h000a;      //Envía al D_out la senal de ACK_ERROR
	                cs=1; rd=1; wr=0;
                end else begin
                  sda_out = 1'bz;      //Permanece en alta impedancia el modulo de prueba mientras escribe
                  rd=0; wr=1;
                end
           end else begin
               if (count_aux == 0) begin
                  sda_out = 1'bz;
                  vamo_a_leer = $random;  //Después de la primer escritura precargada en el TB, precarga nuevos data_wr
                  count_aux = 9;
	                addr = 16'h000b;        //Envía al D_out el dato leido
	                cs=1; rd=1; wr=0;               
               end else begin
                  sda_out = vamo_a_leer[count_aux-1] ? 1'b1:1'b0;
                   if(rd && (count_aux == 8)) begin
                      addr = 16'h0008;    //Envía senal de busy al D_out
	                    cs=1; rd=1; wr=0; 
                   end else begin
                      rd=0;
                   end
               end
          end 
       end
    end


   initial begin: TEST_CASE
     $dumpfile("peripheral_i2c_TB.vcd");
     $dumpvars(-1, uut);
	
     #10 -> reset_trigger;
     #30000
      d_in = 16'd0000;	//envio ena
	    addr = 16'h0000;
    	cs=1; rd=0; wr=1;
     #((PERIOD*DUTY_CYCLE)*100000) $finish;

   end
endmodule
