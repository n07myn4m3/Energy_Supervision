[HOME](Home)

**Tabla de contenido**
 
[TOC]

#Descripción del funcionamiento del módulo
El resultado de la aplicación consistirá en un numero que va de 0 a 9999 el cual debe ser fragmentado en 4 dígitos que serán convertidos en formato ASCII y a su vez otorgados al J1.  
#Consideraciones
   El numero 9999 se puede representar en binario como 0010 0111 0000 1111.  
   Ahora cuando se representa un numero binario en bloques de 4 bits, se puede notar que cada uno de dichos bloques otorgan un aporte al numero total dependiendo de su posición. 
   Si observamos los 4 bloques cada uno de 4 bits, estos otorgan un determinado aporte al valor del numero dependiendo de su posición  
  
   | bloque 1 | bloque 2 | bloque 3 | bloque 4 | valor decimal |  
   | -------- | -------- | -------- | -------- | ------------- |  
   | 0000     | 0000     | 0000     | 1111     | 15            |  
   | 0000     | 0000     | 1111     | 0000     | 240           |  
   | 0000     | 1111     | 0000     | 0000     | 3840          |  
   | 1111     | 0000     | 0000     | 0000     | 61440         |    

   Donde el máximo valor alcanzado es 65535 (15+240+3840+61440), usualmente los números que se trabajaran en el proyecto se encuentran contenidos entre 0 y 9999 lo cual los limita a los siguientes valores.  
   
   * 0010 xxxx xxxx xxxx Para números iguales o superiores a 8192 e inferiores o iguales a 9999.    
   * 0001 xxxx xxxx xxxx Para números inferiores a 8192.    
  

   Esto me imposibilita asociar a cada uno de los bloques con el valor posicional en unidades, décimas, centésimas y milésimas del número.  

#Métodos

Dicha separación en 4 dígitos puede ser realizada tres maneras.

## Múltiples declaraciones if.
  
## Divisiones sucesivas.  

##Algoritmo Double dabble  

   Estos fueron los resultados obtenidos al probar el algoritmo  

   | milésimas | centésimas | décimas | unidades |               |comentarios                                  |  
   | ---- | ---- | ---- | ---- | ------------------------------- | ------------------------------------------- |  
   | 0000 | 0000 | 0000 | 0000 | 10 0111 0000 1111               | numero 9999                                 |  
   | 0000 | 0000 | 0000 | 0001 | 00 1110 0001 1110               | shift (1)                                   |  
   | 0000 | 0000 | 0000 | 0010 | 01 1100 0011 1100               | shift (2)                                   |  
   | 0000 | 0000 | 0000 | 0100 | 11 1000 0111 1000               | shift (3)                                   |  
   | 0000 | 0000 | 0000 | 1001 | 11 0000 1111 0000               | shift (4)                                   |  
   | 0000 | 0000 | 0000 | 1100 | 11 0000 1111 0000               | se le suma 3 a unidades  , debido a que 9>4 |  
   | 0000 | 0000 | 0001 | 1001 | 10 0001 1110 0000               | shift (5)                                   |  
   | 0000 | 0000 | 0001 | 1100 | 10 0001 1110 0000               | se le suma 3 a unidades  , debido a que 9>4 |  
   | 0000 | 0000 | 0011 | 1001 | 00 0011 1100 0000               | shift (6)                                   |  
   | 0000 | 0000 | 0011 | 1100 | 00 0011 1100 0000               | se le suma 3 a unidades  , debido a que 9>4 |  
   | 0000 | 0000 | 0111 | 1000 | 00 0111 1000 0000               | shift (7)                                   |  
   | 0000 | 0000 | 0111 | 1011 | 00 0111 1000 0000               | se le suma 3 a unidades  , debido a que 8>4 |  
   | 0000 | 0000 | 1010 | 1011 | 00 0111 1000 0000               | se le suma 3 a decimas   , debido a que 7>4 |  
   | 0000 | 0001 | 0101 | 0110 | 00 1111 0000 0000               | shift (8)                                   |  
   | 0000 | 0001 | 0101 | 1001 | 00 1111 0000 0000               | se le suma 3 a unidades  , debido a que 6>4 |  
   | 0000 | 0001 | 1000 | 1001 | 00 1111 0000 0000               | se le suma 3 a decimas   , debido a que 5>4 |  
   | 0000 | 0011 | 0001 | 0010 | 01 1110 0000 0000               | shift (9)                                   |  
   | 0000 | 0110 | 0010 | 0100 | 11 1100 0000 0000               | shift (10)                                  |  
   | 0000 | 1001 | 0010 | 0100 | 11 1100 0000 0000               | se le suma 3 a centenas  , debido a que 6>4 |  
   | 0001 | 0010 | 0100 | 1001 | 11 1000 0000 0000               | shift (11)                                  |  
   | 0001 | 0010 | 0100 | 1100 | 11 1000 0000 0000               | se le suma 3 a unidades  , debido a que 9>4 |  
   | 0010 | 0100 | 1001 | 1001 | 11 0000 0000 0000               | shift (12)                                  |  
   | 0010 | 0100 | 1001 | 1001 | 11 0000 0000 0000               | se le suma 3 a unidades  , debido a que 9>4 |  
   | 0010 | 0100 | 1100 | 1100 | 11 0000 0000 0000               | se le suma 3 a decimas   , debido a que 9>4 |  
   | 0100 | 1001 | 1001 | 1001 | 10 0000 0000 0000               | shift (13)                                  |  
   | 0100 | 1001 | 1001 | 1100 | 10 0000 0000 0000               | se le suma 3 a unidades  , debido a que 9>4 |  
   | 0100 | 1001 | 1100 | 1100 | 10 0000 0000 0000               | se le suma 3 a decimas   , debido a que 9>4 |  
   | 0100 | 1100 | 1100 | 1100 | 10 0000 0000 0000               | se le suma 3 a centesimas, debido a que 9>4 |  
   | 1001 | 1001 | 1001 | 1001 | 00 0000 0000 0000               | shift (14)                                  |  
   | 9    | 9    | 9    | 9    |                                 | resultados obtenidos                        |  

##Diagrama de flujo 

![Diagrama de flujo](https://bitbucket.org/supervisinenergtica/energy_supervision/wiki/Diagrams/Submodules/bin2bcd/bin2bcd_FLOWCHART.png)

#Materiales de lectura recomendados (Referencias)

[Lectura 1](http://stackoverflow.com/questions/22882882/split-up-a-four-digit-number-in-verilog)   
[Lectura 2: intro a Double-Dabble](http://electronics.stackexchange.com/questions/64538/displaying-a-2-digit-integer-on-two-7-segment-display)   
[Lectura 3: algoritmo Double-Dabble](https://en.wikipedia.org/wiki/Double_dabble)    
[Lectura 4: código verilog](http://www.johnloomis.org/ece314/notes/devices/binary_to_BCD/binary_to_bcd_v.html)

