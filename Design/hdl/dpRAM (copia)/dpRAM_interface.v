/*
-Esta es la interfaz por defecto que funciona para comunicar el modulo dualport_RAM con el J1 
*/

module dpRAM_interface(clk, addr, d_in, d_out, cs, wr,  rd);
  
  input          clk;
  input  [15:0]  d_in;
  input          cs;
  input   [7:0]  addr; // 8 LSB from j1_io_addr
  input          rd;
  input          wr;
  output [15:0]  d_out;

//------------------------------------ regs and wires-------------------------------

dualport_RAM dlptRAM (.clk(clk), .d_in(d_in), .d_out(d_out), .addr(addr), .rd(cs && rd), .wr(cs && wr) );



endmodule
