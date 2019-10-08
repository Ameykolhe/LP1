src="./src/"
include="./include"
build="./build/"
bin="./bin/"
targetfile="main"

echo -e "-------- BUILDING --------\n"
echo -e "--- Compiling\n"
for file in ./src/*.cpp; do
    echo $file
    g++ -c $file -o $build$(basename $file .cpp).o -I $include
done


echo -e "\n--- Linking\n"
g++ $build*.o -o $bin$targetfile



echo -e "----- BUILD COMPLETE ------"