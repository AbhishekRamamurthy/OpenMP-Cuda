#!/usr/bin/perl
use strict;
use warnings;

my $filename=$ARGV[0];
chomp($filename);

my @threads=(1,4);

foreach my $t (@threads) {
	system("gcc -o ".$filename." ".$filename.".c -lm -fopenmp -DNUMT=".$t);
	print "Total thread number =". $t."\n";
	system("./".$filename);
	print "="x80;
	print "\n";
}
