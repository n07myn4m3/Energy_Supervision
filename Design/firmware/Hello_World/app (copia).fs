: delay_1ms
d# 8334 begin d# 1 - dup d# 0 = until	\ 100MHz
\ d# 4167 begin d# 1 - dup d# 0 = until	\ 50MHz
;

: delay_ms
d# 0 do delay_1ms loop
;

: main 

d# 48 ram0 !

begin

ram0 @
dup gp_out0 !
dup emit-uart
d# 1 + ram0 !

ram0 @ d# 58 =
if
d# 48 ram0 !
then

d# 200 delay_ms

\ d# 1 gp_out0 !		\ On
\ d# 500 delay_ms		\ Wait
\ d# 0 gp_out0 !		\ Off
\ d# 500 delay_ms		\ Wait

again

;
