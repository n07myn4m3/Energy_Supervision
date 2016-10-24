Gforth 0.7.0, Copyright (C) 1995-2008 Free Software Foundation, Inc.
Gforth comes with ABSOLUTELY NO WARRANTY; for details type `license'
Type `bye' to exit
===========================================================================
Declaracion de variables
===========================================================================
VARIABLE MSB  ok
VARIABLE LSB  ok
VARIABLE CONCT  ok
===========================================================================
En esta parte puede observarse que el escribir en algun registro de memoria
no implica que suceda algo en el stack
===========================================================================
242 MSB !  ok
.S <0>  ok
163 LSB !  ok
.S <0>  ok
===========================================================================
En esta parte observe el efecto generado por los comandos dup, @, drop
===========================================================================
MSB dup   ok
.s <2> 139827211445000 139827211445000  ok  |Al no emplear @ solo leia la direccion mas no el valor almacenado
drop   ok     | Vacio el stack para enmendar el error                              
drop  ok      | Vacio el stack para enmendar el error
.s <0>  ok
MSB dup @  ok
.s <2> 139827211445000 242  ok
swap  ok
.s <2> 242 139827211445000  ok
drop  ok
.s <1> 242  ok
===========================================================================
Uso del comando lshift
===========================================================================
8 lshift  ok
.s <1> 61952  ok
LSB dup @  ok
.s <3> 61952 139827211445048 163  ok
swap  ok
.s <3> 61952 163 139827211445048  ok
drop  ok
.s <2> 61952 163  ok
swap  ok
.s <2> 163 61952  ok
===========================================================================
Uso del comando or
===========================================================================
or  ok
.s <1> 62115  ok
CONCT !  ok     | Observar que cuando envie el valor se borro el stack
.S <0>  ok
CONCT @  ok
.S <1> 62115  ok
