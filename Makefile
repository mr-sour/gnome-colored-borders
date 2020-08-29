all: colored-border.c
	gcc $(shell pkg-config --cflags --libs gtk+-3.0) -std=gnu11 -fPIC -shared colored-border.c -o colored-border.so