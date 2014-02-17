#!/usr/bin/perl

package Ceasar;
use Moose;
use namespace::autoclean;

#method Ceaser->cypher takes 2 arguments, string to be translated, and mode.
#0 to decrypt
#1 to encrypt

has key =>(
	is => 'rw',
	isa => 'Int',
	required => 1,
);

has alpha_map => (
	is => 'ro',
	isa => 'HashRef',
	builder => 'get_map',
);

has alpha => (
	is => 'ro',
	isa => 'ArrayRef',
	builder => 'get_alpha',
);

has case => (
	is => 'rw',
	isa => 'Bool',
	default => '0',
);
sub get_alpha {
	return ['a' .. 'z', 'a' .. 'z'];
}

sub get_map {
	my @array = ('a' .. 'z');
	my %hash;
	for my $i (0..$#array){
		$hash{$array[$i]} = $i; 
	}
	return \%hash;
}

sub cypher {
	my $self = shift;
	my ($key, $phrase) = ($self->key, $_[0]);
	my $encrypt = $_[1] || 0;
	my $alpha = $self->alpha;
	my $alpha_map = $self->alpha_map;
	my @newPhrase;
	my @temp = split '', $phrase;
	for my $index(0 .. (@temp-1)){

		if($temp[$index] =~ /[a-zA-Z]/){
			if($encrypt){
				my $case = UppLow($self,$temp[$index]);
				my $pushVal = $alpha->[($alpha_map->{lc($temp[$index])}+$key)];
				$pushVal = uc($pushVal) if $case;
				push @newPhrase, $pushVal;
			}
			else{
				my $case = UppLow($self,$temp[$index]);
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

sub UppLow {
	my ($self, $char) = @_;

	if($char =~ /[A-Z]/){

		$self->case(1);
	}	
	else {
		$self->case(0);
	}
	return 1;
}

1;
