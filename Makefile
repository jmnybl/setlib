all: main

main: main.cpp tset.cpp tset.h
	g++ -o main main.cpp tset.cpp

clean:
	rm -f main

