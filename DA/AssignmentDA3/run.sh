echo "------------------- Compiling -----------------------"
javac count.java
echo "Compilation Sucessful"
echo "------------------ Creating Jar ---------------------"
jar -cvf myCounter.jar *.class
echo "----------------- Executing Prog --------------------"
hadoop jar myCounter.jar count input.txt MRDir
echo "-------------------- Results ------------------------"
hdfs dfs -cat  MRDir/part-r-00000