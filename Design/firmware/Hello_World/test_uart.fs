: delay_1ms
   d# 8334 begin d# 1 - dup d# 0 = until drop	\ 100MHz
\ d# 4167 begin d# 1 - dup d# 0 = until	\ 50MHz
;

: delay_nms
   d# 0 do delay_1ms loop
;

: delay_10us
   d# 40 begin d# 1 - dup d# 0 = until drop	\ 100MHz
;

: delay_n_10us
   d# 0 do delay_10us loop
;

: delay_i2c
    d# 4 d# 0 do delay_10us loop
;

: delay_change
    d# 10 d# 0 do delay_10us loop
;

VARIABLE Rshunt
VARIABLE Busv
VARIABLE Current
VARIABLE ADDR
VARIABLE data


: con-ADDR
  h# 15 ADDR ! 
;

: emit-i2c	\ hecho por el profe
    delay_i2c
    begin i2c_busy @ d# 0 = until 
    i2c_data_wr !
;

: read-i2c
    delay_change
    d# 1 i2c_rw !
    ADDR dup @ i2c_addr ! drop  
    begin i2c_busy @ d# 0 = until
    dup i2c_data_rd @ ram0 !
    delay_i2c
    begin i2c_busy @ d# 0 = until
    dup i2c_data_rd @ ram0 !
     
;

: init 
    begin i2c_busy @ d# 0 = until drop
    ADDR dup @ i2c_addr ! drop
    h# 4F i2c_data_wr !
    d# 0 i2c_rw !
    d# 1 i2c_ena !
;

: con-rshunt
    delay_i2c
    h# A2 Rshunt !
    delay_i2c
    begin i2c_busy @ d# 0 = until 
    Rshunt dup @ i2c_data_wr ! drop
    h# 18 Rshunt !
    delay_i2c
    begin i2c_busy @ d# 0 = until 
    Rshunt dup @ i2c_data_wr ! drop
; 


: con-busv
    delay_i2c
    h# 25 Rshunt !
    delay_i2c
    begin i2c_busy @ d# 0 = until 
    Rshunt dup @ i2c_data_wr ! drop
    h# 65 Rshunt !
    delay_i2c
    begin i2c_busy @ d# 0 = until 
    Rshunt dup @ i2c_data_wr ! drop
;

: main 
	begin
      d# 255 gp_out0 !
		d# 41 emit-uart
      d# 0 gp_out0 !
      d# 42 emit-uart
		d# 200 delay_nms
	again
;
