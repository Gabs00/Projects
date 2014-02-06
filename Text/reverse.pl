#!/usr/bin/perl

use strict;
use warnings;

my $word;

while(!($word)){
	print "Please enter a word to be reversed: ";
	chomp ($word = <>);
}

my $new = rev($word);

print "Normal: $word\nReversed: $new\n";
sub rev {
	my @word = split '', $_[0];
	my $new_word = join('', (reverse(@word)));
	return $new_word;
}
