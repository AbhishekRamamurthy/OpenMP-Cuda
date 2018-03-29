#!/usr/bin/perl
use strict;
use warnings;
use Excel::Writer::XLSX;
my $filename=$ARGV[0];
chomp($filename);

my $workbook  = Excel::Writer::XLSX->new('CoarseFine.xlsx');
my $worksheet = $workbook->add_worksheet();
my $row =0;
my $col=0;

my $speedup=0.0;
my $static=0.0;

my @threads=(1,2,4,6,8,10,12,14,16);
my @chunks=(1,4096);
my @types=("static","dynamic");

$worksheet->write( $row,$col,"Thread Count");
$col++;
$worksheet->write( $row,$col,"MegaMults_S1");
$col++;
$worksheet->write( $row,$col,"MegaMults_D1");
$col++;
$worksheet->write($row,$col,"MegaMults_S4096");
$col++;
$worksheet->write($row,$col,"MegaMults_D4096");

$col=0;
$row++;

foreach my $t (@threads) {
	
	$worksheet->write( $row,$col,$t);
	$col++;	
	foreach my $chunk (@chunks) {  
		
		foreach my $type (@types) {
				
			`gcc -o $filename $filename.c -lm -fopenmp -DNUMT=$t -DTYPE=$type -DCHUNK=$chunk`;
			print "Total thread number =". $t. " Chunk size = ".$chunk.
				  " Type = ".$type."\n";
			my $output=`./$filename`;
			my ($a,$b)=split(/=/,$output);
			$b=~ s/^\s+|\s+^//g;
			chomp($b);
			print "Peformance = $b MegaMults/Sec\n";
			$worksheet->write( $row,$col,$b);
			$col++;
			sleep(1);
		}
		$static=0.0;
	}
	$row++;
	$col=0;
}
