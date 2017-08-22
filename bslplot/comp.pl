#!/usr/bin/perl


# generates 'comp.bat' file for compiling source on Win32

my $file = 'comp.bat';
my $javac_cmd = 'javac ';
my $java_extension = '.java ';

my @file_array = ('XYDataPoint',
                  'ReadTextFile',
                  'GetDouble',
                  'GetDoublePairs',
                  'GetIdxShift',
                  'GetPlotXFromX',
                  'GetPlotYFromY',
                  'OrderVector',
                  'GetUnorderedXYDataFileVector',
                  'GetOrderedXYDataFileVector',
                  'GetUnorderedYDataFileVector',
                  'GetOrderedYDataFileVector',
                  'SetPlottable',
                  'CreateFullPointCurve',
                  'bslp_single_panel',
                  'bslp_single_panel_test');  
                 

open(FILE, ">$file");
my $cmd;
 
foreach my $i (@file_array)
  {
  $cmd = $javac_cmd.$i.$java_extension;
  print FILE $cmd."\n";
  }

close FILE;

