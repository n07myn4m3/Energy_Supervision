module dualport_RAM(clk, d_in, d_out, addr, rd, wr);
  
  input clk;

  input [15:0]d_in;
  output reg [15:0]d_out=0;
  input [7:0]addr; // 8 LSB from address
  input rd;
  input wr;

  // Declare the RAM variable
  reg [15:0] ram [255:0]; // 256-bit x 8-bit RAM


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
