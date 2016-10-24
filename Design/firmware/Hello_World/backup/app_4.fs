VARIABLE Rdor
VARIABLE ADDR
VARIABLE INAR
VARIABLE M_CURRENT
\ VARIABLE DtMSB   \ SE DECLARARON EN RAM
\ VARIABLE DtLSB   \ SE DECLARARON EN RAM
VARIABLE ACCUM   \ NUEVO

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
\ Esta funcion se emplea cuando quiero indicar que voy a leer informacion del modulo por ende 
\ debo indicar la direccion del modulo y luego la direccion interna del modulo 
: wr1-i2c
    begin i2c_busy @ d# 0 = until   \ Espera a que el modulo este disponible
    \ ADDR @ i2c_addr ! Esto seria lo ideal pero el j1 no lo permite
    ADDR dup @ i2c_addr ! drop      \ Envia la direccion del modulo
    \ ------------------------------------------------------------------------------------------------------------ 
    \ | PASO 1           | | PASO 2           | | PASO 3               | | PASO 4           | | PASO 5           |
    \ ------------------------------------------------------------------------------------------------------------
    \ | direccion (addr) | | h# 40            | | direccion (i2c_addr) | | direccion (addr) | | h# input_funtion |
    \ | direccion (addr) | | direccion (addr) | | h# 40                | | h# input_funtion | |                  |
    \ | h# input_funtion | | h# input_funtion | | direccion (addr)     | |                  | |                  |
    \ |                  | |                  | | h# input_funtion     | |                  | |                  |
    \ ------------------------------------------------------------------------------------------------------------
    \ | ADDR DUP         | | @                | |  i2c_addr            | | !                | | drop             |  
    \ ------------------------------------------------------------------------------------------------------------ 
    i2c_data_wr !
    \ --------------------------------------------------------------------
    \ | PASO 5           | | PASO 6                 | | PASO 7           |
    \ --------------------------------------------------------------------
    \ | h# input_funtion | | direccion (i2c_data_wr)| |                  | 
    \ |                  | | h# input_funtion       | |                  | 
    \ |                  | |                        | |                  | 
    \ |                  | |                        | |                  | 
    \ --------------------------------------------------------------------
    \ | estado inicial   | | i2c_data_wr            | | !                |   
    \ --------------------------------------------------------------------
    d# 0 i2c_rw !  \ Escribe cero en el pin rw indicando que va a escribir
    delay_i2c      \ Retraso reglamentario para que no se repita la lectura de los busys
    d# 1 i2c_ena ! \ escribe uno en el pin ena indicando que el modulo debe iniciar operaciones
    delay_i2c      \ Retraso reglamentario para que no se repita la lectura de los busys 
;

: wt-readi2c
    con-ADDR
    ADDR dup @ i2c_addr ! drop
    i2c_data_wr !
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
    d# 0 i2c_ena !
\    turn-off
    d# 8 lshift 
    i2c_data_rd @
    or dup INAR !
    INAR dup @ gp_out1 ! drop
    INAR dup @ emit-uart drop
;

: multiplicar
    multi_a !
    multi_b ! drop
    d# 1 multi_init !
    begin multi_done @ d# 1 = until
    d# 0 multi_init !
;

: dividir
    div2_dividend_pp_high !
    div2_dividend_pp_low !
    div2_divisor_pp_high !
    div2_divisor_pp_low !
    d# 1 div2_go !
    d# 0 div2_go !
    begin div2_done @ d# 1 = until
    div2_quotient_pp_high @ 
    div2_quotient_pp_low @ 
    
;

: mensaje_corriente
\    SL     E     T     N     E     I     R     R     O     C 
  h# 10 h# 45 h# 54 h# 4E h# 45 h# 49 h# 52 h# 52 h# 4F h# 43  d# 10
  d# 0 
  do  
    emit-uart
  loop
;

: mensaje_tiempo
\    SL     O     P     M     E     I     T  
  h# 10 h# 4F h# 50 h# 4D h# 45 h# 49 h# 54  d# 7
  d# 0 
  do  
    emit-uart
  loop
; 

: mensaje_porcentaje
\    SL     E     J     A     T     N     E     C     R     O     P   
  h# 10 h# 45 h# 4A h# 41 h# 54 h# 4E h# 45 h# 43 h# 52 h# 4F h# 50  d# 11 
  d# 0 
  do  
    emit-uart
  loop
; 

: con-constant
    h# 008E DtMSB !  \ NUEVO
    h# D280 DtLSB !  \ NUEVO
;   

: restador           \ NUEVO
    swap rot 2dup min over swap > IF h# ffff swap - + d# 1 + swap d# 1 - ELSE - swap THEN
    \ MSB LSB
    DtMSB ! DtLSB !
;    


: main
  con-constant 
  begin
\ Revisa el estado del timmer hasta que se cumple la condicion de activacion
  begin timmer_ClkOut @ d# 1 = until
\ Primero debo asignar el registro de configuracion del modulo LO DEJARE COMENTADO PARA PODER PROBAR LAS OTRAS COSAS
	con-ADDR
	h# 1F h# 3C h# 00
	wr2-i2c
	turn-off
	delay_1ms
\ Indica que va a realizar la lectura del registro de voltaje shunt
\	con-ADDR        \ Inicializa la direccion del ina
	h# 01           \ Deja el primer dato a escribir en el stack
	wr1-i2c
	turn-off
	delay_1ms
\ Lee el voltaje shunt y prepara la lectura del voltaje en el bus   
	h# 02 
	wt-readi2c 
	wr1-i2c
	turn-off
	delay_1ms
\ Lee el voltaje en el bus, escribe en el registro de calibracion y prepara la lectura de la corriente
	h# 00 h# 10 dup h# 05
	wt-readi2c
	wr2-i2c 
	reset_i2c
	h# 04  
	wr1-i2c
	turn-off
	delay_1ms
\  Realiza la lectura de la corriente
	save-i2c
\ =========================================
\ Testeo del divisor
\ =========================================
  h# 0A \ byte bajo divisor
  h# 00 \ byte alto divisor
  INAR dup @ swap drop \ byte bajo dividendo
  h# 00 \ byte alto dividendo
  dividir
  \ Necesito borrar a quotient_pp_high debido a que no lo usare
  swap drop M_CURRENT !
\ =========================================
\ Enviar medicion de corriente a uart
\ =========================================
  M_CURRENT dup @ swap drop bin2bcd_data !
  d# 1    bin2bcd_enable !
  d# 0    bin2bcd_enable !
  \ Espera a que el modulo halla finalizado las operaciones  
  begin bin2bcd_done @ d# 1 = until 
  \ Primero envio un mensaje para indicar que voy a transmitir los datos
  mensaje_corriente
  \ Lee la informacion almacenada en las milesimas y añade el valor de conversion a ascii 
  h# 30 bin2bcd_uni @ + 
  h# 30 bin2bcd_ten @ + 
  h# 30 bin2bcd_hun @ + 
  h# 30 bin2bcd_tho @ +  
  d# 4 d# 0  do  emit-uart  loop
\ =========================================
\ Restador
\ ========================================= 
	M_CURRENT dup @ swap drop \ valor a restar
   DtLSB @
   DtMSB @
   restador  
\ =========================================
\ Tiempo
\ ========================================= 
  M_CURRENT dup @ swap drop \ byte bajo divisor
  h# 00 \ byte alto divisor
  DtLSB dup @ swap drop \ byte bajo dividendo
  DtMSB dup @ swap drop \ byte alto dividendo   
  dividir
  swap h# 0E10 rot rot h# 0000 rot rot 
  dividir
\ =========================================
\ Enviar medicion de tiempo a uart
\ =========================================
  swap drop bin2bcd_data !
  d# 1    bin2bcd_enable !
  d# 0    bin2bcd_enable !
  \ Espera a que el modulo halla finalizado las operaciones  
  begin bin2bcd_done @ d# 1 = until 
  \ Primero envio un mensaje para indicar que voy a transmitir los datos
  mensaje_tiempo
  \ Lee la informacion almacenada en las milesimas y añade el valor de conversion a ascii 
  h# 30 bin2bcd_uni @ + 
  h# 30 bin2bcd_ten @ + 
  h# 30 bin2bcd_hun @ + 
  h# 30 bin2bcd_tho @ +  
  d# 4 d# 0  do  emit-uart  loop
\ =========================================
\ Porcentaje
\ =========================================
  h# 03A8 \ byte bajo divisor
  h# 0000 \ byte alto divisor
  DtLSB dup @ swap drop \ byte bajo dividendo
  DtMSB dup @ swap drop \ byte alto dividendo
  dividir 
\ =========================================
\ Enviar medicion de porcentaje a uart
\ =========================================
  swap drop bin2bcd_data !
  d# 1    bin2bcd_enable !
  d# 0    bin2bcd_enable !
  \ Espera a que el modulo halla finalizado las operaciones  
  begin bin2bcd_done @ d# 1 = until 
  \ Primero envio un mensaje para indicar que voy a transmitir los datos
  mensaje_porcentaje
  \ Lee la informacion almacenada en las milesimas y añade el valor de conversion a ascii 
  h# 30 bin2bcd_uni @ + 
  h# 30 bin2bcd_ten @ + 
  h# 30 bin2bcd_hun @ + 
  h# 30 bin2bcd_tho @ +  
  d# 4 d# 0  do  emit-uart  loop

  again 
;
