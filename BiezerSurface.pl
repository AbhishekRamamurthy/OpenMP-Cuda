#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Excel::Writer::XLSX;

my $filename=$ARGV[0];
chomp($filename);


my $workbook  = Excel::Writer::XLSX->new( 'BiezerSurface.xlsx' );
my $worksheet = $workbook->add_worksheet();
my $row=0;
my $col=0;
my @threads=(1,2,4,6,8,10,12,14,16);
my @NUMNODES=(4,16,32,64,128,256,512,1024,2048,4096,8192,16384);
my $speedup=0.0;
my $base_time=0.0;


$worksheet->write( $row,$col,"Threads");
$col++;
$worksheet->write( $row,$col,"Nodes");
$col++;
$worksheet->write( $row,$col,"Volume");
$col++;
$worksheet->write( $row,$col,"Execution Time");
$col++;
$worksheet->write( $row,$col,"speedup");
$col++;
$worksheet->write($row,$col,"Parallel Fraction");
$col=0;
$row++;

foreach my $NUMNODE (@NUMNODES) {
	$base_time=0.0;
	
	foreach my $t (@threads) {  	
		my $Fp=0.0;	
		`gcc -o $filename $filename.c -lm -fopenmp -DNUMT=$t -DNUMNODES=$NUMNODE`;
		print "Number of Nodes = ".$NUMNODE." Number of threads = ". $t."\n";
		my $line = `./$filename`;
		print "="x80;
		print "\n";
		sleep(2);
		chomp($line);
		
		my ($a,$b)=split /,/,$line;
		my ($c,$d)= split /=/,$a;
		$d=~ s/^\s+|\s+$//g;
		$worksheet->write( $row,$col,$t);
		$col++;
		$worksheet->write($row,$col,$NUMNODE);
		$col++;
		$worksheet->write($row,$col,$d);
		$col++;
			
		($c,$d)= split /=/,$b ;
		$d=~ s/^\s+|\s+$//g;

		if ($base_time == 0) {
			
			$base_time=$d;
		}
		
		$speedup=$base_time/$d;
		$worksheet->write($row,$col,$d);
		$col++;
		$worksheet->write($row,$col,$speedup);
		$col++;
		if($t != 1) {
			
			$Fp= ($t/($t-1)) * (1.0-(1.0/$speedup));
			$worksheet->write($row,$col,$Fp);
		} else {
			
			$worksheet->write($row.$col,"N/A");
		}

		$row++;
		$col=0;
	}
}
$workbook->close;
