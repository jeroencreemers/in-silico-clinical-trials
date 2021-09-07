all : tumormodel 

tumormodel : model.cpp
	g++-9 -O2 -I /usr/local/Cellar/boost/1.71.0/include/ $<  -o $@

clean: 
	rm tumormodel


