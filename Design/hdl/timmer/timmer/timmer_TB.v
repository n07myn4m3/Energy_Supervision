// `timescale 10ns / 1ps  // Condiciones de simulacion normales
`timescale 1ns / 1ps      // Condiciones de simulacion para comparar los tiempos con el J1
`define SIMULATION

module timmer_TB;
    wire  t_timmer;
    reg   t_Clk, t_Reset;

    parameter stop_time = 1000000;

    timmer DIV1(.ClkOut(t_timmer), .Clk(t_Clk), .Reset(t_Reset));
    
    initial # stop_time $finish;
        initial begin: TEST_STIMULUS1
            t_Clk = 1'b0;
            t_Reset = 1'b1;
        #2
            t_Reset = 1'b0;
    end
    
    always
            #1 t_Clk = ~t_Clk;
    
    initial # stop_time $finish;
        initial begin: TEST_WAVE
        $dumpfile("timmer_TB.vcd");
        $dumpvars(-1, DIV1);
    end

endmodule

