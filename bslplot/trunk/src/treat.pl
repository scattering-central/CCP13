

open(FILE,"data2");
my @in = <FILE>;
close FILE;

open(FILE,">data");
foreach my $i (@in)
  {
  if ($i =~ /^(.+)E.*E/)
    {
    $line = $1;
    print FILE $line."\n"; 
    }
  }
close FILE;

