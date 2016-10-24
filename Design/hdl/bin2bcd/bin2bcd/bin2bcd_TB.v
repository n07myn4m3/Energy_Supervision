module bin2bcd_TB;
/*

RECOMENDACIONES 
Las entradas son registros (reg) las salidas son cables (wires).

ESQUEMA DEL MODULO
                 ________
    data   ---->|       |----> uni
    enable ---->|       |----> ten
    reset  ---->|       |----> hun
                |       |----> tho
                |       |
    clkin  ---->|>      |----> done
                |_______|

*/




    reg  [13:0] data;
    wire [3:0] tho;
    wire [3:0] hun;
    wire [3:0] ten;
    wire [3:0] uni;


    reg enable;
    reg reset;
		wire  done;

  initial begin
    clkin=0; data=14'd0; reset  = 1; enable = 0;
  end


  initial begin
     $dumpfile("bin2bcd_TB.vcd");
     $dumpvars(-1,uut);

     # 5   data = 14'd9999;
           reset  = 1'b0; 
           enable = 1'b1; 
     # 15  enable = 1'b0;
 
     
     # 400  data = 14'd3421;
           enable = 1'b1;

     # 15  enable = 1'b0;

     # 400 $finish;


  end

reg clkin = 0;
  always #5 clkin = !clkin;

  bin2bcd uut (.clkin(clkin), .enable(enable), .reset(reset), .data(data), .tho(tho), .hun(hun), .ten(ten), .uni(uni), .done(done));

  initial
     $monitor("At time = %t, clkin = %b, enable = %b, reset = %b, data = %b, tho = %b, hun = %b, ten = %b, uni= %b, done = %b",
              $time, clkin, enable, reset, data, tho, hun, ten, uni, done);
endmodule // test


