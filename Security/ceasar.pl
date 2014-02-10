#!/usr/bin/perl

use strict;
use warnings;

# At key 5
# abcdefghijklmnopqrstuvwxyz
# vwxyzabcdefghijklmnopqrstu
# Encrypt | my $cy = ceasar($key, $test, 1)
# Decrytp | my $cy2 = ceasar($key, $cy, 0)

if(@ARGV){

	my ($mode, $key) = @{ getInfo() };
	my $target;
	
	while(!$target){
		print "Please enter an output filename: ";
		chomp ($target = <STDIN>);
	}
	my @files;
	
	for(@ARGV){
		push @files, $_;
	}
	
	for my $file(@files){
		open (my $fh, '<', $file) or die "Could not open filename - $file: $!";
		open (my $fh2, '>', $target) or die "Could not open filename - $target: $!";
		
		while(<$fh>){
			chomp;
			next unless $_;
			print $fh2 ceasar($key, $_, $mode), "\n";
		}
	}
}
else {
	print "Usage: <program name> <file>";
}


#====================================#
#	SUBROUTINES                  #
#====================================#


sub getInfo {
	my $mode;
	my $key;
	
	print "Please enter a mode:\n";
	$mode = While("\n1. Encrypt\n2. Decrypt\n", [1,2]);
	$mode = ($mode == 1) ? 1:0;
	if($mode){
		print "pick a key 1 - 25";
	}
	else {
		print "What keys was this encrypted with?";
	}
	$key = While("\nKey? (1 - 25)", [1..25]);
	
	return [$mode, $key];
}

#just saving time

sub While {
	my $message = $_[0];
	my $options = $_[1];
	my $value;
	while(!($value)){
		print $message;
		chomp (my $tim = <STDIN>);
		print "\n$tim\n";
		for(@{ $options }){
			$value = ($tim eq $_) ? $tim:0;
			last if $value;
		}
	}
	return $value;
}

#uses map and hash from createCy(). gets letters from current line, 
#uses alpha_map to get the original char number and adds(or subtracts) the key to it,
#and uses that as the new index

sub ceasar {
	my ($key, $phrase) = ($_[0], $_[1]);
	my $encrypt = $_[2] || 0;
	my ($alpha, $alpha_map) = @{ createCy() };
	my @newPhrase;
	my @temp = split '', $phrase;
	for my $index(0 .. (@temp-1)){

		if($temp[$index] =~ /[a-zA-Z]/){
			if($encrypt){
				my $case = UppLow($temp[$index]);
				my $pushVal = $alpha->[($alpha_map->{lc($temp[$index])}+$key)];
				$pushVal = uc($pushVal) if $case;
				push @newPhrase, $pushVal;
			}
			else{
				my $case = UppLow($temp[$index]);
				my $pushVal = $alpha->[($alpha_map->{lc($temp[$index])}-$key)];
				$pushVal = uc($pushVal) if $case;
				push @newPhrase, $pushVal;
			}
		}
		else {
			push @newPhrase, $temp[$index];
		}
	}

	return join '', @newPhrase;
}

#checks for uppercase letters, though just returning $char =~ /[A-Z]/ would have sufficed, using this way because
#I just learned how to utilize $1, $2, $3 so sue me

sub UppLow {
	my $char = shift;
	$char =~ /([A-Z])/;
	return defined($1);
}

#creates an array a - z a - z as an array and a letter to number mapping as a hash

sub createCy {
	my @alpha = ('a' .. 'z');
	my %alpha_map;
	for my $i(0 .. $#alpha){
		$alpha_map{$alpha[$i]} = $i;
	}
	@alpha = ('a' .. 'z', 'a' .. 'z');
	return [\@alpha, \%alpha_map];
}


