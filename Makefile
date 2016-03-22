all: compile

compile:
	# ../../../Documents/jflex-1.6.1/bin/jflex scanner.flex
	jflex scanner.flex
	java -jar java-cup-11b.jar -interface -parser Parser parser.cup
	javac -cp java-cup-11b-runtime.jar *.java

execute:
	java -cp java-cup-11b-runtime.jar:. Main

clean:
	rm -f *.class *~
	rm -f Parser.java Scanner.java sym.java
