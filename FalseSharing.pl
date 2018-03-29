#!/usr/bin/perl
use strict;
use warnings;
use Excel::Writer::XLSX;

my $filename=$ARGV[0];
chomp($filename);

my $workbook  = Excel::Writer::XLSX->new('FalseSharing.xlsx');
my $worksheet = $workbook->add_worksheet();
my $row =0;
my $col=0;

my $base=0.0;
my $speedup=0.0;

my @threads=(1,2,4,6);
my @pads=(0..15);
$worksheet->write($row,$col,"Thread Count");
$col++;

foreach my $pad (@pads) {

	$worksheet->write($row,$col,$pad);
	$col++;
	$worksheet->write($row,$col,"speedup_".$pad);
	$col++;
}

$col=0;
$row++;

foreach my $t (@threads) {
	
	$worksheet->write( $row,$col,$t);
	$col++;

	foreach my $pad (@pads) {
		
		`gcc -o $filename $filename.c -lm -fopenmp -DNUMPAD=$pad -DNUMT=$t`;
		print "Total thread number =". $t. " Pad = $pad , threads = $t\n";
		my $output=`./$filename`;
		my ($a,$b)=split(/=/,$output);
		$b=~ s/^\s+|\s+^//g;
		$worksheet->write($row,$col,$b);
		$col++;

		if($base  == 0.0) {

			$base=$b;
			$col++;
		} else {

			$speedup=$base/$b;
			$worksheet->write($row,$col,$speedup);
			$col++;
		}
		sleep(1);
	}
	
	$row++;
	$col=0;
	$base=0.0;
}

$workbook->close;
