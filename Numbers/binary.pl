#!/usr/bin/perl

use strict;
use warnings;
use Math::Trig;

my $go = 1;

while($go){
	my $choice;
	while(!$choice){
		print "1. Convert to Binary?\n2. Convert from binary to decimal?\n";
		chomp (my $ans = <>);
		
		$choice = ($ans eq '1' || $ans eq '2') ? $ans:0;
	}
	
	my $number;
	while(!$number){
		print "please enter your number:\n";
		chomp (my $ans = <>);
		$number = ($ans !~ /\d+/) ? 0:$ans;
	}
	if($choice == 1){
		print "\n", toDec($number), "\n";
	}
	else{
		print "\n", toBin($number), "\n";
	}
	
	print "Again? (y/n): ";
	chomp (my $ans = <>);
	$go = ($ans eq 'n') ? 0:1;
}

sub toDec {
	my $number = shift;
	return sprintf("%b", $number);
}

sub toBin {
	my $bin = shift;
	if($bin =~ /[2-9]/){
		return "Not a binary number";
	}
	return oct("0b$bin");
}


