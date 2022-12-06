TITLE RSA(RSA.asm)
INCLUDE Irvine32.inc
.data
AskP byte "Enter Prime Number P:",0
AskQ byte "Enter Prime Number Q:",0
errorMsg byte "Number is Not Prime, ENTER A PRIME NUMBER",0
printn byte "Value of n=",0
printk byte "Value of K=",0
printd byte "Value of D(Private key)=",0
AskE byte "Choose e(public key),such that e<k and e>1 and gcd(e,k)=1:",0
AskE1 byte "Invalid e, please choose again",0
printfinal byte "Value of e is acceptable",0
msgencrypt1 byte "Your Encrypted Key is below",0
askdecrypt  byte "Press 1 to see decrypted text and any other key to return to menu: ",0
finalmsg byte "Please note down value of N,D(decrypt key)and Encryption string for future use",0
askch dword ?
space byte " ",0
p dword ?
q dword ?
n dword ?
n1 dword ?
k dword ?
e dword ?
d sdword ?
c1 dword ?
b1 dword ?
gcd1 dword ?
ans dword 1
m1 dword 0
i12 dword 2
i13 dword 1
flag1 dword 0
msgbuffer byte 100 dup(?)
msgencrypt dword 100 DUP(?)
bytecount dword ?
caption byte "Dialog Title", 0
HelloMsg BYTE "This is a pop-up message box.", 0dh,0ah
BYTE "Click OK to continue...", 0
modPower proto x:dword, y:dword, p:dword,ans1:dword
decrypt1 proto
newdecrypt1 proto
checkPrime PROTO prime1:dword,m:dword,i1:dword,flag:dword
GCD proto var1:dword, var2:dword
calculateD proto a:dword, m:dword,i:dword
filedecrypt proto
filehandle DWORD ?
filename BYTE "MyFile.txt", 0
.code
main PROC
        
    ;mov ebx, 0 ; no caption
    ;mov edx, OFFSET HelloMsg ; contents
    ;call MsgBox
    ;mov ebx, OFFSET caption ; caption
    ;mov edx, OFFSET HelloMsg ; contents
    ;call MsgBox
    mov eax,white +(blue* 16)
    call SetTextColor
    call Clrscr
    call Intro
    
r1:
    call mainmenu
    askPagain:
    mov eax,0
    mov edx,offset AskP
    call writestring
    call readdec
    mov p,eax
    invoke checkPrime,p,m1,i12,flag1
    cmp eax,0
  
    jne askPagain
    
    call crlf
    askQagain:
      mov eax,0
    mov edx,offset AskQ
    call writestring 
    call readdec
    mov q,eax
    invoke checkPrime,q,m1,i12,flag1
    cmp eax,0
   
    ;call clrscr
    jne askQagain
    mov eax,q
    mul p
    mov n,eax
    mov n1,eax
    mov edx,offset printn
    call writestring
    call writedec
    call crlf
    sub p,1
    sub q,1
    mov eax,p   
    mul q
    mov k,eax
    mov edx,offset printk
    call writestring
    call writedec
    call crlf
repeat1:
    mov edx,offset AskE
    call writestring
    call readdec
    mov e,eax
    cmp eax,k
    jc l1
    jnc repeat1
    l1:
    cmp eax,1
    ja l3
jmp repeat1
l3:
    invoke GCD,k,e          ;GCD CALLED
	;add esp,8
	call crlf
	;call writedec
    mov gcd1,eax
	cmp eax,1
    je final
    mov edx,offset AskE1
    call writestring
    call crlf
	jne repeat1
    final:
    mov edx,offset printfinal
    call crlf
    call writestring 
    invoke calculateD, e,k,i13
    call crlf
    mov edx,offset printd
    call writestring
    mov d,eax
    call writedec
    call crlf
    mov esi,offset msgbuffer
    mov edi,offset msgencrypt		
    mov edx,offset msgencrypt1
    call writestring
    call crlf
    mov edx, offset filename
    call CreateOutputFile
    mov filehandle, eax

l11:

lodsb																;al,[esi]
																	;add esi,1
cmp al,0
je ret1
movzx eax,al
mov b1,eax
invoke modPower , b1,e,n1,ans
;add esp,16
call writedec
mov edx,offset space
call writestring
mov c1,eax
stosd																;[edi],eax
																	;add edi,4

jmp l11
																	
;l2:
;call crlf
;mov esi,offset msgencrypt
;lodsd																;eax,[esi]
;l13:
;cmp eax,0
;je ret1
;invoke modPower, eax,d,n1,ans
;call crlf
;call writedec
;mov edx,offset space
;call writechar

;call writestring
;lodsd																;mov eax,[esi]
;jmp l13
												

ret1:
mov eax,filehandle
mov edx,offset msgencrypt
mov ecx,100
call writetofile
mov eax,filehandle
call closefile
call crlf
mov edx,offset finalmsg
call writestring 
call crlf
mov edx,offset askdecrypt
call writestring
call readdec
cmp eax,1
jne l2
call decrypt1
l2:
jmp r1
;call DumpRegs
exit
main ENDP

Intro proc
.data
print1 byte "RSA Encryption Decrtyption System",0
print2 byte "Made By",0
print3       byte "Mubeen Siddiqui 19K-1276",0
print4       byte "Mobeen Zaheer Mirza 19K-0335",0
print5       byte "Bassam Tariq 19K-0152",0
.code
mov dh,7
mov dl,37
call gotoxy
mov edx,offset print1
call writestring
call crlf
mov dh,9
mov dl,50
call gotoxy
mov edx,offset print2
call writestring
call crlf
mov dh,10
mov dl,40
call gotoxy
mov edx,offset print3
call writestring
call crlf
mov dh,11
mov dl,38
call gotoxy
mov edx,offset print4
call writestring
call crlf
mov dh,12
mov dl,43
call gotoxy
mov edx,offset print5
call writestring
mov eax,2000
call delay
call clrscr
ret
Intro ENDP



GCD proc,x1:dword,y1:dword
    top:
    mov edx,0
    mov eax,x1
    div y1
    mov n,edx
    mov eax,y1
    mov x1,eax
    mov eax,n
    mov y1,eax
    cmp y1,0
    jc l1
    jz l1
    jmp top
    l1:
    mov eax,x1
    ret
;call DumpRegs
GCD ENDP

mainmenu PROC 
.data
askchoice byte "Press 1 to Encrypt a message",13,10
          byte "Press 2 to decrypt a message using your own string",13,10
          byte "Press 3 to decrypt a message from a file",13,10
          byte "Press 4 to exit program",13,10
          byte "Enter your choice: " ,0     

askmessage byte "Enter Message to Encrypt:",0
choice dword ?


.code
top:
    mov edx,offset askchoice 
    call writestring
    call readdec
    call clrscr
    cmp eax,1
    je encrypt
    cmp eax,2
    je decrypt
    cmp eax,3
    je decrypt2
    cmp eax,4
    jne top
    exit
encrypt:
    mov edx,offset askmessage
    call writestring
    mov  edx,offset msgbuffer
	mov  ecx,sizeof msgbuffer
	call readstring
    mov bytecount,eax
    ret
decrypt:
invoke newdecrypt1
jmp l10
decrypt2:
invoke filedecrypt
l10:
call mainmenu
;call DumpRegs
mainmenu ENDP

calculateD PROC, a:dword,m:dword,i:dword  ;Private key generation 
.code
mov eax,a
mov edx,0
div m
mov a,edx
s1:
mov eax,m
cmp i,eax
jae s2
mov eax,a
mul i
mov edx,0
div m
inc i
cmp edx,1
jne s1
s2:
dec i
mov eax,i
ret

;call DumpRegs
calculateD ENDP
modPower proc, x1:dword, y1:dword, p1:dword,ans1:dword
mov edx,0
mov eax,x1
div p1
mov x1,edx
cmp x1,0
jne l1
mov eax,0
ret
l1:
top:
cmp y1,0
jbe out1
mov eax,y1
mov edx,0
mov ebx,2
div ebx
cmp edx,1
jne l2
mov edx,0
mov eax,ans1
mul x1
div p1
mov ans1,edx
l2:
mov edx,0
mov eax,y1
mov ebx,2
div ebx
mov y1,eax
mov eax,x1
mul eax
mov edx,0
div p1
mov x1,edx
jmp top
out1:
mov eax,ans1
ret
;call DumpRegs
modPower ENDP

decrypt1 proc 
call crlf
mov esi,offset msgencrypt
lodsd																;eax,[esi]
l13:
cmp eax,0
je ret1
invoke modPower, eax,d,n1,ans
;call crlf
;call writedec
;mov edx,offset space
call writechar

;call writestring
lodsd																;mov eax,[esi]
jmp l13
ret1:
mov d,0
;call DumpRegs
mov ecx,100
mov eax,0
mov edi,offset msgencrypt
rep stosd
call crlf
ret
decrypt1 ENDP

newdecrypt1 proc
.data
decryptbuffer dword 100 DUP(?)
newdecryptbuffer dword 100 DUP(?)
newN dword ?
newD dword ?
newE dword ?
newC dword ?
ask1 byte "Enter String to decrypt:",0
break byte "Press 0 when all the string is enterted:",0
decrypttext byte "Your Decrypted Text:",0
ask2 byte "Enter N:",0
ask3 byte "Enter D(Private Key):",0
ask4 byte "Enter E:",0
ans2 dword 1
.code

mov filehandle,eax
;mov edx,OFFSET filename
;call OpenInputFile
;mov filehandle, EAX
;mov edx, OFFSET decryptbuffer ;buffer will contain the text read from the file
;mov ecx, 100 ;specify how many bytes to read
;call ReadFromFile
;mov edx, OFFSET decryptbuffer
;call writestring
;Call crlf
mov edx,offset break
call writestring
call crlf
mov edx,offset ask1
call writestring
;mov edx,offset decryptbuffer
;mov ecx,sizeof decryptbuffer
;call readstring
mov edi,offset decryptbuffer
start1:
 call readdec
cmp eax,0
je outofloop
stosd
jmp start1
outofloop:
mov eax,0
mov edx,offset ask2
call writestring
call readdec
mov newN,eax
call crlf
mov edx,offset ask3
call writestring
call readdec
mov newD,eax
call crlf
;mov edx,offset ask4
;call writestring
;call readdec
;mov newE,eax
mov edx,offset decrypttext
call writestring
  mov esi,offset decryptbuffer
  ;mov edi,offset newdecryptbuffer		
l12:
lodsd
cmp eax,0
je ret2
mov newC,eax
invoke modPower , newC,newD,newN,ans2
call writechar
jmp l12
ret2:
call crlf
ret
;call DumpRegs
newdecrypt1 ENDP

filedecrypt PROC
.data
decryptbuffer1 dword 100 DUP(?)
newdecryptbuffer1 dword 100 DUP(?)
newN1 dword ?
newD1 dword ?
newE1 dword ?
newC1 dword ?
;ask1 byte "Enter String to decrypt:",0
;break byte "Press 0 when all the string is enterted:",0
decrypttext1 byte "Your Decrypted Text:",0
ask22 byte "Enter N:",0
ask33 byte "Enter D(Private Key):",0
;ask4 byte "Enter E:",0
ans21 dword 1
.code

;mov filehandle,eax
mov edx,OFFSET filename
call OpenInputFile
mov filehandle, EAX
mov edx, OFFSET decryptbuffer1 ;buffer will contain the text read from the file
mov ecx, 100 ;specify how many bytes to read
call ReadFromFile
mov edx, OFFSET decryptbuffer1
call writestring
Call crlf
mov eax,0
mov edx,offset ask22
call writestring
call readdec
mov newN1,eax
call crlf
mov edx,offset ask33
call writestring
call readdec
mov newD1,eax
call crlf
;mov edx,offset ask4
;call writestring
;call readdec
;mov newE,eax
mov edx,offset decrypttext1
call writestring
  mov esi,offset decryptbuffer1
  ;mov edi,offset newdecryptbuffer1	
l12:
lodsd
cmp eax,0
je ret2
mov newC1,eax
invoke modPower , newC1,newD1,newN1,ans21
call writechar
jmp l12
ret2:
call crlf
ret
;call DumpRegs
filedecrypt ENDP




checkPrime PROC, prime1:dword,m:dword,i1:dword,flag:dword
.data
;m dword 0
;i1 dword 2
;flag dword 0
.code
mov edx,0
mov eax,prime1
div i1
mov m,eax
level1:
mov eax,m
cmp i1,eax
ja level2
mov edx,0
mov eax,prime1
div i1
cmp edx,0
je level3
inc i1
jmp level1
level2:
;cmp flag,0
;jne level3
mov flag,0
mov eax,flag
ret
level3:
mov flag,1
mov eax,flag
ret
checkPrime ENDP
END main