#!/usr/bin/perl


my $glob_command = '*.java';
my @files = `ls $glob_command`;
my $tar_cmd = 'tar cvf java_src.tar ';
my $dir = ' c:\\matt\\java\\';

push(@files,' data');
push(@files,' Makefile');

foreach my $i (@files)
  {
  if ($i =~ /(\S+)/)
    {
    $tar_cmd = $tar_cmd.$dir.$1;
    }
  }

# print "$tar_cmd\n";
`$tar_cmd`;
