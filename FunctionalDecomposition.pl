#!/usr/bin/perl
use strict;
use warnings;
use Excel::Writer::XLSX;

my $filename=$ARGV[0];
chomp($filename);

my $workbook  = Excel::Writer::XLSX->new('FunctionalDecomposition.xlsx');
my $worksheet = $workbook->add_worksheet();
my $row =0;
my $col=0;

$worksheet->write($row,$col,"GrainGrowth");
$col++;
$worksheet->write($row,$col,"DeerGrowth");
$col++;
$worksheet->write($row,$col,"Temp");
$col++;
$worksheet->write($row,$col,"Precipitation");
$col++;
$worksheet->write($row,$col,"KilledDeer");

$col=0;
$row++;

`gcc -o $filename $filename.c -lm -fopenmp `;
my @output=`./$filename`;
foreach my $line (@output) {
	my ($a,$b,$c,$d,$e)=split(/,/,$line);
	my ($f,$g)=split(/=/,$a);
	my ($h,$i)=split(/=/,$b);
	my ($j,$k)=split(/=/,$c);
	my ($l,$m)=split(/=/,$d);
	my ($n,$o)=split(/=/,$e);
	$g=~ s/^\s+|\s+^//g;
	$i=~ s/^\s+|\s+^//g;
	$k=~ s/^\s+|\s+^//g;
	$m=~ s/^\s+|\s+^//g;
	$o=~ s/^\s+|\s+^//g;
	$worksheet->write($row,$col,($g*2.54));
	$col++;
	$worksheet->write($row,$col,$i);
	$col++;
	$worksheet->write($row,$col,((5./9.)*($k-32)));
	$col++;
	$worksheet->write($row,$col,$m);
	$col++;
	$worksheet->write($row,$col,$o);
	$col=0;
	$row++;
}
$workbook->close;
