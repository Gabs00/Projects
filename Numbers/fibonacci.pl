#!usr/bin/env perl

#fibonacci sequence = (0,1,2,3,5,8,13) where 0,1 are a given

use strict;
use warnings;

my @fibo = (0,1);

print "This program prints the fibonacci sequence up to the given number. \nplease enter a number: ";

chomp (my $num = <>);
$num = int($num);
my $go = 1;
while($go) {
	my $temp = $fibo[$#fibo] + $fibo[$#fibo-1];
	push @fibo, $temp;
	for (@fibo) {
		print $_, " ";
	}
	print "\n";
	$go = 0 if $fibo[$#fibo] >= $num;
}