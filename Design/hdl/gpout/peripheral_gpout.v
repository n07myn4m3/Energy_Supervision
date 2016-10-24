module peripheral_gpout(clk , rst , d_in , cs , addr, wr, gp_out0, gp_out1 );
  
  	input clk;
  	input rst;
  	input [15:0]d_in;
  	input cs;
  	input [3:0]addr; // 4 LSB from j1_io_addr
  	input wr;
	output reg [15:0]gp_out0, gp_out1;

	//------------------------------------ regs and wires-------------------------------

	reg [1:0] s; 	//selector mux_4  and write registers

	//------------------------------------ regs and wires-------------------------------

	always @(*) begin//------address_decoder------------------------------
		case (addr)
			4'h0:	begin s = (cs && wr) ? 2'b01 : 2'b00 ;end
			4'h1:	begin s = (cs && wr) ? 2'b10 : 2'b00 ;end
			default:begin s = 2'b00 ; end
		endcase
	end//------------------address_decoder--------------------------------

	always @(negedge clk, posedge rst) begin//-------------------- escritura de registros 
		if(rst) begin
			gp_out0 = 16'd0;
			gp_out1 = 16'd0;
		end
		else begin
			gp_out0 = (s[0]) ? d_in : gp_out0;	//Write Registers
			gp_out1 = (s[1]) ? d_in : gp_out1;	//Write Registers
		end
	end//------------------------------------------- escritura de registros

endmodule
