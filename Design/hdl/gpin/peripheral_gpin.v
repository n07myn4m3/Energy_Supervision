module peripheral_gpin(clk , rst, cs , addr, rd, d_out, gp_in0, gp_in1 );
  
  	input clk;
  	input rst;
  	input cs;
  	input [3:0]addr; // 4 LSB from j1_io_addr
  	input rd;
  	output reg 	[15:0]	d_out;
	input 		[15:0]	gp_in0, gp_in1;

	//------------------------------------ regs and wires-------------------------------

	reg [1:0] s; 	//selector mux_4  and write registers

	//------------------------------------ regs and wires-------------------------------

	always @(*) begin//------address_decoder------------------------------
		case (addr)
			4'h0:	begin s = (cs && rd) ? 2'b01 : 2'b00 ;end
			4'h1:	begin s = (cs && rd) ? 2'b10 : 2'b00 ;end
			default:begin s = 2'b00 ; end
		endcase
	end//------------------address_decoder--------------------------------

	always @(negedge clk) begin//-----------------------mux_4 :  multiplexa salidas del periferico
		case (s)
			2'b01: 		d_out 	 = gp_in0 ;
			2'b10: 		d_out    = gp_in1 ;
			default: 	d_out  	 = 16'd0 ;
		endcase
	end//-----------------------------------------------mux_4

endmodule
