( Hardware port assignments )

h# FF00 constant mult_a  \ no cambiar estos tres
h# FF02 constant mult_b  \ hacen parte de otras
h# FF04 constant mult_p  \ definiciones

\ memory map multiplier:
h# 6700 constant multi_a	
h# 6702 constant multi_b
h# 6704 constant multi_init
h# 6706 constant multi_done
h# 6708 constant multi_pp_high
h# 670A constant multi_pp_low

\ memory map divider:
h# 6800 constant div_a		
h# 6802 constant div_b
h# 6804 constant div_init
h# 6806 constant div_done
h# 6808 constant div_c

\ memory map uart:
h# 6900 constant uart_busy    	\ para lectura de uart (uart_busy)
h# 6902 constant uart_data    	\ escritura de datos que van a la uart
h# 6904 constant led     	      \ led-independiente , se lo deja dentro del mapa de memoria de la uart

\ memory map gpout:
h# 6000 constant gp_out0
h# 6001 constant gp_out1

\ memory map gpin:
h# 6100 constant gp_in0
h# 6101 constant gp_in1

\ memory map i2c:
 h# 6200 constant i2c_ena
 h# 6202 constant i2c_rw
 h# 6204 constant i2c_addr
 h# 6206 constant i2c_data_wr
 h# 6208 constant i2c_busy
 h# 620A constant i2c_ack_error
 h# 620B constant i2c_data_rd

\ memory map bin2bcd:
h# 6300 constant bin2bcd_enable
h# 6302 constant bin2bcd_data
h# 6304 constant bin2bcd_tho
h# 6306 constant bin2bcd_hun
h# 6308 constant bin2bcd_ten
h# 630A constant bin2bcd_uni
h# 630C constant bin2bcd_done

\ memory map division32:
h# 6400 constant div2_go
h# 6402 constant div2_dividend_pp_high    
h# 6404 constant div2_dividend_pp_low 
h# 6406 constant div2_divisor_pp_high     
h# 6408 constant div2_divisor_pp_low     
h# 640A constant div2_done
h# 640C constant div2_quotient_pp_high 
h# 640E constant div2_quotient_pp_low 

\ memory map timmer:
h# 6500 constant timmer_ClkOut


\ ram
h# 7000 constant ram0
h# 7001 constant DtMSB
h# 7002 constant DtLSB
