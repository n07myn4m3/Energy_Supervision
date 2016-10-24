module peripheral_bin2bcd(clk , rst , d_in , cs , addr , rd , wr, d_out );
  
  input clk;
  input rst;
  input [15:0]d_in;
  input cs;
  input [3:0]addr; // 4 LSB from j1_io_addr
  input rd;
  input wr;
  output reg [15:0] d_out;

//------------------------------------ regs and wires-------------------------------

reg [6:0] s; 	//selector mux_4  and write registers

//Entradas de control
	reg enable;//enable

//Salidas de control
	wire  done;//done (ok, send data)

//Entradas de datos
	reg [13:0] data;//data (receve the data in binary for transform)

//Salida de datos
	wire [3:0] tho;//wire data value thousant
	wire [3:0] hun;//wire data value hundred
	wire [3:0] ten;//wire data value ten
	wire [3:0] uni;//wire data value unit

//------------------------------------ regs and wires-------------------------------




always @(*) begin//---address_decoder--------------------------
case (addr)
4'h0:begin s = (cs && wr) ? 7'b0000001 : 7'b0000000 ;end //enable
4'h2:begin s = (cs && wr) ? 7'b0000010 : 7'b0000000 ;end //data     

4'h4:begin s = (cs && rd) ? 7'b0000100 : 7'b0000000 ;end //tho
4'h6:begin s = (cs && rd) ? 7'b0001000 : 7'b0000000 ;end //hun
4'h8:begin s = (cs && rd) ? 7'b0010000 : 7'b0000000 ;end //ten
4'hA:begin s = (cs && rd) ? 7'b0100000 : 7'b0000000 ;end //uni
4'hC:begin s = (cs && rd) ? 7'b1000000 : 7'b0000000 ;end //done
default:begin s = 7'b0000000 ; end
endcase
end//-----------------address_decoder--------------------------




always @(negedge clk) begin//-------------------- escritura de registros 

enable  = (s[0]) ? d_in[0] : enable;	//Write Registers
data    = (s[1]) ? d_in[13:0] : data;	//Write Registers
end//------------------------------------------- escritura de registros 




always @(negedge clk) begin//-----------------------mux_4 :   multiplexa salidas del periferico
case (s[6:2])
5'b00001: d_out = tho ;   
5'b00010: d_out = hun ;
5'b00100: d_out = ten ;
5'b01000: d_out = uni ;
5'b10000: d_out = done ;    
default: d_out   = 0 ;
endcase

end//-------------------------------------mux_4

bin2bcd bin2bcduut(.clkin(clk),.enable(enable),.reset(rst),.data(data),.tho(tho),.hun(hun),.ten(ten),.uni(uni),.done(done));

endmodule
