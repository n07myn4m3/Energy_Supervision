`timescale 10ns / 10ps
`define SIMULATION

module division32_TB;

/* 
-----------------------------------------------
Descripcion del modulo a probar
-----------------------------------------------
                   ____________
    go       ---->|            |----> quotient
    dividend ---->|            |
    divisor  ---->| division32 |
                  |            |
    rst      ---->|            |
    clk      ---->|>           |----> done
                  |____________|

*/


    reg         rst = 1;
    reg  [31:0] dividend;
    reg  [31:0] divisor;
    reg         go  = 0;
    wire        done;
    wire [31:0] quotient;

 always@(*) begin
		if (done)
			begin
			  # 50  rst = 0;
				     go  = 1; 
				     dividend = 32'd67000;
				     divisor  = 32'd23;
           # 10  go = 0;
			end
	end

  initial begin
     $dumpfile("division32_TB.vcd");
     $dumpvars(-1,div1);

     # 10  rst = 0;
           go  = 1; 
           dividend = 32'd100000;
           divisor  = 32'd256; 
     # 10  go = 0;

     # 1000 $finish;
  end

reg clk = 0;
  always #5 clk = !clk;



  division32 div1 (.clk(clk), .rst(rst), .dividend(dividend), .divisor(divisor), .go(go), .done(done), .quotient(quotient));

  initial
     $monitor("At time = %t, clk %b = DIV = %d, DIS = %d , COCIENTE = %d, FIN = %b, RES = %b",
              $time, clk, dividend, divisor, quotient, done, rst);
endmodule // test
