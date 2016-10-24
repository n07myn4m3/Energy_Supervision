module peripheral_i2c(clk , rst, d_in , cs , addr , rd , wr, d_out, sda, scl);
  
  input clk;
  input rst;
  input [15:0]d_in;
  input cs;
  input [3:0]addr; // 4 LSB from j1_io_addr
  input rd;
  input wr;
  output reg [15:0]d_out;
  inout sda;
  inout scl;


/*
                   ______________
 clk     -------->|              |                    |
 rst     -------->|              |                    |CONTROL SIGNALS 
 cs      -------->|              |                    |
                  |peripheral_i2c|
 wr      -------->|              |--------> d_out     |
 addr    -------->|              |<-------> sda       |DATA SIGNALS
 rd      -------->|______________|<-------> scl       |

*/



//------------------------------------ regs and wires-------------------------------

reg [6:0] s; 	//selector mux_4  and write registers

reg       ena     = 0;
reg       rw      = 0;
reg [6:0] add_r   = 0; //I2C Addres
reg [7:0] data_wr = 0; // I2C Data

wire busy;
wire ack_error;
wire [7:0] data_rd;	//datos lectura I2C


//------------------------------------ regs and wires-------------------------------




always @(*) begin//------address_decoder------------------------------
case (addr)
4'h0:begin s = (cs && wr) ? 7'b0000001 : 7'b0000000 ;end //ena
4'h2:begin s = (cs && wr) ? 7'b0000010 : 7'b0000000 ;end //rw
4'h4:begin s = (cs && wr) ? 7'b0000100 : 7'b0000000 ;end //addr [6:0]
4'h6:begin s = (cs && wr) ? 7'b0001000 : 7'b0000000 ;end //data_wr [7:0]

4'h8:begin s = (cs && rd) ? 7'b0010000 : 7'b0000000 ;end //busy
4'ha:begin s = (cs && rd) ? 7'b0100000 : 7'b0000000 ;end //ack_error
4'hb:begin s = (cs && rd) ? 7'b1000000 : 7'b0000000 ;end //data_rd

default:begin s = 7'b0000000 ; end
endcase
end//------------------address_decoder--------------------------------




always @(negedge clk) begin//-------------------- escritura de registros 

ena      = (s[0]) ? d_in[0] : ena;
rw       = (s[1]) ? d_in[0] : rw;
add_r    = (s[2]) ? d_in : add_r;
data_wr  = (s[3]) ? d_in : data_wr;

end//------------------------------------------- escritura de registros




always @(negedge clk) begin//-----------------------mux_4 :  multiplexa salidas del periferico
case (s[6:4])

3'b001: d_out    = busy;
3'b010: d_out    = ack_error;
3'b100: d_out    = data_rd;
default: d_out   = 0 ;
endcase

end//-----------------------------------------------mux_4



i2c_master i2cuut (.clk(clk), .reset(rst), .ena(ena), .addr(add_r), .rw(rw), .data_wr(data_wr), .busy(busy), .data_rd(data_rd), .ack_error(ack_error), .sda(sda), .scl(scl));


endmodule
