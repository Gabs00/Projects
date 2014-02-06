#!/usr/bin/perl

use strict;
use warnings;

my $go = 1;
while($go){	
	my $tobe;
	while(!($tobe)){
		print "Please enter a word or sentence to have the vowels counted: ";
		chomp ($tobe = <>);
	}

	my %counted = %{ counter($tobe) };

	print $tobe, "\n";
	my $total = 0;
	for(keys %counted){
		
		unless(/y/){
			print "$_->", $counted{$_}, "\n";
			$total+=$counted{$_};
		}
	} 

	print "Total Vowels: $total\n";

	if(defined($counted{'y'})){
		print "\nAnd sometimes:\ny->$counted{'y'}";
		$total+=$counted{'y'};
		print "Total Vowels: $total (With Y)\n";
	}
	
	print "\nAgain?(y/n)";
	chomp (my $ans = <>);
	
	$go = ($ans eq 'n') ? 0:1;
}
sub counter {
	my @word = split '', $_[0];
	my $reg = qr/a|e|i|o|u|y/;
	my %vowels;
	for(@word){
		if(lc($_) =~ $reg){
			$vowels{lc($_)}++;
		}
	}
	
	return \%vowels;
}
