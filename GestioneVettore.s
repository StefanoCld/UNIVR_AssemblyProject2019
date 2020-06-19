.section .data
    vet:                        .long 0,0,0,0,0,0,0,0,0,0
    length:                     .long 10
    scelta:                     .long 0
    input_value:                .long 0

    scanf_int:                  .string "%d"
    input_message:              .string "\nInserire valore operazione (0 uscita, -1 ristampa menu'): "
    exit_message:               .string "Uscita dall'applicazione...\n"
    error_message:              .string "Numero non valido\n"
    found_message:              .string "Posizione del valore %d: %d \n"
    not_found_message:          .string "Valore %d non trovato \n"
    trova_max_message:          .string "Massimo valore inserito: %d\n"
    posizione_max_message:      .string "Posizione del massimo valore inserito: %d\n"
    trova_min_message:          .string "Minimo valore inserito: %d\n"
    posizione_min_message:      .string "Posizione del minimo valore inserito: %d\n"
    valore_medio_message:       .string "Valore medio array: %d\n"
    input_valore_message:       .string "Inserire l'intero da cercare: " 
    valore_freq_message:        .string "Valore inserito con maggior frequenza: %d\n"
    media_message:              .string "Media valori: %d \n"


.section .text
    .global _start

_start:
    leal vet, %ebx          # puntatore al vettore in %ebx
    movl length, %ecx       # lunghezza vettore in %ecx
    call inserimento_ext    # chiama l'inserimento presente nella funzione esterna

    call stampa_opz    

    ciclo:
        # stampa riga inserimento [printf]
        pushl $input_message
        call printf
        addl $4, %esp

        # legge il valore inserito [scanf]
        pushl $scelta
        pushl $scanf_int
        call scanf
        addl $8, %esp

        movl (scelta), %eax

        cmp $(0), %eax
        je fine

        cmp $(-1), %eax
        je stampa_opz

        cmp $(1), %eax
        je stampa_ord

        cmp $(2), %eax
        je stampa_inv

        cmp $(3), %eax
        je conta_pari_dispari 

        cmp $(4), %eax
        je trova_valore

        cmp $(5), %eax
        je trova_max

        cmp $(6), %eax
        je posizione_max

        cmp $(7), %eax
        je trova_min

        cmp $(8), %eax
        je posizione_min

        cmp $(9), %eax
        je frequenza_max

        cmp $(10), %eax
        je valore_medio

        # se maggiore di 10
        cmp $(11), %eax
        jge scelta_non_valida   # errore

        # se minore di -1
        cmp $(-2), %eax         
        jle scelta_non_valida   # errore   

scelta_non_valida:
    pushl $error_message            # caricamento errore e stampa
    call printf
    addl $4, %esp
    call flush                      # pulizia buffer
    call stampa_opz_ext             # stampa delle opzioni con la funzione esterna
jmp ciclo

stampa_opz:
    call stampa_opz_ext             # stampa delle opzioni con la funzione esterna
jmp ciclo

stampa_ord:
    leal vet, %ebx                  # carica puntatore del vettore nel registro %ebx
    movl length, %ecx               # carica la lunghezza del vettore nel registro %ecx
    call stampa_ord_ext             # chiamata della funzione esterna
jmp ciclo

stampa_inv:
    leal vet, %ebx                  # carica puntatore del vettore nel registro %ebx
    movl length, %ecx               # carica la lunghezza del vettore nel registro %ecx      
    call stampa_inv_ext             # chiamata della funzione esterna
jmp ciclo

conta_pari_dispari:
    leal vet, %ebx                  # carica puntatore del vettore nel registro %ebx
    movl length, %ecx               # carica la lunghezza del vettore nel registro %ecx      
    call conta_pari_dispari_ext     # chiamata della funzione esterna
jmp ciclo

trova_valore:
    pushl $input_valore_message     # stampa del messaggio che chiede in input il valore da cercare
    call printf
    addl $4, %esp
    pushl $input_value              # acquisizione del valore da cercare
    pushl $scanf_int
    call scanf
    addl $8, %esp
    leal vet, %ebx                  # carica puntatore del vettore nel registro %ebx
    movl length, %ecx               # carica la lunghezza del vettore nel registro %ecx  
    movl (input_value), %edx        # carica il numero da cercare nel registro %edx
    call trova_valore_ext           # chiama la funzione esterna
    
    cmp $(-1), %eax                 # compara il valore restituito dalla funzione
    je value_not_found              # se il valore è -1 non è presente il valore cercato
        pushl %eax                  
        pushl %edx
        pushl $found_message        # altrimenti stampo il messagio con la posizione del valore trovato
        call printf
        addl $12, %esp
        jmp continua
    value_not_found:
        pushl %edx
        pushl $not_found_message    # stampa del messaggio del valore non trovato
        call printf
        addl $8, %esp
    continua:
jmp ciclo

trova_max:
    leal vet, %ebx                  # carica puntatore del vettore nel registro %ebx
    movl length, %ecx               # carica la lunghezza del vettore nel registro %ecx   
    call trova_max_ext              # chiama la funzione esterna
    pushl %eax                      
    pushl $trova_max_message        # stampa il valore massimo trovato restituito nel registro %eax
    call printf 
    addl $8, %esp
jmp ciclo

posizione_max:
    leal vet, %ebx                  # carica puntatore del vettore nel registro %ebx
    movl length, %ecx               # carica la lunghezza del vettore nel registro %ecx  
    call posizione_max_ext          # chiama la funzione esterna
    pushl %eax                      
    pushl $posizione_max_message    # stampa il valore della posizione del valore massimo trovato restituito nel registro %eax
    call printf
    addl $8, %esp
jmp ciclo

trova_min:
    leal vet, %ebx                  # carica puntatore del vettore nel registro %ebx
    movl length, %ecx               # carica la lunghezza del vettore nel registro %ecx
    call trova_min_ext              # chiama la funzione esterna
    pushl %eax
    pushl $trova_min_message        # stampa il valore minimo trovato restituito nel registro %eax
    call printf
    addl $8, %esp
jmp ciclo

posizione_min:
    leal vet, %ebx                  # carica puntatore del vettore nel registro %ebx
    movl length, %ecx               # carica la lunghezza del vettore nel registro %ecx
    call posizione_min_ext          # chiama la funzione esterna
    pushl %eax
    pushl $posizione_min_message    # stampa il valore della posizione del valore minimo trovato restituito nel registro %eax
    call printf
    addl $8, %esp
jmp ciclo

frequenza_max:
    leal vet, %ebx                  # carica puntatore del vettore nel registro %ebx
    movl length, %ecx               # carica la lunghezza del vettore nel registro %ecx
    call frequenza_max_ext          # chiama la funzione esterna
    pushl %eax
    pushl $valore_freq_message      # stampa il valore più frequente restituito nel registro %eax
    call printf
    addl $8, %esp
jmp ciclo

valore_medio:
    leal vet, %ebx                  # carica puntatore del vettore nel registro %ebx
    movl length, %ecx               # carica la lunghezza del vettore nel registro %ecx
    call valore_medio_ext           # chiama la funzione esterna
    pushl %eax
    pushl $media_message            # stampa il valore della media restituito nel registro %eax
    call printf
    addl $8, %esp
jmp ciclo

fine:
    pushl $exit_message             # stampa del messaggio di uscita dall'applicazione
    call printf
    addl $4, %esp
    call flush                      # chiamata funzione esterna per liberare il buffer
    movl $1, %eax                   # carica 1 in %eax per la system call di uscita
    movl $0, %ebx                   # carica 0 in %ebx che è il codice di ritorno al sistema operativo
    int $0x80                       # esegue la system call di uscita
    