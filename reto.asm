		;se someten a prueba los m¨®dulos de interrupci¨®n externa con disparo positivo
		CONSTANT PuertoHabilitaInt0, 		D0
		CONSTANT PuertoLeeBanderaInt0, 		D1
		CONSTANT PuertoLimpiaBanderaInt0, 	D2
		CONSTANT PuertoHabilitaInt1, 		E0
		CONSTANT PuertoLeeBanderaInt1, 		E1
		CONSTANT PuertoLimpiaBanderaInt1, 	E2
		;
		CONSTANT PuertoEntrada, 		01
		CONSTANT PuertoSalida,  		02
		;puertos del UART
		CONSTANT PuertoLeeListoTX,    	11
		CONSTANT PuertoEscribeDatoTX, 	12
		CONSTANT PuertoLeeDatoRX,     	13
		CONSTANT PuertoDatoListoRX,   	14
		CONSTANT PuertoDatoRXLeido,   	15
		;
		;puertos del spi
		CONSTANT PuertoLeeXLSB, 41
		CONSTANT PuertoLeeXMSB, 42
		CONSTANT PuertoLeeYLSB, 43
		CONSTANT PuertoLeeYMSB, 44
		CONSTANT PuertoLeeZLSB, 45
		CONSTANT PuertoLeeZMSB, 46
		;
		CONSTANT PWMDireccion1,  		A0
		CONSTANT PWMDutyCycle1,  		A1
		CONSTANT PWMDireccion2,  		B0
		CONSTANT PWMDutyCycle2,  		B1
		;
		NAMEREG s3, DatoAccel
		NAMEREG s4, RegEntrada
		NAMEREG s5, RegSalida
		NAMEREG s6, RegTemporal
		NAMEREG s7, RegContador
		NAMEREG s8, RegDutyCycle
		NAMEREG s9, RegDireccion
		NAMEREG sA, DatoSerial
		NAMEREG sB, EstadoTX
		NAMEREG sC, EstadoRX
		NAMEREG	sD, LeidoRX
		;
		;inicio de programa
start:		
		;se deja el valor de PWM de ambos motores constante
		CALL delay_1s
		LOAD		RegDutyCycle, 7F
		OUTPUT		RegDutyCycle, PWMDutyCycle1
		OUTPUT		RegDutyCycle, PWMDutyCycle2
		;limpia registros de trabajo
		LOAD 		DatoAccel, 00		
		LOAD		RegContador, 00		
		;habilita interrupciones		
		LOAD		RegTemporal, 01
		OUTPUT		RegTemporal, PuertoHabilitaInt0
		OUTPUT		RegTemporal, PuertoHabilitaInt1
		;habilita interrupciones en el microcontrolador y espera interrupci¨®n en un lazo infinito
		ENABLE INTERRUPT
wait_rx:
		INPUT		EstadoRX, PuertoDatoListoRX
		COMPARE		EstadoRX, 01
		JUMP		NZ, wait_rx
		;
		;hay nuevo dato RX, se lee
		INPUT		DatoSerial, PuertoLeeDatoRX
		;OUTPUT		DatoSerial, PuertoSalida
		;se informa de dato RX le¨ªdo
		LOAD		LeidoRX, 01
		OUTPUT		LeidoRX, PuertoDatoRXLeido
		;decodifica letra recibida y ejecuta rama correspondiente
		COMPARE		DatoSerial, "1"
		JUMP		Z, direccion1
		COMPARE		DatoSerial, "2"
		JUMP		Z, direccion2
		COMPARE		DatoSerial, "3"
		JUMP		Z, izquierda
		COMPARE		DatoSerial, "4"
		JUMP		Z, derecha
		COMPARE		DatoSerial, "5"
		JUMP		Z, direccion0
		COMPARE		DatoSerial, "a"
		JUMP		Z, lee_xlsb
		COMPARE		DatoSerial, "b"
		JUMP		Z, lee_xmsb
		COMPARE		DatoSerial, "c"
		JUMP		Z, lee_ylsb
		COMPARE		DatoSerial, "d"
		JUMP		Z, lee_ymsb
		COMPARE		DatoSerial, "e"
		JUMP		Z, lee_zlsb
		COMPARE		DatoSerial, "f"
		JUMP		Z, lee_zmsb
		JUMP		wait_rx
		;
		;
direccion0:
		LOAD		RegDireccion, 00
		OUTPUT		RegDireccion, PWMDireccion1
		OUTPUT		RegDireccion, PWMDireccion2
		JUMP		wait_rx
direccion1:
		LOAD		RegDireccion, 02
		OUTPUT		RegDireccion, PWMDireccion1
		LOAD		RegDireccion, 01
		OUTPUT		RegDireccion, PWMDireccion2
		JUMP		wait_rx
direccion2:
		LOAD		RegDireccion, 01
		OUTPUT		RegDireccion, PWMDireccion1
		LOAD		RegDireccion, 02
		OUTPUT		RegDireccion, PWMDireccion2
		JUMP		wait_rx
izquierda:
		LOAD		RegDireccion, 00
		OUTPUT		RegDireccion, PWMDireccion1
		LOAD		RegDireccion, 01
		OUTPUT		RegDireccion, PWMDireccion2
		JUMP		wait_rx
derecha:
		LOAD		RegDireccion, 02
		OUTPUT		RegDireccion, PWMDireccion1
		LOAD		RegDireccion, 00
		OUTPUT		RegDireccion, PWMDireccion2
		JUMP		wait_rx
lee_xlsb:
		;eje x lsb del acelerómetro
		INPUT		DatoAccel, PuertoLeeXLSB
		LOAD		DatoSerial, DatoAccel
		CALL		tx_uart
		;CALL		nuevalinea
		JUMP		wait_rx
		;
lee_xmsb:
		;eje x lsb del acelerómetro
		INPUT		DatoAccel, PuertoLeeXMSB
		LOAD		DatoSerial, DatoAccel
		CALL		tx_uart
		;CALL		nuevalinea
		JUMP		wait_rx
		;
lee_ylsb:
		;eje x lsb del acelerómetro
		INPUT		DatoAccel, PuertoLeeYLSB
		LOAD		DatoSerial, DatoAccel
		CALL		tx_uart
		;CALL		nuevalinea
		JUMP		wait_rx
		;
lee_ymsb:
		;eje x lsb del acelerómetro
		INPUT		DatoAccel, PuertoLeeYMSB
		LOAD		DatoSerial, DatoAccel
		CALL		tx_uart
		;CALL		nuevalinea
		JUMP		wait_rx
		;
lee_zlsb:
		;eje x lsb del acelerómetro
		INPUT		DatoAccel, PuertoLeeZLSB
		LOAD		DatoSerial, DatoAccel
		CALL		tx_uart
		;CALL		nuevalinea
		JUMP		wait_rx
		;
lee_zmsb:
		;eje x lsb del acelerómetro
		INPUT		DatoAccel, PuertoLeeZMSB
		LOAD		DatoSerial, DatoAccel
		CALL		tx_uart
		;CALL		nuevalinea
		JUMP		wait_rx
		;
		;
		;rutina de transmisi¨®n del uart
tx_uart:
		INPUT		EstadoTX, PuertoLeeListoTX
		COMPARE		EstadoTX, 01
		JUMP		Z, tx_uart
		OUTPUT		DatoSerial, PuertoEscribeDatoTX
		RETURN
		;
nuevalinea:
		;imprime nueva linea 
		LOAD		DatoSerial, 0A
		CALL		tx_uart
		;LOAD		DatoSerial, 0D			
		;CALL		tx_uart
		RETURN
		;		
		;
		;inicio ISR
ISR:
		;determina qu¨¦ perif¨¦rico gener¨® la interrupci¨®n
		INPUT		RegTemporal, PuertoLeeBanderaInt0
		COMPARE		RegTemporal, 01
		JUMP		Z, ISR_INT0
		JUMP		ISR_INT1
		;
		;
ISR_INT0:
		;limpia bandera de interrupci¨®n, incrementa contador y lo muestra en LEDs
		LOAD		RegTemporal, 01
		OUTPUT		RegTemporal, PuertoLimpiaBanderaInt0
		JUMP		frena
		;
		;
ISR_INT1:
		;limpia bandera de interrupci¨®n, incrementa contador y lo muestra en LEDs
		LOAD		RegTemporal, 01
		OUTPUT		RegTemporal, PuertoLimpiaBanderaInt1
		JUMP		baile
		;
baile:		
		LOAD		RegDireccion, 00
		OUTPUT		RegDireccion, PWMDireccion2
		LOAD		RegDireccion, 01
		OUTPUT		RegDireccion, PWMDireccion1
		CALL		delay_1s
		CALL		delay_1s
		LOAD		RegDireccion, 00
		OUTPUT		RegDireccion, PWMDireccion1
		LOAD		RegDireccion, 02
		OUTPUT		RegDireccion, PWMDireccion2
		RETURNI ENABLE
		;
frena:
		LOAD		RegDireccion, 00
		OUTPUT		RegDireccion, PWMDireccion1
		OUTPUT		RegDireccion, PWMDireccion2
		RETURNI ENABLE
		;
		;fin de ISR
		;
		; Software delay of 1 second
		;
		; ARTY is fitted with a 100MHz clock.
		; 1 second is 100,000,000 clock cycles.
		; KCPSM6 will execute 50,000,000 instructions.
		;
		; The delay loop below decrements the 24-bit value held
		; in registers [s2,s1,s0] until it reaches zero and this
		; loop consists of 4 instructions.
		;
		; Therefore the loop needs to count 12,500,000 times so
		; the start value is BEBC20 hex.
		;
delay_1s: 
		LOAD s2, BE
		LOAD s1, BC
		LOAD s0, 20
delay_loop: 
		SUB 		s0, 1'd
		SUBCY 		s1, 0'd
		SUBCY 		s2, 0'd
		JUMP 		NZ, delay_loop
		RETURN
		;
		;¨²ltima localidad de memoria de programa
		ADDRESS 	3FF
		JUMP		ISR
