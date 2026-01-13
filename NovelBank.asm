INCLUDE Irvine32.inc

MAX_NOVELS = 10
NAME_LEN   = 30
AUTHOR_LEN = 25

.data
menuStr BYTE "\n===== NOVEL BANK =====",0dh,0ah,
             "1. Add Novel",0dh,0ah,
             "2. Display Novels",0dh,0ah,
             "3. Borrow Novel",0dh,0ah,
             "4. Return Novel",0dh,0ah,
             "5. Exit",0dh,0ah,
             "Enter choice: ",0

promptID     BYTE "Enter Novel ID: ",0
promptName   BYTE "Enter Novel Name: ",0
promptAuthor BYTE "Enter Author Name: ",0
promptQty    BYTE "Enter Quantity: ",0
borrowMsg    BYTE "Enter Novel ID to borrow: ",0
returnMsg    BYTE "Enter Novel ID to return: ",0

addedMsg BYTE "Novel added successfully!",0dh,0ah,0
outMsg   BYTE "Novel not available!",0dh,0ah,0

novelCount  DWORD 0
novelID     DWORD MAX_NOVELS DUP(0)
novelQty    DWORD MAX_NOVELS DUP(0)
novelName   BYTE  MAX_NOVELS*NAME_LEN DUP(0)
novelAuthor BYTE  MAX_NOVELS*AUTHOR_LEN DUP(0)

choice DWORD ?

.code
main PROC

menu:
    mov edx, OFFSET menuStr
    call WriteString
    call ReadInt
    mov choice, eax

    cmp eax, 1
    je addNovel
    cmp eax, 2
    je displayNovels
    cmp eax, 3
    je borrowNovel
    cmp eax, 4
    je returnNovel
    cmp eax, 5
    je exitProgram
    jmp menu

; ---------- ADD NOVEL ----------
addNovel:
    mov eax, novelCount
    cmp eax, MAX_NOVELS
    jae menu

    ; Novel ID
    mov edx, OFFSET promptID
    call WriteString
    call ReadInt
    mov ebx, novelCount
    mov novelID[ebx*4], eax

    ; Novel Name
    mov edx, OFFSET promptName
    call WriteString
    mov esi, OFFSET novelName
    mov eax, novelCount
    imul eax, NAME_LEN
    add esi, eax
    mov ecx, NAME_LEN
    call ReadString

    ; Author Name
    mov edx, OFFSET promptAuthor
    call WriteString
    mov esi, OFFSET novelAuthor
    mov eax, novelCount
    imul eax, AUTHOR_LEN
    add esi, eax
    mov ecx, AUTHOR_LEN
    call ReadString

    ; Quantity
    mov edx, OFFSET promptQty
    call WriteString
    call ReadInt
    mov novelQty[ebx*4], eax

    inc novelCount
    mov edx, OFFSET addedMsg
    call WriteString
    jmp menu

; ---------- DISPLAY NOVELS ----------
displayNovels:
    mov ecx, novelCount
    mov ebx, 0

displayLoop:
    cmp ebx, ecx
    je menu

    ; ID
    mov eax, novelID[ebx*4]
    call WriteInt
    call Crlf

    ; Name
    mov esi, OFFSET novelName
    mov eax, ebx
    imul eax, NAME_LEN
    add esi, eax
    mov edx, esi
    call WriteString
    call Crlf

    ; Author
    mov esi, OFFSET novelAuthor
    mov eax, ebx
    imul eax, AUTHOR_LEN
    add esi, eax
    mov edx, esi
    call WriteString
    call Crlf

    ; Quantity
    mov eax, novelQty[ebx*4]
    call WriteInt
    call Crlf
    call Crlf

    inc ebx
    jmp displayLoop

; ---------- BORROW NOVEL ----------
borrowNovel:
    mov edx, OFFSET borrowMsg
    call WriteString
    call ReadInt

    mov ecx, novelCount
    mov ebx, 0

borrowLoop:
    cmp ebx, ecx
    je menu
    cmp eax, novelID[ebx*4]
    je checkQty
    inc ebx
    jmp borrowLoop

checkQty:
    cmp novelQty[ebx*4], 0
    jle outOfStock
    dec novelQty[ebx*4]
    jmp menu

outOfStock:
    mov edx, OFFSET outMsg
    call WriteString
    jmp menu

; ---------- RETURN NOVEL ----------
returnNovel:
    mov edx, OFFSET returnMsg
    call WriteString
    call ReadInt

    mov ecx, novelCount
    mov ebx, 0

returnLoop:
    cmp ebx, ecx
    je menu
    cmp eax, novelID[ebx*4]
    je doReturn
    inc ebx
    jmp returnLoop

doReturn:
    inc novelQty[ebx*4]
    jmp menu

exitProgram:
    exit

main ENDP
END main
