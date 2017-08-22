#!/bin/sh

ORIGDIR=$PWD

# find direectory containing this script and change to it
CORFUNCDIR=`dirname $0`
cd $CORFUNCDIR

# launch Corfunc with necessary classpath
java -cp .:corfunc.jar:graph.jar:jh.jar:jai_core.jar:jai_codec.jar CorfuncGui

# return to original pwd
cd $PWD
