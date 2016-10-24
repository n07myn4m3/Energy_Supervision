[HOME](Home)

**Tabla de contenido**
 
[TOC]

**Nota**

Apreciado lector, este texto no se encuentra revisado ni preparado para su publicación así que de antemano se pide perdón por los errores que se puedan contener en el mismo

#Funcionamiento de un bus I2C

* La informacion es enviada en cada flanco de bajada, todas las transmisiones inician con el bit mas significativo.
* Primero se debe enviar la dirección del módulo, esta tiene un formato de 7 bits de dirección mas un bit que indica la operación de lectura o escritura.
* Devices on the bus pull a line to ground to send a logical zero and release a line (leave it floating) to send a logical one.

##Escritura

El procedimiento para escribir en un dispositivo esclavo es el siguiente:  
 
1. Enviar la secuencia de start.  
2. Enviar la dirección I2C del esclavo con el bit R/W bajo.  
3. Ingresar el registro interno de la dirección a la cual usted desea escribir.  
4. Enviar el byte de información.   
5. Opcionalmente puede enviar mas bytes de informacion.  
6. Enviar la secuencia de stop.    

Diagrama de tiempos para escribir en una dirección vía protocolo I2C.  

![WRITE](https://bitbucket.org/supervisinenergtica/energy_supervision/wiki/Imagenes/i2c_master/WRITE.png)

##Lectura

El procedimiento para escribir en un dispositivo esclavo es el siguiente:  
 
1. Enviar la secuencia de start.  
2. Enviar la dirección I2C del esclavo con el bit R/W bajo.  
3. Ingresar el registro interno de la dirección a la cual usted desea leer.  
4. Enviar de nuevo la secuencia de start. 
5. Enviar la dirección I2C del esclavo con el bit R/W alto.  
6. Leer el byte de información del esclavo.   
7. Opcionalmente puede leer mas bytes de información del esclavo.   
8. Enviar la secuencia de stop.   

Diagrama de tiempos para leer de una dirección vía protocolo I2C.  

![READ](https://bitbucket.org/supervisinenergtica/energy_supervision/wiki/Imagenes/i2c_master/READ.png)

#Descripcion del módulo I2C

El presente módulo fue traducido a código verilog del diseño original en vhdl creado por Scott Larson [^fn1]. 

##Características

* Código verilog para un circuito inter-integrado Inter-Integrated Circuit (I2C or IIC) maestro [^fn1].
* El usuario puede definir el reloj del sistema [^fn1].
* El usuario puede definir la frecuencia del reloj de la interfaz I2C [^fn1].
* Genera las condiciones de Start, Stop, Repeated Start y Acknowledge [^fn1].
* Usa el direccionamiento de 7 bits para la comunicación con el esclavo [^fn1].
* Compatible con situaciones de clock-stretching generadas por los esclavos [^fn1]. 
* No es recomendado su uso con buses multimaestro [^fn1].
* Notifica al usuario si existe algún error en el acknowledge del esclavo [^fn1].

##Principio de operación 

El módulo i2c_master emplea la maquina de estados de la figura ??? para lograr llevar a cabo el procedimiento requerido en la comunicación I2C descrita en los apartados anteriores. 

Tras la puesta en marcha el módulo entra de inmediato al estado "ready" y se mantiene allí hasta que la señal "ena" indica el inicio de las operaciones. El estado "start" genera las condiciones de start o inicio del bus I2C, el estado "command" comunica la dirección y la condición de lectura o escritura al bus. El estado slv_ack1 captura y verifica el acknowledge entregado por el esclavo, ahora dependiendo del comando de lectura o escritura el módulo procede a escribir datos al esclavo (estado "wr") o a recibir informacion del esclavo (estado "rd"). Una vez finalizado el maestro captura y verifica la respuesta del esclavo (estado "slv_ack2") si esta escribiendo o emite su propia respuesta (estado mstr_ack) si se encuentra leyendo. Si la señal ena vuelve a ser evaluada en otro cambio de comando y se mantiene la musma direccion del esclavo con el que inicio la comunicación  el módulo continua con otro proseso de escritura o lectura, en caso de que cambiara la dirección el módulo regresa al estado de "start" y continua el proceso indicado por la especificación i2c, una vez que el maestro completa un estado de lectura o escritura y la señal "ena" no se encuentra habilitada el módulo genera la condicion de stop (estado "stop")
y vuelve al estado inicial (estado "ready") [^fn1]. 

[^fn1] ![Diagrama de flujo](https://bitbucket.org/supervisinenergtica/energy_supervision/wiki/Imagenes/i2c_master/i2c_master_state_diagram.JPG)

   | Puerto    | Ancho | Modo   | Tipo de dato          | interfaz        | Descripción        |  
   | --------- | ----- | ------ | ------------          | --------------- | ------------------ |  
   | clk       | 1     | in     | standard logic        | user logic      ||  
   | reset     | 1     | in     | standard logic        | user logic      ||  
   | ena       | 1     | in     | standard logic        | user logic      ||  
   |           |       |        |                       |                 ||
   | addr      | 7     | in     | standard logic vector | user logic      ||  
   | rw        | 1     | in     | standard logic        | user logic      ||  
   |           |       |        |                       |                 ||
   | data_wr   | 8     | in     | standard logic vector | user logic      ||  
   | data_rd   | 8     | out    | standard logic vector | user logic      ||  
   | busy      | 1     | out    | standard logic        | user logic      ||  
   |           |       |        |                       |                 ||
   | ack_error | 1     | buffer | standard logic        | user logic      ||  
   |           |       |        |                       |                 ||
   | sda       | 1     | inout  | standard logic        | slave device(s) ||  
   | scl       | 1     | inout  | standard logic        | slave device(s) ||  
   
#Descripción del módulo esclavo: INA219 
Antes que nada, es necesario aclarar las diferencias existentes entre el INA219 y la breakout board del INA219, el primero consiste en el integrado como tal, mientras que el segundo contiene por defecto una resistencia shunt de 0.1 ohms, dos resistencias de 10 kohms asociadas con las lineas de SDA y SCL, además de traer preconfigurada la dirección del módulo con dos resistencias pulldown de 10 kohms.

![INA219](https://bitbucket.org/supervisinenergtica/energy_supervision/wiki/Imagenes/i2c_master/INA219.png)

##Registros empleados por el INA219

Todos los registros de 16 bits del INA219 son en realidad dos bytes de 8 bits cada uno enviados por medio de la interfaz I2C

###Registros de entrada de datos

####Registro de configuración HEX 00 BIN 0000 0000 (Read/Write)

Significado de cada uno de los bits empleados al momento de escribir en esta dirección  

   | Bit      | Nombre   | Descripción                         |  
   | -------- | -------- | ----------------------------------- |  
   | D15      | RST      | Reset                               |  
   | D14      | -        | -                                   |  
   | D13      | BRNG     | Bus Voltage Range                   |  
   | D12      | PG1      | PGA (Shunt Voltage Only)            |  
   | D11      | PG0      | PGA (Shunt Voltage Only)            |  
   | D10      | BADC4    | BADC Bus ADC Resolution/Averaging   |  
   | D09      | BADC3    | BADC Bus ADC Resolution/Averaging   |  
   | D08      | BADC2    | BADC Bus ADC Resolution/Averaging   |  
   | D07      | BADC1    | BADC Bus ADC Resolution/Averaging   |  
   | D06      | SADC4    | SADC Shunt ADC Resolution/Averaging |  
   | D05      | SADC3    | SADC Shunt ADC Resolution/Averaging |  
   | D04      | SADC2    | SADC Shunt ADC Resolution/Averaging |  
   | D03      | SADC1    | SADC Shunt ADC Resolution/Averaging |  
   | D02      | MODE3    | Operating Mode                      |  
   | D01      | MODE2    | Operating Mode                      |  
   | D00      | MODE1    | Operating Mode                      |  

* D15 reset por defecto se deja cero, en caso de ser 1 se resetea todo el ina a la configuracion por defecto

* D14-D13 Rango de voltajes del bus (Bus Voltage Range)
  * 0 = 16V FSR (Full Scale Range)
  * 1 = 32V FSR (Valor por defecto del INA)

* D12-D11 PGA config 
Hace referencia a la configuracion del Power Gain Amplifier
Cuando leo voltajes en la resistencia shunt, esta configuracion me permite modificar la ganancia que tendra el amplificador asociado al mismo

* D10-D07 BADC Bus ADC Resolution/Averaging
These bits adjust the Bus ADC resolution (9-, 10-, 11-, or 12-bit) or set the number of samples used when
averaging results for the Bus Voltage Register (02h).

* D06-D03 SADC Shunt ADC Resolution/Averaging
These bits adjust the Shunt ADC resolution (9-, 10-, 11-, or 12-bit) or set the number of samples used when
averaging results for the Shunt Voltage Register (01h).

* D02-D00 Operating Mode
Selects continuous, triggered, or power-down mode of operation. These bits default to continuous shunt and bus
measurement mode.

Registros recomendados por Adafruit

   | Bit      | Nombre   | 32V 2A | 32V 1A | 16V 0.4A |  
   | -------- | -------- | ------ | ------ | -------- |  
   | D15      | RST      | 0      | 0      | 0        |  
   | D14      | -        | 0      | 0      | 0        |  
   | D13      | BRNG     | 1      | 1      | 0        |  
   | D12      | PG1      | 1      | 1      | 0        |  
   | D11      | PG0      | 1      | 1      | 0        |  
   | D10      | BADC4    | 1      | 1      | 1        |  
   | D09      | BADC3    | 0      | 0      | 0        |  
   | D08      | BADC2    | 0      | 0      | 0        |  
   | D07      | BADC1    | 0      | 0      | 0        |  
   | D06      | SADC4    | 0      | 0      | 0        |  
   | D05      | SADC3    | 0      | 0      | 0        |  
   | D04      | SADC2    | 1      | 1      | 1        |  
   | D03      | SADC1    | 1      | 1      | 1        |  
   | D02      | MODE3    | 1      | 1      | 1        |  
   | D01      | MODE2    | 1      | 1      | 1        |  
   | D00      | MODE1    | 1      | 1      | 1        |  

###Registros de salida de datos
####Shunt Voltage Register HEX 01 BIN 0000 0001

 
   | Bit      | PGA = 8 | PGA = 4 | PGA = 2 | PGA = 1 |  
   | -------- | ------- | ------- | ------- | ------- |  
   | D15      | SIGN    | SIGN    | SIGN    | SIGN    |  
   | D14      | SD14    | SIGN    | SIGN    | SIGN    |  
   | D13      | SD13    | SD13    | SIGN    | SIGN    |  
   | D12      | SD12    | SD12    | SD12    | SIGN    |  
   | D11      | SD11    | SD11    | SD11    | SD11    |  
   | D10      | SD10    | SD10    | SD10    | SD10    |  
   | D09      | SD09    | SD09    | SD09    | SD09    |  
   | D08      | SD08    | SD08    | SD08    | SD08    |  
   | D07      | SD07    | SD07    | SD07    | SD07    |  
   | D06      | SD06    | SD06    | SD06    | SD06    |  
   | D05      | SD05    | SD05    | SD05    | SD05    |  
   | D04      | SD04    | SD04    | SD04    | SD04    |  
   | D03      | SD03    | SD03    | SD03    | SD03    |  
   | D02      | SD02    | SD02    | SD02    | SD02    |  
   | D01      | SD01    | SD01    | SD01    | SD01    |  
   | D00      | SD00    | SD00    | SD00    | SD00    |  
El registro del voltaje en la resistencia shunt almacena la información dependiendo de configuración del PGA seleccionado en 
en el registro de configuración, si existen mas de un bit asociados al signo del numero, todos poseerán el mismo valor, los resultados obtenidos están expresados en un numero binario con signo que varia entre +- 32000 o el equivalente a +- 320,00 milivoltios.  
A continuación se presentan los valores obtenidos cuando la configuración del PGA es igual a 8.  
* 0111 1101 0000 0000 Lectura equivalente a 320,00 milivoltios.  
* 1000 0011 0000 0000 Lectura equivalente a -320,00 milivoltios.  

####Bus Voltage Register HEX 02 BIN 0000 0010

El registro de voltaje del bus tiene un formato binario de 16 bits de los cuales los dos primeros hacen referencia al estado de la medicion, el tercero no otorga informacion significativa y los trece últimos representan el voltaje obtenido en el bus en el bus
sin signo al cual se le añaden una serie de bitrs encargadas de notificar el estado de la medición
Cabe recalcar que esta representación hace referencia a un numero binario sin signo

Significado de cada uno de los bits empleados por el registro de voltaje del bus 

   | Bit      | Nombre   | Descripción                |  
   | -------- | -------- | -------------------------- |  
   | D15      | BD12     | Bus data                   |  
   | D14      | BD11     | Bus data                   |  
   | D13      | BD10     | Bus data                   |  
   | D12      | BD09     | Bus data                   |  
   | D11      | BD08     | Bus data                   |  
   | D10      | BD07     | Bus data                   |  
   | D09      | BD06     | Bus data                   |  
   | D08      | BD05     | Bus data                   |  
   | D07      | BD04     | Bus data                   |  
   | D06      | BD03     | Bus data                   |  
   | D05      | BD02     | Bus data                   |  
   | D04      | BD01     | Bus data                   |  
   | D03      | BD00     | Bus data                   |  
   | D02      | -        | -                          |  
   | D01      | CNVR     | Conversion Ready           |  
   | D00      | OVF      | Math Overflow Flag         |  

* D15-D03 Medición obtenida por el modulo del voltaje en el bus.  
* D02 No es revelante.  
* D01 A pesar de que la informacion obtenida de la ultima conversión puede ser leída en cualquier momento, el bit CNVR (conversión disponible - conversion ready) indica cuando el modulo ha acabado de convertir, promediar y multiplicar las   mediciones y por ende tiene disponible nueva información en el registro. Este bit es limpiado bajo las siguientes condiciones:  
1. Cuando el usuario se encuentre leyendo el power register(Registro de poder).  
2. Escribiendo un nuevo modo en el registro de configuración (excepto para los modos Power-Down o Disable).  
* D00 La bandera de desbordamiento matemático (OVF) indica cuando los cálculos de poder o corriente del modulo se encuentran fuera de rango y por ende que sus mediciones carecen de significado.  

Para que el valor de este registro pueda ser usado en otros cálculos deben practicarse las siguientes conversiones:  
* Desplazar el registro 3 bits a la derecha.  
* Multiplicar el valor obtenido por el valor del bit menos significativo (LSB).  

Dependiendo del valor del bit BRNG (Rango de voltajes del bus - Bus Voltage Range) los valores de los bits D15-D03 seran los siguientes:  

* BRNG = 1, full-scale range = 32 V (decimal = 8000, hex = 1F40, bin = 1 1111 0100 0000), LSB = 4 mV.  
* BRNG = 0, full-scale range = 16 V (decimal = 4000, hex = 0FA0, bin = 0 1111 1010 0000), LSB = 4 mV.  
####Power Register HEX 03 BIN 0000 0011 [reset HEX 00 BIN 0000 0000]
Los 16 bits obtenidos en este registro hacen referencia a una medición de potencia obtenida al multiplicar el registro de corriente con el registro de voltaje del bus, el rango de valores máximos que puede alcanzar y el valor del LSB por el cual debo ajustar el resultado obtenido de la medición, vienen determinados por el registro de configuración.  

El regultado obtenido se debe dividir por los valores de powerDivider descritos a continuación:  
* Para una configuración de lectura de 32v y 2A powerDivider = 2.  
* Para una configuración de lectura de 32v y 1A powerDivider = 1.  
* Para una configuración de lectura de 16v y 400mA powerDivider = 1.  

Al final los resultados de potencia obtenidos vendrán expresados en mw.
   
=> 32v 2A  
	ina219_currentDivider_mA = 10;  // Current LSB = 100uA per bit (1000/100 = 10)
	ina219_powerDivider_mW = 2;     // Power LSB = 1mW per bit (2/1)
=> 32v 1A
	ina219_currentDivider_mA = 25;  // Current LSB = 40uA per bit (1000/40 = 25)
	ina219_powerDivider_mW = 1;     // Power LSB = 800�W per bit
=> 16v_400mA
  ina219_currentDivider_mA = 20;  // Current LSB = 50uA per bit (1000/50 = 20)
  ina219_powerDivider_mW = 1;     // Power LSB = 1mW per bit 

###Proceso que se debe llevar a cabo para realizar una lectura
**1. Enviar el registro de configuración del ina.**  
   El registro de configuracion del ina se encuentra en la dirección HEX  (0x00) BIN  0000 0000, por ende el registro en la encargado de almacenar este valor debe ser declarado de la siguiente manera:


```
#!forth

      h# 00 REG_CONFIG !
```
   Ahora lo que se debe escribir en esa direccion para configurar al ina para recibir lecturas entre 32V y 2A debe ser lo siguiente HEX  (0x00) BIN 0011 1100 0001 1111, por ende los registros encargados de almacenar estos valores deben ser declarados de la siguiente manera.  

```
#!forth

      h# 3C MSB_REG_CONFIG !
      h# 1F LSB_REG_CONFIG !
```

**2. Leer el voltaje de la resistencia shunt.**  
   El registro de voltaje de la resistencia shunt del ina se encuentra en la dirección HEX  (0x01) BIN  0000 0001, por ende el registro en la encargado de almacenar este valor debe ser declarado de la siguiente manera:


```
#!forth

      h# 01 REG_SHUNTVOLTAGE !
```
   Después de escribir en esta dirección en teoría se deben recibir 2 bytes de información asociada al voltaje de la resistencia shunt, sin embargo este valor no sera almacenado en algún espacio de memoria del J1 debido a que no se requiere para realizar cálculos del modulo de supervisión, pero el ina si necesita ser consciente de que tomo dicha medición para realizar una serie de cálculos internos.

**3. Leer el voltaje del bus .**  
El modulo de supervisión energética no requiere este dato.

**4. Enviar el registro de calibración del ina.**  
Este registro debe ser modificado cada vez que se valla a realizar una medición de corriente o de potencia, este se encuentra en la ubicación HEX  (0x05) BIN  0000 0101, , por ende el registro en la encargado de almacenar este valor debe ser declarado de la siguiente manera:

```
#!forth

      h# 05 REG_CALIBRATION !
```

Ahora lo que se debe escribir en esa direccion para configurar al ina bajo un régimen de lecturas entre 32V y 2A debe ser lo siguiente DEC (4096) HEX  (0x1000) BIN  (0001 0000 0000 0000), este valor se obtiene por medio de unos cálculos que no serán considerados en estas anotaciones, por ultimo los registros encargados de almacenar estos valores deben ser declarados de la siguiente manera.  

```
#!forth

      h# 10 MSB_REG_CALIBRATION !
      h# 00 LSB_REG_CALIBRATION !

```

**5. Leer la corriente.**  

   El registro de corriente del ina se encuentra en la dirección HEX  (0x04) BIN  0000 0100, por ende el registro en la encargado de almacenar este valor debe ser declarado de la siguiente manera:


```
#!forth

      h# 04 REG_CURRENT !
```
   Después de escribir en esta dirección en teoría se deben recibir 2 bytes de información asociada al valor de la medición de corriente tomada por el ina estos dos valores deben ser concatenados y luego ser divididos por una constante para obtener su valor en miliamperios, en este caso para una configuración dispuesta a funcionar bajo un régimen de 32 V y 2 A el valor de dicha constante es 10.

**6. Leer la potencia.**  
El modulo de supervisión energética no requiere este dato.

###Proceso detallado que se debe llevar a cabo para realizar una lectura 

El procedimiento descrito a continuación se obtuvo luego de haber testeado el ina219 junto a su circuito de pruebas cambiando el master elaborado en la fpga por el arduino, con la finalidad de depurar el código forth implementado en el j1 y encontrar los motivos por los que fallaba el algoritmo.

**1. Enviar el registro de configuración del ina.**  
- - -
Dentro de las lecturas llevadas a cabo por el analizador lógico se desconoce si se realizo esta configuracion al inicio de las operaciones del ina, debido a que se ignoro al momento de realizar las mediciones o puede que esta no halla sucedido, la única manera de determinarlo es repetir el test. 

**2. Primer bloque de flujo de datos.**  
- - -  
* Indicar la dirección del modulo en modo de escritura, es decir 0x40 con el bit r/w en bajo.  
* Indicar la dirección interna del modulo 0x01 la cual hace referencia al voltaje en la resistencia shunt del modulo.  
* Otorgar una pausa de un milisegundo.  

![PASO1](https://bitbucket.org/supervisinenergtica/energy_supervision/wiki/Imagenes/i2c_master/INA_219/paso_1.png)

**2. Segundo bloque de flujo de datos.**  
- - -    
* Indicar la dirección del modulo en modo de lectura, es decir 0x40 con el bit r/w en alto.  
* Leer los dos bytes de información otorgados por el INA los cuales se encuentran asociados al voltaje en la resistencia shunt.  
* Indicar la dirección del modulo en modo de escritura, es decir 0x40 con el bit r/w en bajo.  
* Indicar la dirección interna del modulo 0x02 la cual hace referencia al voltaje en el bus del modulo.  
* Otorgar una pausa de un milisegundo.  

![PASO2](https://bitbucket.org/supervisinenergtica/energy_supervision/wiki/Imagenes/i2c_master/INA_219/paso_2.png)

**3. Tercer bloque de flujo de datos.**  
- - -
A continuación se otorga una vista panorámica de lo que debe suceder en el tercer bloque de flujo de datos 

![PASO3PAN](https://bitbucket.org/supervisinenergtica/energy_supervision/wiki/Imagenes/i2c_master/INA_219/paso_3_panoramico.png)

* Indicar la dirección del modulo en modo de lectura, es decir 0x40 con el bit r/w en alto.  
* Leer los dos bytes de información otorgados por el INA los cuales se encuentran asociados al voltaje en el bus.  

![PASO3_1](https://bitbucket.org/supervisinenergtica/energy_supervision/wiki/Imagenes/i2c_master/INA_219/paso_3_1.png)

* Indicar la dirección del modulo en modo de escritura, es decir 0x40 con el bit r/w en bajo.  
* Indicar la dirección interna del modulo 0x05 la cual hace referencia al registro de configuración del ina  
* Escribir el byte mas significativo 0x10.  
* Escribir el byte menos significativo 0x00.  

![PASO3_2](https://bitbucket.org/supervisinenergtica/energy_supervision/wiki/Imagenes/i2c_master/INA_219/paso_3_2.png)

* Indicar la dirección del modulo en modo de escritura, es decir 0x40 con el bit r/w en bajo.  
* Indicar la dirección interna del modulo 0x04 la cual hace referencia a la medición de corriente obtenida por el ina  
* Escribir el byte mas significativo 0x10.  
* Otorgar una pausa de un milisegundo.  

![PASO3_3](https://bitbucket.org/supervisinenergtica/energy_supervision/wiki/Imagenes/i2c_master/INA_219/paso_3_3.png)

**4. Cuarto bloque de flujo de datos.**  
- - -
* Indicar la dirección del modulo en modo de escritura, es decir 0x40 con el bit r/w en alto.  
* Leer los dos bytes de información otorgados por el INA los cuales se encuentran asociados a la medición de corriente.  

![PASO4](https://bitbucket.org/supervisinenergtica/energy_supervision/wiki/Imagenes/i2c_master/INA_219/paso_4.png)

#Conclusiones










#Referencias

[^fn1]: Scott Larson, I2C Master (VHDL) [eewiki 2015], https://eewiki.net/pages/viewpage.action?pageId=10125324.











