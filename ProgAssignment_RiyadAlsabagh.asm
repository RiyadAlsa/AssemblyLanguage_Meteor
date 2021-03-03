include "emu8086.inc"
org 100h

;PRINT THE QUESTION TO PLAYER       
PRINTN "Enter integer (2=Down, 4=Left,"
PRINTN "6=Right, 8=Up, 0=Quit)"

loop_start:
mov ax, 0xB800         ;set AX to B800 for segment
mov ds, ax             ;set AX in ds to make it the segment

;ERASE PREVIOUS LOCATIONS
mov cl, 030
mov ch, 00000000b       
mov bx, 0x0690    
mov [bx], cx

mov cl, 002
mov ch, 00000000b       
mov bx, 0x0870    
mov [bx], cx

mov cl, 031
mov ch, 00000000b       
mov bx, 0x0910    
mov [bx], cx
;PREVIOUS LOCATIONS ERASED

;CREATE STARTING LOCATIONS
mov cl, 016            ;set the value
mov ch, 00001111b      ;set the colour, first 4 = background, last 4 = foreground
mov bx, 0x0732         ;set the offset, the position in the segment
mov [bx], cx           ;add the character to the memory of bx

mov cl, 002
mov ch, 00001111b       
mov bx, 0x0730    
mov [bx], cx

mov cl, 002
mov ch, 00001111b       
mov bx, 0x0728    
mov [bx], cx
                 
mov cl, 017
mov ch, 00001111b       
mov bx, 0x0726    
mov [bx], cx
;STARTING LOCATION CREATED
 
call SCAN_NUM          ;get integer

cmp cx, 4              ;compare cx to 4
    mov dx, 34         ;set dx
    mov bx, 0x0724     ;set the new position for the bomb 
je loop_left           ;go to loop_left if cx=4

cmp cx, 6              ;compare cx to 6
    mov dx, 37         ;set dx
    mov bx, 0x0734     ;set the new position for the bomb
je loop_right          ;go to loop_right if cx=6

mov ax, cx 

;ERASE THE LOCATIONS
    
mov ch, 00000000b       
mov bx, 0x0732    
mov [bx], cx

mov ch, 00000000b       
mov bx, 0x0730    
mov [bx], cx

mov ch, 00000000b       
mov bx, 0x0726    
mov [bx], cx

mov ch, 00000000b       
mov bx, 0x0728    
mov [bx], cx
;ERASED LOCATIONS

;CREATE NEW LOCATIONS
mov cl, 030
mov ch, 00001111b       
mov bx, 0x0690    
mov [bx], cx

mov cl, 002
mov ch, 00001111b       
mov bx, 0x0730    
mov [bx], cx

mov cl, 002
mov ch, 00001111b       
mov bx, 0x0870    
mov [bx], cx

mov cl, 031
mov ch, 00001111b       
mov bx, 0x0910    
mov [bx], cx
;CREATED NEW LOCATIONS

cmp ax, 8              ;compare ax to 8
    mov dx, 8          ;set dx
    mov bx, 0x0550     ;set the new position for the bomb
je loop_up             ;go to loop_up if cx=8

cmp ax, 2              ;compare ax to 2
    mov dx, 8          ;set dx
    mov bx, 0x0A50     ;set the new position for the bomb
je loop_down           ;go to loop_down if ax=2

cmp ax, 0              ;compare ax to 0
je loop_end            ;go to loop_end if ax=0

cmp ax, ax             ;compare ax to ax
je loop_start          ;go to loop_start if ax!=0,2,4,6,8


;THE LOOPS (UP, DOWN, LEFT, RIGHT)                                 
loop_left:             ;loop start
    mov cl, '*'        ;set the bomb 
    mov ch, 00000000b  ;changed the colour to black to delete the last lazer
    mov [bx], cx       ;displays the invisible bomb
    sub bx, 2          ;we sub 2 bx for every new position
    add ch, 00001111b  ;change the colour to white so it is visible
    mov [bx], cx       ;displays
    sub dx, 1          ;minus dx by 1 every time
    cmp dx, 0          ;compare dx with 0
    jne loop_left      ;if dx does not equal 0 we loop back
    mov ch, 00000000b  ;changed the colour to black to delete the last lazer
    mov [bx], cx       ;displays the invisible bomb
    cmp dx, 0          ;compare dx with 0
    je loop_start      ;if dex equals 0 we loop back to start
RET
   
loop_right:            ;loop start                     
    mov cl, '*'        ;set the bomb
    mov ch, 00000000b  ;changed the colour to black to delete the last lazer
    mov [bx], cx       ;displays the invisible bomb
    add bx, 2          ;we add 2 bx for every new position
    add ch, 00001111b  ;change the colour to white so it is visible
    mov [bx], cx       ;displays
    sub dx, 1          ;minus dx by 1 every time
    cmp dx, 0          ;once dx = 0 we stop
    jne loop_right     ;if dx does not equal 0 we loop back
    mov ch, 00000000b  ;changed the colour to black to delete the last lazer
    mov [bx], cx       ;displays the invisible bomb
    cmp dx, 0          ;compare dx with 0
    je loop_start      ;if dex equals 0 we loop back to start   
RET

loop_up:               ;loop start
    mov cl, '*'        ;set the bomb
    mov ch, 00000000b  ;changed the colour to black to delete the last lazer
    mov [bx], cx       ;displays the invisible bomb
    sub bx, 160        ;we sub/add bx for every new position
    add ch, 00001111b  ;change the colour to white so it is visible
    mov [bx], cx       ;displays
    sub dx, 1          ;minus dx by 1 every time
    cmp dx, 0          ;once dx = 0 we stop
    jne loop_up        ;if dx does not equal 0 we loop back
    mov ch, 00000000b  ;changed the colour to black to delete the last lazer
    mov [bx], cx       ;displays the invisible bomb
    cmp dx, 0          ;compare dx with 0
    je loop_start      ;if dex equals 0 we loop back to start
RET

loop_down:             ;loop start
    mov cl, '*'        ;set the bomb
    mov ch, 00000000b  ;changed the colour to black to delete the last lazer
    mov [bx], cx       ;displays the invisible bomb
    add bx, 160        ;we sub/add bx for every new position
    add ch, 00001111b  ;change the colour to white so it is visible
    mov [bx], cx       ;displays
    sub dx, 1          ;minus dx by 1 every time
    cmp dx, 0          ;once dx = 0 we stop
    jne loop_down      ;if dx does not equal 0 we loop back
    mov ch, 00000000b  ;changed the colour to black to delete the last lazer
    mov [bx], cx       ;displays the invisible bomb
    cmp dx, 0          ;compare dx with 0
    je loop_start      ;if dex equals 0 we loop back to start
RET
;END OF LOOPS

loop_end:
PRINTN "Thanks for playing!"

DEFINE_SCAN_NUM        ;Define proc
DEFINE_PRINT_NUM       ;Define proc
DEFINE_PRINT_NUM_UNS   ;Define proc
end                    ;End