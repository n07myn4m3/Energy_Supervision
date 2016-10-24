VARIABLE CONTADOR

: RESET_CONTADOR  
 d# 0 CONTADOR ! ;

: CONTAR  
 CONTADOR dup @ d# 2 + CONTADOR !
;

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

: suma
   ram_accum @ d# 1 + ram_accum !
;

: main 
   d# 5 delay_n_10us
   d# 5 gp_out0 !
   RESET_CONTADOR
   CONTADOR dup @ gp_out1 ! drop
   CONTAR
   CONTADOR dup @ gp_out1 ! drop
   CONTAR
   CONTADOR dup @ gp_out1 ! drop
   CONTAR
   CONTADOR dup @ gp_out1 ! drop
   CONTAR
   CONTADOR dup @ gp_out1 ! drop
   CONTAR
   CONTADOR dup @ gp_out1 ! drop
   CONTAR
   CONTADOR dup @ gp_out1 ! drop
   CONTAR
   CONTADOR dup @ gp_out1 ! drop
   CONTAR
   CONTADOR dup @ gp_out1 ! drop
   CONTAR
   CONTADOR dup @ gp_out1 ! drop
   CONTAR
   CONTADOR dup @ gp_out1 ! drop
   CONTAR
   CONTADOR dup @ gp_out1 ! drop
   CONTAR
   CONTADOR dup @ gp_out1 ! drop
   CONTAR
   CONTADOR dup @ gp_out1 ! drop
   RESET_CONTADOR
   CONTADOR dup @ gp_out1 ! drop
;