/*
Notas:
-El reloj de la pipistrello va a 50Mhz mientras que el reloj de la nexys4 DDR va a 100 Mhz
 lo cual se debe tener en cuenta al momento de determinar el valor de input_clk
*/

`define log2(n)   ((n) <= (1<<0)  ? 0 : (n)  <= (1<<1)  ? 1  :\
                   (n) <= (1<<2)  ? 2 : (n)  <= (1<<3)  ? 3  :\
                   (n) <= (1<<4)  ? 4 : (n)  <= (1<<5)  ? 5  :\
                   (n) <= (1<<6)  ? 6 : (n)  <= (1<<7)  ? 7  :\
                   (n) <= (1<<8)  ? 8 : (n)  <= (1<<9)  ? 9  :\
                   (n) <= (1<<10) ? 10 : (n) <= (1<<11) ? 11 :\
                   (n) <= (1<<12) ? 12 : (n) <= (1<<13) ? 13 :\
                   (n) <= (1<<14) ? 14 : (n) <= (1<<15) ? 15 :\
                   (n) <= (1<<16) ? 16 : (n) <= (1<<17) ? 17 :\
                   (n) <= (1<<18) ? 18 : (n) <= (1<<19) ? 19 :\
                   (n) <= (1<<20) ? 20 : (n) <= (1<<21) ? 21 :\
                   (n) <= (1<<22) ? 22 : (n) <= (1<<23) ? 23 :\
                   (n) <= (1<<24) ? 24 : (n) <= (1<<25) ? 25 :\
                   (n) <= (1<<26) ? 26 : (n) <= (1<<27) ? 27 :\
                   (n) <= (1<<28) ? 28 : (n) <= (1<<29) ? 29 :\
                   (n) <= (1<<30) ? 30 : (n) <= (1<<31) ? 31 : 32)

module timmer (ClkOut, Clk, Reset);

    parameter   input_clk    = 100000000;  
    parameter   bus_clk      = 1; // Cantidad de flancos que se presentaran en un segundo
    parameter   divFactor    = input_clk/bus_clk; 
    parameter   on_counting  = 10;  // En realidad solo duraria 2 conteos menos a lo establecido
    //parameter   maxCount     = divFactor/2;
    parameter   maxCount     = divFactor;
    parameter   counterWidth = `log2(maxCount);
    output  reg ClkOut;
    input       Clk, Reset;
    
    reg     [counterWidth-1: 0]  Q;
    
 always @(posedge Clk) begin
//Condicion de reseteo del contador 
		if(Reset) begin
			Q <= 0;
		end
		else begin
				if(Q == (maxCount-1)) begin // Probare modificar la cantidad de tiempo que durara el flanco
				Q <= 0;
				end
					else begin
					  Q <= Q + 1'b1;
					end
		end

//Condicion de display
		if(Q > (maxCount - on_counting) && Q < (maxCount-1)) begin
			ClkOut <= 1'b1;
		end
      else begin
         ClkOut <= 1'b0;
      end
 end

endmodule

// Codigo original
/*
always @(posedge Clk, negedge Reset) begin 
     if(Reset) begin
         Q <= 0;
         ClkOut <= 1'b0;
     end
     else begin
			if(ClkOut==1'b1) begin
            ClkOut <= ~ClkOut;
			end
         else begin
					if(Q == (maxCount-1)) begin // Probare modificar la cantidad de tiempo que durara el flanco
					Q <= 0;
					ClkOut <= ~ClkOut;
					end
						else begin
						  Q <= Q + 1;
						end
		    end
     end
 end
*/



