#!/usr/bin/perl

use strict;
use warnings;

my $go = 1;

while($go){
	my $palin;
	while(!$palin){
		print "\nEnter a word or numbers to have them checked for being a palindrome: ";
		chomp ($palin = <>);
	}
	
	print "\n$palin\n======================\n";
	if(palinCheck($palin)){
		print "Is a palindrome!\n\n";
	}
	else{
		print "Is not a palindrome\n\n";
	}
	
	print "Again? (y/n): ";
	chomp (my $ans = <>);
	$go = ($ans eq 'n') ? 0:1;
}


sub palinCheck{
	my $check = shift;
	my $word = lc(join('', $check =~ /[a-zA-Z0-9]/g));
	if($word eq rev($word)){
		return 1;
	}
	else{
		return 0;
	}
}

#splits the word into an array of chars and returns it in reverse.
sub rev {
	my $word = shift;
	my @sep = split('', $word);
	return join('', reverse(@sep));
}
