/*
-El diseño de la dual port ram no es mas que un arreglo de vectores, en este caso un arreglo de 256 vectores con un tamaño de 16 bits.
-El bus de direccion del j1_io_addr que consiste en un arreglo de 16 bits deja los ultimos 8 bits para hacer referencia a la direccion
 de la ram dualport y los primeros 8 bits para direccionar cada una de las 256 direcciones internas de la memoria. por ende en el j1 
 soc el vector de entrada de direccion no debe ser el tipico que se usan con los modulos convencionales de j1_io_addr[3:0] sino  de
 j1_io_addr [7:0], acontinuacion un ejemplo:

  dpRAM_interface    dpRm(   .clk(sys_clk_i), .d_in(j1_io_dout), .cs(cs[4]), .addr(j1_io_addr[7:0]), .rd(j1_io_rd), 
                              .wr(j1_io_wr), .d_out(dp_ram_dout));
*/

module dualport_RAM(clk, d_in, d_out, addr, rd, wr);

/* 
========================================================================

DESCRIPCION DEL MODULO

Este modulo declara una memoria ram de 256-bit x 16-bit

ESQUEMA DEL MODULO
                   ______________
    d_in     ---->|              |
                  |              |
    rd       ---->| dualport_RAM |
    wr       ---->|              |
    addr     ---->|              |
    clk      ---->|>             |----> d_out
                  |______________|
========================================================================
*/
  
  input clk;

  input      [15:0] d_in;
  output reg [15:0] d_out = 0;
  input       [7:0] addr; // 8 LSB from address
  input             rd;
  input             wr;

  // Declare the RAM variable
  reg [15:0] ram [255:0]; // 256-bit x 16-bit RAM


always @(negedge clk)
begin

//------------------ port 1	: 	core J1---------------------

	if (rd) begin
		d_out<= ram[addr];
	end
	else if(wr) begin
		ram[addr] <= d_in;
	end

//------------------ port 1	: 	core J1---------------------
end

endmodule
