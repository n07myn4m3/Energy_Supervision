VARIABLE Rshunt
VARIABLE Busv
VARIABLE Current
VARIABLE ADDR
VARIABLE data
VARIABLE MSB
VARIABLE LSB
VARIABLE INAR

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
    d# 3 d# 0 do delay_10us loop
;

: delay_change
    d# 10 d# 0 do delay_10us loop
;

: con-ADDR
    h# 15 ADDR ! 
;

: emit-i2c	\ hecho por el profe
    delay_i2c
    begin i2c_busy @ d# 0 = until 
    i2c_data_wr !
;

: read-i2c 
    delay_i2c 
    con-ADDR
    ADDR dup @ i2c_addr ! drop   
    begin i2c_busy @ d# 0 = until
    d# 1 i2c_rw !
    delay_i2c
    begin i2c_busy @ d# 0 = until
    i2c_data_rd @ 
    delay_i2c
    delay_i2c
    d# 0 i2c_rw !
    begin i2c_busy @ d# 0 = until
    d# 8 lshift 
    i2c_data_rd @
    or dup gp_out1 !
    INAR !  
;

: init 
    begin i2c_busy @ d# 0 = until 
    ADDR dup @ i2c_addr ! drop
    h# 4F i2c_data_wr !
    d# 0 i2c_rw !
    d# 1 i2c_ena !
;

: con-rshunt
    delay_i2c
    h# A2
    begin i2c_busy @ d# 0 = until 
    i2c_data_wr !
    delay_i2c
    h# 25
    begin i2c_busy @ d# 0 = until
    i2c_data_wr ! 
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
    Rshunt dup @ i2c_data_wr ! d# 2 drop
;
: calcular-t
;        

: concatenar
   d# 242 MSB !  \ Si los declaro adentro si funciona
   MSB dup @ swap drop
   d# 8 lshift 
\   d# 163 LSB !  
   LSB dup @ swap drop
   or INAR ! 
   INAR dup @ gp_out1 ! drop    
;

: main 
\    d# 242 MSB ! \ 1111 0010 Si los declaro asi solo alcanza a leer a uno de los dos
\   MSB dup @ gp_out1 ! drop
    d# 163 LSB !  \ 1010 0011
\   LSB dup @ gp_out1 ! drop
   concatenar
;
