nvcc -c find_max.cu -o find_max.obj
nvcc -c find_min.cu -o find_min.obj
nvcc -c find_sum.cu -o find_sum.obj
nvcc -c find_sd.cu -o find_sd.obj
nvcc -c assignmentHPC1.cu -o assignmentHPC1.obj

nvcc -o main assignmentHPC1.obj find_max.obj find_min.obj find_sum.obj find_sd.obj