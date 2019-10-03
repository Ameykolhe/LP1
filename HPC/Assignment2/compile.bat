nvcc -c vec_add.cu -o vec_add.obj
nvcc -c mat_vec_mul.cu -o mat_vec_mul.obj
nvcc -c mat_mul.cu -o mat_mul.obj
nvcc -c assignmentHPC2.cu -o assignmentHPC2.obj
nvcc assignmentHPC2.obj vec_add.obj mat_vec_mul.obj mat_mul.obj -o main