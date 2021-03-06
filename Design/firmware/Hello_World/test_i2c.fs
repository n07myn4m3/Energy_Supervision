VARIABLE Rshunt
VARIABLE Busv
VARIABLE CurrentD
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
   d# 40 begin d# 1 - dup d# 0 = until drop
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
    h# 40 ADDR ! 
;

: emit-i2c	\ hecho por el profe
    delay_i2c
    begin i2c_busy @ d# 0 = until 
    i2c_data_wr !
;

: reset_i2c
    begin i2c_busy @ d# 0 = until 
    d# 0 i2c_ena !
    delay_i2c
    d# 1 i2c_ena !
;

: turn-off
    begin i2c_busy @ d# 0 = until 
    d# 0 i2c_ena !
    delay_i2c
;

: wr2-i2c
    begin i2c_busy @ d# 0 = until 
    ADDR dup @ i2c_addr ! drop
    i2c_data_wr !
    d# 0 i2c_rw !
    d# 1 i2c_ena !
    delay_i2c
    begin i2c_busy @ d# 0 = until 
    i2c_data_wr !
    delay_i2c
    begin i2c_busy @ d# 0 = until
    i2c_data_wr !
    delay_i2c
;

: wr1-i2c
    begin i2c_busy @ d# 0 = until 
    ADDR dup @ i2c_addr ! drop
    i2c_data_wr !
    d# 0 i2c_rw !
    d# 1 i2c_ena !
    delay_i2c
;

: wt-readi2c
    con-ADDR
    ADDR dup @ i2c_addr ! drop
    d# 1 i2c_ena !   
    begin i2c_busy @ d# 0 = until
    d# 1 i2c_rw !
    delay_i2c
    begin i2c_busy @ d# 0 = until
    d# 0 i2c_rw !
    delay_i2c
;

: mode-readi2c
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
    begin i2c_busy @ d# 0 = until
    i2c_data_rd @
;
    
: save-i2c 
    delay_i2c 
    con-ADDR
    ADDR dup @ i2c_addr ! drop
    d# 1 i2c_ena !    
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
    or dup INAR !
    INAR dup @ gp_out1 ! drop
    INAR dup @ emit-uart
;


: read-shuntV
;   
 
: calcular-t
;       

: main

\  begin

\    SL     O     P     M     E     I     T      v      :
  h# 10 h# 4F h# 50 h# 4D h# 45 h# 49 h# 54  h# 56 h# 3A  d# 9
  d# 0 
  do  
    emit-uart
  loop

\ Indica que va a realizar la lectura del registro de voltaje shunt
    con-ADDR
    h# 01  
    wr1-i2c
    turn-off
    delay_1ms
\ Lee el voltaje shunt y prepara la lectura del voltaje en el bus   
    wt-readi2c
    h# 02  
    wr1-i2c
    turn-off
    delay_1ms
\ Lee el voltaje en el bus, escribe en el registro de calibracion y prepara la lectura de la corriente
    wt-readi2c
    h# 00 h# 10 h# 05 
    wr2-i2c
    reset_i2c
    h# 04  
    wr1-i2c
    turn-off
    delay_1ms
\  Realiza la lectura de la corriente
    save-i2c
    turn-off
\  again
;
