#!usr/bin/perl

use strict;
use warnings;

my $i = 1;
my $input = 'y';

print "Enter 'q' to stop showing the next prime number\n";
while($input ne 'q'){
		if(prime($i)){
			print $i;
			chomp ($input = <>);
		}
		$i++;		
}

sub prime {
	my $n = shift;
	
	my @divisors = (2 .. int(sqrt($n)));
	
	for(@divisors){
		return undef unless $n%$_;
	}
	
	return $n;
}
