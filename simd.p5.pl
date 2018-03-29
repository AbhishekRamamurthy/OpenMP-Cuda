#!/usr/bin/perl
use strict;
use warnings;
use Excel::Writer::XLSX;

my $filename=$ARGV[0];
chomp($filename);

my $workbook  = Excel::Writer::XLSX->new('SimdP5.xlsx');
my $worksheet = $workbook->add_worksheet();
my $row =0;
my $col=0;
my @arraysize=("1000","2000","4000","8000","16000","32000","64000","128000");
$worksheet->write($row,$col,"ArraySize");
$col++;
foreach my $size (@arraysize) {

	$worksheet->write($row,$col,$size."_SimdMul");	
	$col++;
	$worksheet->write($row,$col,$size."_SimdMulSum");	
	$col++;
	$worksheet->write($row,$col,$size."_Sum");	
	$col++;
}
$row++;
$col=0;

$worksheet->write($row,$col,"WithSSE");	
$col++;
foreach my $sizenew (@arraysize) {

	`g++ -o $filename $filename.cpp -lm -fopenmp -DNUM=$sizenew`;
	
	my $output=`./$filename`;
	my ($a,$b,$c)=split(/,/,$output);
	my ($d,$e)=split(/=/,$a);
	my ($f,$g)=split(/=/,$b);
	my ($h,$i)=split(/=/,$c);
	chomp($e);
	$worksheet->write($row,$col,$e);	
	$col++;
	chomp($g);
	$worksheet->write($row,$col,$g);	
	$col++;
	chomp($i);
	$worksheet->write($row,$col,$i);	
	$col++;
}

$col=0;
$row++;
$worksheet->write($row,$col,"WithoutSSE");	
$col++;
foreach my $sizenew (@arraysize) {
	`g++ -o $filename.nonsse $filename.nonsse.cpp -lm -fopenmp -DNUM=$sizenew`;
	
	my $output=`./$filename.nonsse`;
	my ($a,$b,$c)=split(/,/,$output);
	my ($d,$e)=split(/=/,$a);
	my ($f,$g)=split(/=/,$b);
	my ($h,$i)=split(/=/,$c);
	chomp($e);
	$worksheet->write($row,$col,$e);	
	$col++;
	chomp($g);
	$worksheet->write($row,$col,$g);	
	$col++;
	chomp($i);
	$worksheet->write($row,$col,$i);	
	$col++;
}
$workbook->close;
