: delay_us
timer1_time !
begin timer1_done @ d# 1 = until
;

: delay_ms
timer2_time !
begin timer2_done @ d# 1 = until
;

: main 

d# 10 gp_out0 !

d# 7 delay_ms

d# 20 gp_out0 !

\ d# 56 gp_out0 !
\ d# 190 gp_out0 !
\ d# 78 gp_out1 !
\ d# 3477 gp_out0 !
\ d# 54 gp_out1 !
\ d# 3 gp_out0 !
\ d# 88 gp_out1 !
\ d# 7843 gp_out1 !

\ gp_in1 @ gp_out0 !
\ gp_in0 @ gp_out0 !

;
