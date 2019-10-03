#define variables
objects= main.obj findmax.obj copy.obj 
NVCC= nvcc               #cuda c compiler
execname= main
opt= -c


#compile
$(execname): $(objects)
	$(NVCC) -o $(execname) $(objects)

findmax.obj: findmax.cu
	$(NVCC) $(opt) findmax.cu

findmin.obj: findmin.cu
	$(NVCC) $(opt) findmin.cu

copy.obj: copy.cu
	$(NVCC) $(opt) copy.cu

main.obj: main.cu
	$(NVCC) -c main.cu


#clean
clean:
	del *.obj *.lib *.exe
