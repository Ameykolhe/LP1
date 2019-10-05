nvcc -c vec_add.cu -o vec_add.o
nvcc -c mat_vec_mul.cu -o mat_vc_mul.o
nvcc -c mat_mul.cu -o mat_mul.o
nvcc -c assignmentHPC2.cu -o assignmentHPC2.o
nvcc assignmentHPC2.o vec_add.o mat_vc_mul.o mat_mul.o -o main
