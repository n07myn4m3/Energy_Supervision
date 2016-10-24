/* 
========================================================================
                   ____________
    go       ---->|            |----> quotient
    dividend ---->|            |
    divisor  ---->| division32 |
                  |            |
    rst      ---->|            |
    clk      ---->|>           |----> done
                  |____________|

========================================================================
*/
module peripheral_division32(clk , rst , d_in , cs , addr , rd , wr, d_out );
  
  input             clk;
  input             rst;
  input      [15:0] d_in;
  input             cs;
  input       [3:0] addr; // 4 LSB from j1_io_addr
  input             rd;
  input             wr;
  output reg [15:0] d_out;

//------------------------------------ regs and wires-------------------------------

reg [7:0] s; 	//selector mux_4  and write registers

//Entradas de control
    reg               go;
//Entradas de datos
    reg        [31:0] dividend;
    reg        [31:0] divisor;
//Salidas de control
    wire        done;
//Salidas de datos
    wire       [31:0] quotient;

//------------------------------------ regs and wires-------------------------------

always @(*) begin//---address_decoder--------------------------
case (addr)
4'h0:begin s = (cs && wr) ? 8'b00000001 : 8'b00000000 ;end //go
4'h2:begin s = (cs && wr) ? 8'b00000010 : 8'b00000000 ;end //dividend [31:16]   
4'h4:begin s = (cs && wr) ? 8'b00000100 : 8'b00000000 ;end //dividend [15:0]
4'h6:begin s = (cs && wr) ? 8'b00001000 : 8'b00000000 ;end //divisor  [31:16]   
4'h8:begin s = (cs && wr) ? 8'b00010000 : 8'b00000000 ;end //divisor  [15:0]   

4'hA:begin s = (cs && rd) ? 8'b00100000 : 8'b00000000 ;end //done
4'hC:begin s = (cs && rd) ? 8'b01000000 : 8'b00000000 ;end //quotient [31:16]
4'hE:begin s = (cs && rd) ? 8'b10000000 : 8'b00000000 ;end //quotient [15:0]

default:begin s = 8'b00000000 ; end
endcase
end//-----------------address_decoder--------------------------




always @(negedge clk) begin//-------------------- escritura de registros 

go               = (s[0]) ? d_in[0] : go;	               //Write Registers
dividend [31:16] = (s[1]) ? d_in    : dividend [31:16];	//Write Registers
dividend [15:0]  = (s[2]) ? d_in    : dividend [15:0]; 
divisor  [31:16] = (s[3]) ? d_in    : divisor  [31:16];	//Write Registers
divisor  [15:0]  = (s[4]) ? d_in   : divisor  [15:0]; 

end//------------------------------------------- escritura de registros 




always @(negedge clk) begin//-----------------------mux_4 :   multiplexa salidas del periferico
case (s[7:5])
3'b001: d_out = done;   
3'b010: d_out = quotient [31:16];
3'b100: d_out = quotient  [15:0];   
default: d_out   = 0 ;
endcase

end//-------------------------------------mux_4

division32 division32uut(.clk(clk), .rst(rst), .dividend(dividend), .divisor(divisor), .go(go), .done(done), 
                         .quotient(quotient));

endmodule
