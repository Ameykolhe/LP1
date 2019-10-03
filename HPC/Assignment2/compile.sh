nvcc -c vec_add.cu -o vec_add.o
nvcc -c assignmentHPC2.cu -o assignmentHPC2.o
nvcc assignmentHPC2.o vec_add.o -o main