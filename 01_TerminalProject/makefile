CC=gcc
CFLAGS=-Wall -g
LIBS=-lncurses

SRC=Show.c
OBJ=$(SRC:.c=.o)
EXEC=Show

$(EXEC): $(OBJ)
	$(CC) $(OBJ) -o $(EXEC) $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f $(OBJ) $(EXEC)
