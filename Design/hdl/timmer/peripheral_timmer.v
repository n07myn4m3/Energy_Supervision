module peripheral_timmer(clk , rst , d_in , cs , addr , rd , wr, d_out );
  
  input             clk;
  input             rst;
  input      [15:0] d_in;
  input             cs;
  input       [3:0] addr; // 4 LSB from j1_io_addr
  input             rd;
  input             wr;
  output reg [15:0] d_out;


//------------------------------------ regs and wires-------------------------------

   reg  s; 	//selector mux_4  and write registers

//Salidas de control
	wire  ClkOut; 

	//------------------------------------ regs and wires-------------------------------

	always @(*) begin//------address_decoder------------------------------
		case (addr)
			4'h0:	begin s = (cs && rd) ? 1'b1 : 1'b0 ;end
			default:begin s = 1'b0 ; end
		endcase
	end//------------------address_decoder--------------------------------

	always @(negedge clk) begin//-----------------------mux_4 :  multiplexa salidas del periferico
		case (s)
			1'b1: 		d_out 	 = ClkOut;
			default: 	d_out  	 = 16'd0 ;
		endcase
	end//-----------------------------------------------mux_4


timmer timmeruut(.Clk(clk),.Reset(rst),.ClkOut(ClkOut));

endmodule
