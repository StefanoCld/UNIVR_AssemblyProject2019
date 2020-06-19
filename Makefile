AS = as -g --32 
LD = ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc
MAIN = GestioneVettore
EXT = Array

all:
	$(AS) -o $(MAIN).o $(MAIN).s
	$(AS) -o $(EXT).o $(EXT).s
	$(LD) $(MAIN).o $(EXT).o -o $(MAIN).x 
clean:
	rm -f *.o *.x 
