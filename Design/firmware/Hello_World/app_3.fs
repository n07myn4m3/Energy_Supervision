\ Prueba escritura lectura memria
: delay_1ms
d# 8334 begin d# 1 - dup d# 0 = until drop	\ 100MHz
\ d# 4167 begin d# 1 - dup d# 0 = until	\ 50MHz
;

: delay_ms
d# 0 do delay_1ms loop
;

: delay_10us
d# 40 begin d# 1 - dup d# 0 = until drop	\ 100MHz
\ d# 20 begin d# 1 - dup d# 0 = until	\ 50MHz
;

: emit-i2c	\ hecho por el profe
    begin i2c_busy @ 0= until
    i2c_data_wr !
;

: main 
delay_10us 
h# 1A i2c_addr !     \ 0011010
h# 4F i2c_data_wr !  \ 01001111 
d# 0 i2c_rw !        \ vamoh a escribir
d# 1 i2c_ena !       \ 00000100
delay_10us
h# 04 emit-i2c
delay_10us
h# 03 emit-i2c
\ delay_10us 
\ d# 50 accumulated !
\ accumulated gp_out1 !
begin
d# 1 gp_out0 !
delay_10us 
d# 0 gp_out0 !
delay_10us
again
;
