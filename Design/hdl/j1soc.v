//VERSION FUNCIONAL
module j1soc#(
              //parameter   bootram_file     = "../../firmware/hello_world/j1.mem"    // For synthesis            
              parameter   bootram_file     = "../firmware/Hello_World/j1.mem",       // For simulation  
              parameter clkFreq = 100000000,
              parameter baudRateUart = 115200  
  )(
   uart_tx, ledout, gp_out0, gp_out1, gp_in0, gp_in1,
   sys_clk_i, sys_rst_i, sda, scl
   );

   input sys_clk_i, sys_rst_i;
   inout sda, scl;
   output uart_tx;
   output ledout;
   output [15:0] gp_out0, gp_out1;
   input [15:0] gp_in0, gp_in1;


//------------------------------------ regs and wires-------------------------------

   wire                 j1_io_rd;//********************** J1
   wire                 j1_io_wr;//********************** J1
   wire                 [15:0] j1_io_addr;//************* J1
   reg                  [15:0] j1_io_din;//************** J1
   wire                 [15:0] j1_io_dout;//************* J1
 
   reg [1:10]cs;  // CHIP-SELECT

   wire			[15:0] mult_dout;       
   wire			[15:0] div_dout;
   wire        [15:0] gpin1_dout;
   wire			[15:0] uart_dout;	// misma señal que uart_busy from uart.v
   wire			[15:0] dp_ram_dout;
   wire        [15:0] i2c_dout;
   wire        [15:0] bin2bcd_dout;
   wire        [15:0] division32_dout;
   wire        [15:0] timmer_dout;

//------------------------------------ regs and wires-------------------------------

  j1 #(bootram_file)  cpu0(sys_clk_i, sys_rst_i, j1_io_din, j1_io_rd, j1_io_wr, j1_io_addr, j1_io_dout);

  peripheral_mult   per_m ( .clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[1]), 
                              .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(mult_dout) );

  peripheral_div    per_d ( .clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[2]), .addr(j1_io_addr[3:0]), 
                              .rd(j1_io_rd), .wr(j1_io_wr), .d_out(div_dout));

  peripheral_uart   #(.clkFreq(clkFreq), .baudRate(baudRateUart))   
                    per_u ( .clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[3]), .addr(j1_io_addr[3:0]), 
                              .rd(j1_io_rd), .wr(j1_io_wr), .d_out(uart_dout), .uart_tx(uart_tx), .ledout(ledout));

  dpRAM_interface    dpRm(   .clk(sys_clk_i), .d_in(j1_io_dout), .cs(cs[4]), .addr(j1_io_addr[7:0]), .rd(j1_io_rd), 
                              .wr(j1_io_wr), .d_out(dp_ram_dout));

  peripheral_gpout   gpout1( .clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[5]), .addr(j1_io_addr[3:0]), 
                              .wr(j1_io_wr), .gp_out0(gp_out0), .gp_out1(gp_out1));

  peripheral_gpin    gpin1(  .clk(sys_clk_i), .rst(sys_rst_i), .cs(cs[6]), .addr(j1_io_addr[3:0]), .rd(j1_io_rd),      
                              .d_out(gpin1_dout), .gp_in0(gp_in0), .gp_in1(gp_in1));

  peripheral_i2c     per_i2c( .clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[7]), .addr(j1_io_addr[3:0]), 
                              .rd(j1_io_rd), .wr(j1_io_wr), .d_out(i2c_dout), .sda(sda), .scl(scl));

  peripheral_bin2bcd per_bin2bcd ( .clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[8]), 
                                    .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(bin2bcd_dout));

  peripheral_division32 per_division32 ( .clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[9]), 
                                    .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(division32_dout));

  peripheral_timmer per_timmer (.clk(sys_clk_i) , .rst(sys_rst_i) , .d_in(j1_io_dout) , .cs(cs[10]) , .addr(j1_io_addr[3:0]) , .rd(j1_io_rd) , .wr(j1_io_wr), .d_out(timmer_dout) );



  // ============== Chip_Select (Addres decoder) ========================  // se hace con los 8 bits mas significativos de j1_io_addr
  always @*
  begin
      case (j1_io_addr[15:8])	// direcciones - chip_select
        8'h67:    cs= 10'b1000000000; 	   //mult
        8'h68:    cs= 10'b0100000000;		//div
        8'h69:    cs= 10'b0010000000;		//uart
        8'h70:    cs= 10'b0001000000;		//dp_ram
        8'h60:    cs= 10'b0000100000;     //gpout
        8'h61:    cs= 10'b0000010000;     //gpin
        8'h62:    cs= 10'b0000001000;     //i2c
        8'h63:    cs= 10'b0000000100;     //bin2bcd  
        8'h64:    cs= 10'b0000000010;     //division32  
        8'h65:    cs= 10'b0000000001;     //timmer
        default:  cs= 10'b0000000000;
      endcase
  end
  // ============== Chip_Select (Addres decoder) ========================  //




  // ============== MUX ========================  // se encarga de lecturas del J1
  always @*
  begin
      case (cs)
        10'b1000000000: j1_io_din = mult_dout;       //mult
        10'b0100000000: j1_io_din = div_dout;        //div
        10'b0010000000: j1_io_din = uart_dout;       //uart
        10'b0001000000: j1_io_din = dp_ram_dout;     //dp_ram
        10'b0000100000: j1_io_din = {16{1'bX}};      //gpout
        10'b0000010000: j1_io_din = gpin1_dout;      //gpout
        10'b0000001000: j1_io_din = i2c_dout;        //i2c
        10'b0000000100: j1_io_din = bin2bcd_dout;    //bin2bcd
        10'b0000000010: j1_io_din = division32_dout; //division32
        10'b0000000001: j1_io_din = timmer_dout; //timmer
        default:   j1_io_din = {16{1'bX}};
      endcase
  end
 // ============== MUX ========================  // 

endmodule // top
