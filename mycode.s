/* 
* FILE : mycode.s
* PROJECT : SENG8000 -Assignment #2
* PROGRAMMER : A. Jamil Aryan
* FIRST VERSION : 2016-02-20
* DESCRIPTION :
* The function called mytest implemented in this file 
* blinks all 8 LEDs on the board for 1 second but when
* pushbutton is pressed, the blinking goes for 500ms.
*/

@@ mycode.s :
@@ Test code for STM32 and linking assembly to C
 

    .code   16
    .text                   @@ - Code section (text -> ROM)

@@ <function block>
    .align  2               @@ - 2^n alignment (n=2)
    .syntax unified
    .global mytest          @@ - Symbol name for function
    .code   16              @@ - 16bit THUMB code (BOTH are required!)
    .thumb_func             @@ /
    .type   mytest, %function   @@ - symbol type (not req)
@@ Declaration : int mytest(int x)
@@ Uses r0 for param 0
@@   r0: x
mytest:
    push {lr} 	             @@ initialize the stack
    push {r1}
    ldr  r1,=LEDaddress	     @@ load LEDs memory address on r1
    ldr  r2,[r1]             
    ldrh r0,[r2]             @@ load half byte of r2 value into r0
    ldr  r3,=oneSec            @@ load a random number ~= 1sec
    ldr  r4,[r3]
    orr  r0,r0,#0xFF00       @@ turn on 8 leds by oring r0 with 1's
    strh r0,[r2]    
ledson:                       @@ start counting down for r4 then branch
    cbz  r4,checkBP    
    subs r4,#1    
    b    ledson
checkBP:                     @@ when r4=0 during count branch here 
    ldr  r3,=oneSec          @@ load a random number ~= 1sec
    ldr  r4,[r3]
    ldr  r5,=halfSec
    ldr  r6,[r5]	     @@ load a random number ~= 500ms
    mov  r0, #0
    bl   BSP_PB_GetState     @@ call BSP function   
    cbz  r0,bnotpressed
bpressed:		     @@ label for when button is pressed
    cbz  r6,ledsoff    
    subs r6,#1
    str  r0,[r2]    
    b    bpressed
bnotpressed:                 @@ label for when button is not pressed
    cbz  r4,ledsoff    
    subs r4,#1 
    str  r0,[r2]    
    b    bnotpressed
ledsoff:
    pop  {r0}
    pop  {pc}

    .size   mytest, .-mytest    @@ - symbol size (not req)

    

@@ <function block>
    .align  2               @@ - 2^n alignment (n=2)
    .syntax unified
    .global my_Tick          @@ - Symbol name for function
    .code   16              @@ - 16bit THUMB code (BOTH are required!)
    .thumb_func             @@ /
    .type   my_Tick, %function   @@ - symbol type (not req)
@@ Declaration : void my_Tick( void )
@@ Uses nothing
my_Tick:
    push {lr}
    push {r0-r1}
    ldr  r1, =myTickCount
    ldr  r0, [r1]
    add  r0, r0, #1
    str  r0, [r1]
    pop  {r0-r1}
    pop  {pc}
    .size   my_Tick, .-my_Tick    @@ - symbol size (not req)

@@ <function block>
    .align  2               @@ - 2^n alignment (n=2)
    .syntax unified
    .global my_Loop          @@ - Symbol name for function
    .code   16              @@ - 16bit THUMB code (BOTH are required!)
    .thumb_func             @@ /
    .type   my_Loop, % function   @@ - symbol type (not req)
@@ Declaration : void my_Loop( void )
@@ Uses nothing
my_Loop:
    push {lr}
//    bl   BSP_LED_Off
    pop  {pc}
    .size   my_Loop, .-my_Loop    @@ - symbol size (not req)

@@ <function block>
    .align  2               @@ - 2^n alignment (n=2)
    .syntax unified
    .global my_Init          @@ - Symbol name for function
    .code   16              @@ - 16bit THUMB code (BOTH are required!)
    .thumb_func             @@ /
    .type   my_Init, %function   @@ - symbol type (not req)
@@ Declaration : void my_Init( void )
@@ Uses nothing
my_Init:
    push {lr}
    pop  {pc}
    .size   my_Init, .-my_Init    @@ - symbol size (not req)

    .data
    .global myTickCount
myTickCount:
    .word  1         /* A 32-bit variable named myTickCount */
    
			/*uint32_t myTickCount = 1; */
LEDaddress:
    .word  0x48001014   @@ memory address of LEDs including offset
oneSec:
    .word  11110000     @@ time value for approximately 1 sec
halfSec:
    .word  05550000     @@ time value for approximately 500ms
    .end

