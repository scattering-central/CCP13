javac -classpath .\;U:\corfunc\corfunc_src\java\java_src\other_jars\jh.jar;U:\corfunc\corfunc_src\java\java_src\other_jars\jai_core.jar;U:\corfunc\corfunc_src\java\java_src\other_jars\jai_codec.jar;U:\corfunc\corfunc_src\java\java_src\other_jars\graph.jar *.java
jar cmf main.txt corfunc.jar *.class
copy U:\corfunc\corfunc_src\java\java_src\Corfunc.jar U:\corfunc\corfunc_src
del U:\corfunc\corfunc_src\java\java_src\Corfunc.jar
copy U:\corfunc\corfunc_src\java\java_src\other_jars\*.jar U:\corfunc\corfunc_src\*.jar
