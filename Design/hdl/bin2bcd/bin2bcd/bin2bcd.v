/* 

DESCRIPCION DEL MODULO
Este modulo debe recibir un numero entero de 14 bits y debera desfragmentarlo
en sus respectivas unidades, decenas, centesimas y milesimas.

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

module bin2bcd (clkin,enable,reset,data,tho,hun,ten,uni,done);

//Entradas de control
	input clkin;//clock
	input enable;//enable
	input reset;//reset

//Salidas de control
	output reg  done;//done (ok, send data)

//Entradas de datos
	input [13:0] data;//data (receve the data in binary for transform)

//Salida de datos
	output [3:0] tho;//output data value thousant
	output [3:0] hun;//output data value hundred
	output [3:0] ten;//output data value ten
	output [3:0] uni;//output data value unit

//Registros empleados por el modulo
	reg [3:0]  tmp     = 5'b1111;
	reg        bol     = 1'b1; 
	reg        init    = 1'b1; 
	reg [29:0] finaldd = 30'd0;


	always @(posedge clkin) begin //begin tranform data
		if(reset) begin //with reset, init values
			finaldd <= 30'd0;
			tmp     <= 5'b1111; 
			done    <= 1'b0;
		end
		if (enable && ~reset) begin // with enable, save data in variable of transform and init asign false (1'b0)
			init    <= 1'b1;
		end		
		else begin //without reset transform data
			if(init == 1'b1) begin
					finaldd <= 30'd0 + data;
					init    <= 1'b0;
       	  bol     <= 1'b1;
       	  done    <= 1'b0;
					tmp     <= 5'b0000; 
			end
			else begin //transform finaldd (final-double-dable)
				if(tmp<=4'b1110)begin //transform finaldd (final-double-dable), bol = if shift, ~double = if +3, in tmp = 14, done
					if (tmp==4'b1110) begin
						done <= 1'b1;
					end		
					else if(bol == 1'b1) begin
					finaldd <= finaldd<<1'b1;
					tmp <= tmp + 1'b1;
					bol <= 1'b0;
					end
					else begin
						if(finaldd[29:26] > 3'b100) begin //for tho
								finaldd[29:26] <= finaldd[29:26] + 2'b11;
						end
						if(finaldd[25:22] > 3'b100) begin //for hun
								finaldd[25:22] <= finaldd[25:22] + 2'b11;
						end
						if(finaldd[21:18] > 3'b100) begin //for ten
								finaldd[21:18] <= finaldd[21:18] + 2'b11;
						end
						if(finaldd[17:14] > 3'b100) begin //for uni
								finaldd[17:14] <= finaldd[17:14] + 2'b11;
						end
						bol <= 1'b1; 
					end//else
				end//tmp
			end//else
		end//else
	end//always
	assign tho = finaldd[29:26]; //assign values in outputs
	assign hun = finaldd[25:22];
	assign ten = finaldd[21:18];
	assign uni = finaldd[17:14];
endmodule
