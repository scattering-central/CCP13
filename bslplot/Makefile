
JAVAC = /usr/java/j2sdk1.4.0/bin/javac 
JAVA = /usr/java/j2sdk1.4.0/bin/java 

SRC = 	XYDataPoint.class \
	ReadTextFile.class \
	GetDouble.class \
	GetDoublePairs.class \
	GetIdxShift.class \
	GetPlotXFromX.class \
	GetPlotYFromY.class \
	OrderVector.class   \
	GetUnorderedXYDataFileVector.class \
	GetUnorderedYDataFileVector.class \
	GetOrderedXYDataFileVector.class \
	GetOrderedYDataFileVector.class \
	SetPlottable.class \
	CreateFullPointCurve.class \
	bslp_single_panel.class \
	bslp_single_panel_test.class \

%.class: %.java 
	${JAVAC} $<  


thingy: ${SRC}
	ls -l ${SRC}

go: bslp_single_panel.class
	${JAVA} bslp_single_panel_test

clean:
	rm *.class


