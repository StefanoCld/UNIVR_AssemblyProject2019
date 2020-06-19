.section .data
    title:  .string "\nOPERAZIONI DISPONIBILI\n"
    line:   .string "----------------------\n"
    opz1:   .string "1) stampa a video del vettore inserito\n"
    opz2:   .string "2) stampa a video del vettore inserito in ordine inverso\n"
    opz3:   .string "3) stampa il numero di valori pari e dispari inseriti\n"
    opz4:   .string "4) stampa la posizione di un valore inserito dall'utente\n"
    opz5:   .string "5) stampa il massimo valore inserito\n"
    opz6:   .string "6) stampa la posizione del massimo valore inserito\n"
    opz7:   .string "7) stampa il minimo valore inserito\n"
    opz8:   .string "8) stampa la posizione del minimo valore inserito\n"
    opz9:   .string "9) stampa il valore inserito con maggior frequenza\n"
    opz10:  .string "10) stampa la media intera dei valori inseriti\n"

    char_stampa:    .string "%3d"
    scanf_int:      .string "%d"
    fattore:        .long 4
    num_pari:       .string "Pari: %d \n"
    num_dispari:    .string "Dispari: %d \n"
    input_message:  .string "Inserire l'intero in posizione %d: "
    vet_dim:        .long 0

# dichiarazione funzioni globali
.section .text
    .global inserimento_ext
    .global flush
    .global stampa_opz_ext
    .global stampa_ord_ext
    .global stampa_inv_ext
    .global conta_pari_dispari_ext
    .global trova_valore_ext
    .global trova_max_ext
    .global posizione_max_ext
    .global trova_min_ext
    .global posizione_min_ext
    .global frequenza_max_ext
    .global valore_medio_ext

# dichiarazioni funzioni
.type inserimento_ext, @function
.type flush, @function
.type stampa_opz_ext, @function
.type stampa_ord_ext, @function
.type stampa_inv_ext, @function
.type isPari, @function
.type conta_pari_dispari_ext, @function
.type trova_valore_ext, @function
.type trova_max_ext, @function
.type posizione_max_ext, @function
.type trova_min_ext, @function
.type posizione_min_ext, @function
.type frequenza_max_ext, @function
.type valore_medio_ext, @function

flush: 
    pushl stdout
    call fflush
    addl $4, %esp
ret

inserimento_ext:
    pushl %ebx                      # salvo il puntatore al vettore nella pila
    movl %ecx, %ebx                 # sposto la dimensione del vettore in %ebx
    movl $0, %esi                   # carico 0 in %esi [utilizzato per la stampa dell'indice]
    ciclo_inserimento:
        incl %esi                   # incremento %esi
        pushl %esi                  # caricamento %esi in pila
        pushl $input_message        # caricamento messaggio in pila
        call printf                 # stampa messaggio
        addl $8, %esp               # ritorno al punto giusto nella pila [equivale a due pop]
                                    # raggiungo il puntatore del vettore nella pila
        movl (%esp), %eax           # carico il puntatore del vettore nella pila in %eaxs
        pushl (%esp)                # carico nella pila l'elemento del vettore
        pushl $scanf_int            # carico nella pila il carattere di scansione (%d)
        call scanf                  # chiamo la funzione di scanf
        addl $8, %esp               # ritorno al punto giusto nella pila
        addl $4, (%esp)             # incremento il puntatore nella pila di 4 bit [long]
        cmp %ebx, %esi              # controllo se sono arrivato alla fine del vettore
    jl ciclo_inserimento            # se l'indice è minore della dimensione del vettore continua il ciclo
    addl $4, %esp                   # scendo nella pila al valore necessario per tornare al main
ret

# stampa opzioni
stampa_opz_ext:
    pushl $title
    call printf
    pushl $line
    call printf
    pushl $opz1
    call printf
    pushl $opz2
    call printf
    pushl $opz3
    call printf
    pushl $opz4
    call printf
    pushl $opz5
    call printf
    pushl $opz6
    call printf
    pushl $opz7
    call printf
    pushl $opz8
    call printf
    pushl $opz9
    call printf
    pushl $opz10
    call printf
    addl $48, %esp                  # scendo nella pila al valore necessario al ret
ret

# 1 - stampa a video del vettore inserito

stampa_ord_ext:
    movl %ecx, vet_dim              # salvo nella variabile vet_dim la dimensione del vettore
    movl $(0), %esi                 # carico 0 in %esi (utilizzato come indice)
    ciclo_stampa_ord:           
        pushl (%ebx, %esi, 4)       # carico nella pila il valore corrente indicato dall'indice     
        pushl $char_stampa          # carico il carattere di stampa in pila
        call printf                 # chiamo la funzione di stampa
        addl $8, %esp               # torno alla posizione corretta della pila
        incl %esi                   # incremento l'indice
        cmp vet_dim, %esi           # continuo finchè non raggiungo la fine del vettore
    jl ciclo_stampa_ord             
    call flush                      # chiamo la funzione flush per liberare il buffer (Questione di Debug)
ret

# 2 - stampa a video del vettore inserito in ordine inverso

stampa_inv_ext:
	movl %ecx, %esi                 # carico in %esi la dimensione del vettore
    ciclo_stampa_inv:
        decl %esi                   # decremento l'indice
        pushl (%ebx, %esi, 4)       # carico nella pila il valore corrente indicato dall'indice     
        pushl $char_stampa          # carico il carattere di stampa in pila
        call printf                 # chiamo la funzione di stampa
        addl $8, %esp               # torno alla posizione corretta della pila
        cmp $0, %esi                # continuo finchè non raggiungo il primo valore dell'array ovvero l'indice a 0
    jg ciclo_stampa_inv
    call flush                      # chiamo la funzione flush per liberare il buffer
ret

# 3 - stampa il numero di valori pari e dispari inseriti

conta_pari_dispari_ext:
    pushl $0                        # dispari = 0
    pushl $0                        # pari = 0
    pushl %ebx                      # puntatore primo valore del vettore
    ciclo_conta_pari_dispari:
        movl (%esp), %eax           # carico l'indirizzo del vettore in %eax
        movl (%eax), %eax           # carico il valore del vettore in %eax
        pushl %ecx                  # salvo %ecx perche in isPari lo perdo con la divisione
        call isPari                 # Numero -> %eax
                                    # Risultato -> %eax
        popl %ecx                   # riprendo indice e risalvo in %ecx
        cmp $1, %eax                # controllo se e pari
        je pari_inc                 # se pari salto nell' etichetta pari_inc
            addl $8, %esp           # raggiungo il contatore dispari nella pila
            incl (%esp)             # incremento di 1 il valore
            subl $8, %esp           # ritorno al indirizzo del vettore
            jmp avanti
        pari_inc:
            addl $4, %esp           # raggiungo il contatore pari nella pila
            incl (%esp)             # incremento di 1 il valore
            subl $4, %esp           # ritorno al indirizzo del vettore
        avanti:
        addl $4, (%esp)             # incremento il puntatore
    loop ciclo_conta_pari_dispari

    addl $4, %esp                   # raggiungo il valore pari nella pila
    pushl $num_pari                 # aggiungo la stringa pari per stampare
    call printf                     # chiamo la funzione C stampa
    addl $8, %esp                   # raggiungo il valore dispari nella pila
    pushl $num_dispari              # aggiungo la stringa dispari per stampare
    call printf                     # chiamo la funzione C stampa
    addl $8, %esp                   # raggiungo il valore per il return              
ret

# funzione extra isPari - 1 se pari - 0 se dispari

isPari:
    movl $0, %edx                   # azzero %edx (dividendo)
    movl $2, %ecx                   # assegno il divisore
    divl %ecx                       # divido 

    cmp $0, %edx                    # comparo il resto
    je pari                         # se resto = 0 pari
        movl $0, %eax               # %eax = 0 se dispari
    ret
    pari:
        movl $1, %eax               # %eax = 1 se pari
ret

# 4 - stampa la posizione di un valore inserito dall'utente

trova_valore_ext:
    movl $(1), %eax                 # metto la prima posizione in %eax         
    ciclo_trova_valore:
        cmp (%ebx), %edx            # comparo il valore corrente dell'array con il valore da trovare contenuto in %edx
        je trovato                  # se lo trova torna al main con la posizione presente in %eax
        incl %eax                   # incrementa la posizione 
        addl $4, %ebx               # incrementa il puntatore
    loop ciclo_trova_valore         
    movl $(-1), %eax                # se completata la lettura il valore non viene trovato verrà restituito -1
    ret
    trovato:
ret

# 5 - stampa il massimo valore inserito
trova_max_ext:
    movl (%ebx), %eax               # carico il primo valore del vettore in %eax, registro che contiene il valore massimo
    addl $4, %ebx                   # incremento il puntatore del vettore per andare al secondo valore e cominciare il ciclo da quello
    decl %ecx                       # in %ecx è presente la dimensione del vettore
    ciclo_trova_max:
        cmp %eax, (%ebx)            # compara il numero massimo con il numero corrente
        jle continua_trova_max      # se è minore o uguale al massimo incrementa il puntatore e continua il ciclo
            movl (%ebx), %eax       # se è maggiore sostituisce al massimo in %eax il nuovo valore
        continua_trova_max:
        addl $4, %ebx               # incremento il puntatore del vettore
    loop ciclo_trova_max
ret

# 6 - stampa la posizione del massimo valore inserito
posizione_max_ext:
    movl (%ebx), %eax               # carico il primo valore del vettore in %eax, registro che contiene il valore massimo
    addl $4, %ebx                   # incremento il puntatore dell'array per andare al secondo valore e cominciare il ciclo da quello
    decl %ecx                       # in %ecx è presente la dimensione del vettore
    movl $1, %esi                   # carico in %esi la posizione del valore massimo
    movl %esi, %edx                 # carico il valore di %esi in %edx
    ciclo_posizione_max:
        incl %esi                   # incremento %esi
        cmp %eax, (%ebx)            # compara il numero massimo con il numero corrente
        jle continua_posizione_max  # se è minore o uguale al massimo incrementa il puntatore e continua il ciclo
            movl (%ebx), %eax       # se è maggiore sostituisce al massimo il nuovo valore
            movl %esi, %edx         # e sostituisce a %edx la nuova posizione
        continua_posizione_max:
            addl $4, %ebx           # incremento il puntatore del vettore
    loop ciclo_posizione_max
    movl %edx, %eax                 # carico la posizione del valore massimo presente in %edx in %eax perché questo è lo standard seguito
ret

# 7 - stampa il minimo valore inserito
trova_min_ext:
    movl (%ebx), %eax               # carico il primo valore del vettore in %eax, registro che contiene il valore minimo
    addl $4, %ebx                   # incremento il puntatore dell'array per andare al secondo valore e cominciare il ciclo da quello
    decl %ecx                       # in %ecx è presente la dimensione del vettore
    ciclo_trova_min:
        cmp %eax, (%ebx)            # compara il numero minimo con il numero corrente
        jge continua_trova_min      # se è maggiore o uguale al minimo incrementa il puntatore e continua il ciclo
            movl (%ebx), %eax       # se è minore sostituisce al minimo in %eax il nuovo valore
        continua_trova_min:
        addl $4, %ebx               # incremento il puntatore del vettore
    loop ciclo_trova_min
ret

# 8 - stampa la posizione del minimo valore inserito
posizione_min_ext:
    movl (%ebx), %eax               # carico il primo valore del vettore in %eax, registro che contiene il valore minimo
    addl $4, %ebx                   # incremento il puntatore del vettore per andare al secondo valore e cominciare il ciclo da quello
    decl %ecx                       # in %ecx è presente la dimensione del vettore e viene decrementata
    movl $1, %esi                   # carico in %esi la posizione del valore minimo
    movl %esi, %edx                 # carico il valore di %esi in %edx
    ciclo_posizione_min:
        incl %esi                   # incremento %esi
        cmp %eax, (%ebx)            # compara il numero minimo con il numero corrente
        jge continua_posizione_min  # se è maggiore o uguale al massimo incrementa il puntatore e continua il ciclo
            movl (%ebx), %eax       # se è minore sostituisce al massimo il nuovo valore
            movl %esi, %edx         # e sostituisce a %edx la nuova posizione
        continua_posizione_min:
            addl $4, %ebx           # incremento il puntatore del vettore
    loop ciclo_posizione_min
    movl %edx, %eax                 # carico la posizione del valore minimo presente in %edx in %eax perché questo è lo standard seguito
ret

# 9 - stampa il valore inserito con maggior frequenza
frequenza_max_ext:
    pushl %ebx                      # carico indirizzo del vettore sulla pila 
    pushl %ebx                      # carico ancora l'indirizzo del vettore sulla pila

    movl $(-1), %eax                # carico il valore -1 in %eax   -> Frequenza massima
    movl $(0), %ebx                 # carico 0 in ebx               -> Frequenza relativa
    movl $(0), %edx                 # carico 0 in edx               -> Valore frequenza
    movl $(0), %esi                 # carico 0 in %esi, indice ciclo esterno
    movl $(0), %edi                 # carico 0 in %esi, indice ciclo esterno

    ciclo_1:               
        incl %esi                   # incremento valore in %esi
        movl $0, %edi               # carico 0 in %edi, indice interno, caricamento all'interno del ciclo per ripartire ogni fine ciclo interno
        ciclo_2:                
            incl %edi               # incremento valore in %edi
            pushl %eax              # salvo nella pila %eax perché poi lo perdo
            pushl %edx              # salvo nella pila %edc perché poi lo perdo
            addl $8, %esp           # scendo nella pila fino al puntatore del vettore nel ciclo interno
            movl (%esp), %eax       # carico il valore del puntatore del ciclo interno in %eax
            addl $4, %esp           # scendo nella pila fino al puntatore del vettore nel ciclo esterno
            movl (%esp), %edx       # carico il valore del puntatore del ciclo esterno in %eax

            # trasformo i puntatori in numeri prima del cmp
            movl (%eax), %eax
            movl (%edx), %edx
            
            cmp %edx, %eax          # controllo i due numeri
            je incrementa_freq      # se uguali incrementa la frequenza del numero
                jmp continua_ciclo2 # altrimenti continua il ciclo senza incremento
            incrementa_freq:        
                incl %ebx           # incremento frequenza in %ebx
            continua_ciclo2:
                subl $4, %esp       # scende nella pila nel valore del puntatore del vettore interno
                addl $4, (%esp)     # incrementa il puntatore del vettore interno
                subl $8, %esp       # salgo la pila fino al valore %edx
                popl %edx           # ricarico in %edx il valore della frequenza max
                popl %eax           # ricarico in %eax la frequenza massima
            cmp %ecx, %edi          
        jl ciclo_2                  # ripeto tutto fino alla fine del vettore interno

                                    # finita la lettura...
        addl $4, %esp               # scendo al puntatore del vettore esterno nella pila
        cmp %eax, %ebx              # comparo la frequenza massima con la frequenza corrente
        jg aggiorna_val_freq        # se la frequenza corrente è maggiore sostituisco la frequenza massima
        jmp continua_dopo           # altrimenti non si aggiorna nulla e si continua 
        aggiorna_val_freq:          
            movl %ebx, %eax         # carico il valore della nuova frequenza nel registro della frequenza massima (%eax)
            movl (%esp), %edx       # carico l'indirizzo del nuovo valore massimo in %edx
            movl (%edx), %edx       # carico il valore del vettore esterno in %edx, registro che contiene il valore massimo ripetuto
        continua_dopo:              # altrimenti
        addl $4, (%esp)             # incremento il puntatore al vettore esterno
        subl $4, %esp               # salgo nella pila
        movl $0, %ebx               # carico 0 in %ebx

        pushl %edx                  # salvo nella pila il registro %edx, corrotto poi dalla moltiplicazione
        pushl %eax                  # salvo nella pila il registro %eax, corrotto poi dalla moltiplicazione
        addl $8, %esp               # scendo nella pila al puntatore al vettore interno
        movl %ecx, %eax             # carico %ecx, dimensione del vettore, in %eax
        mull fattore                # moltiplico la dimensione del vettore per il fattore (4) per sapere di quanti blocchi spostarmi per ritornare al primo valore del vettore
        subl %eax, (%esp)           # decremento il risultato al puntatore del vettore interno
        subl $8, %esp               # salgo nella pila per recuperare i registri
        popl %eax                   # ricarico in %eax la frequenza massima
        popl %edx                   # ricarico in %edx il valore della frequenza max

        cmp %ecx, %esi             
    jl ciclo_1                      # ripeto tutto fino alla fine del vettore esterno

    movl %edx, %eax                 # carico in %eax il valore più frequente presente nel registro %edx

    addl $8, %esp                   # scendo nella pila per avere il puntatore di ritorno al main
ret

# 10 - stampa la media intera dei valori inseriti
valore_medio_ext:
    movl $0, %eax               # carica 0 in %eax, registro in cui sommare gli elementi del vettore
    pushl %ecx                  # salvo nella pila %ecx, utilizzato poi per la divisione nella media ma utilizzato anche con il loop
    ciclo_media:                
        addl (%ebx), %eax       # sommo il valore del vettore al registro %eax
        addl $4, %ebx           # incremento il puntatore del vettore
    loop ciclo_media
    popl %ecx                   # riprendo dalla pila %ecx
    cdq                         # comando utilizzato per le divisioni con segno es. edx = 0xFFFFF..
    idivl %ecx                  # divisione con risultato in %eax
ret
