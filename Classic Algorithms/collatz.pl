#!usr/bin/env perl
#Collatz conjecture
#Start with a number n > 1. Find the number of steps it takes to 
#reach one using the following process: If n is even, divide it 
#by 2. If n is odd, multiply it by 3 and add 1.

use strict;
use warnings;
use feature qw(switch);
my $num = 1;
my $steps = 0;

while($num <= 1) {
	print "Collatz Conjecture:\nPlease enter a number great than 1:";
	chomp ($num =<>);
}


$num = int($num);

$steps = &col($num, $steps);
print "\nSteps needed: ", $steps, "\n";

sub col{
	no warnings 'recursion'; 
	my $number = $_[0];
	my $steps = $_[1];
	return $steps if $number == 1;
	if($number%2) {
		$number = ($number * 3)+1;
	}
	else {
		$number = $number/2;
	}
	  
	 $steps++;
	 col($number, $steps); 
}
