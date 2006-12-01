@echo Starting corfunc
@echo off

REM ************************************************************
REM * Change the following two lines to point to the corfunc   *
REM * executables and Java jar files                           *
REM *                                                          *
REM * Enclosing the path in "" is essential if installing to a *
REM * folder with a space in its name; e.g. Program Files      *
REM ************************************************************

set CORFUNC_JAVA_PATH="U:\corfunc\corfunc_src"

set CORFUNC_FORT_PATH="U:\corfunc\corfunc_src"



REM ************************************************************
REM * These shouldn't need editing ...                         *
REM *                                                          *
REM * Change the following line to point to the directory      *
REM * containing jh.jar                                        *
REM ************************************************************

set CORFUNC_JAVA_HELP=%CORFUNC_JAVA_PATH%

REM ************************************************************
REM * Change the following line to point to the directory      *
REM * containing jai_core.jar and jai_codec.jar                *
REM ************************************************************

set CORFUNC_JAVA_IMAG=%CORFUNC_JAVA_PATH%



REM ************************************************************
REM * Do not edit the following ...                            *
REM ************************************************************

set PATH=%PATH%;%CORFUNC_FORT_PATH%

java -cp %CORFUNC_JAVA_PATH%;%CORFUNC_JAVA_PATH%\corfunc.jar;%CORFUNC_JAVA_PATH%\graph.jar;%CORFUNC_JAVA_HELP%\jh.jar;%CORFUNC_JAVA_IMAG%\jai_core.jar;%CORFUNC_JAVA_IMAG%\jai_codec.jar CorfuncGui
REM java -cp %CORFUNC_JAVA_PATH%;%CORFUNC_JAVA_PATH%\corfunc.jar CorfuncGui

@echo on
