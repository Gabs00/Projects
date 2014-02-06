#!/usr/bin/perl

use strict;
use warnings;



my $go = 1;
print "\n", pigSentence("Welcome to the pig latin converter."), "\n\n";

while($go){
	my $sentence;
	while(!($sentence)){
		print "Please type a sentence to be translated into igpay atinlay: ";
		chomp ($sentence = <>);
	}

	print "\n", pigSentence($sentence), "\n";
	
	print "Another? (y/n):";
	chomp (my $ans = <>);
	
	$go = ($ans eq 'n') ? 0:1;
}


sub pigSentence {
	my $sentence = $_[0];
	chomp $sentence;
	my $punc = qr/\.|\?|\,|\!/;
	
	my @words = split ' ', $sentence;
	for my $i(0..$#words){
		my $per;
		if($words[$i] =~ $punc) { $per = chop $words[$i]; }
		
		$words[$i] = pigWord($words[$i]);
		
		if($per){
			$words[$i].= $per;
		}
		
	}

	return join(' ', @words);
}

sub pigWord {
	my @word = split '', $_[0];
	my $vowels = qr/a|e|i|o|u |\d/;
	if($word[0] !~ $vowels) { 
		@word = @{ popShift(@word) };
		if($word[0] !~ $vowels){
			@word = @{ popShift(@word) };
		}
	}
	else {
		push @word, "w";
	}
	push @word, "ay";
	
	return join('', @word);

}

sub popShift {
	my @array = @_;
	my $first = shift @array;
	push @array, $first;
	return\@array;
}
