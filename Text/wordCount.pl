#!/usr/bin/perl

if(@ARGV){

	my $file = shift;
	open(my $fh, '<', $file) or die "Could not open file: $!";
	my %counted;
	while(<$fh>){
		chomp;
		my %backed = %{ counter($_) };
		for(keys %backed){
			$counted{$_}+= $backed{$_};
		}
	}
	
	print "Words -> $counted{'words'}\n";
	print "Numbers -> $counted{'numbers'}\n" if defined($counted{'numbers'});
}
else {

	my $go = 1;
	while($go){
		my $word;
		while(!($word)){
			print "Please enter a sentence to have the number of words counted:\n";
			chomp ($word = <>);
		}
		my %counted = %{ counter($word) };
		
		print "Words -> $counted{'words'}\n";
		print "Numbers -> $counted{'numbers'}\n" if defined($counted{'numbers'});
		
		print "\nAgain? (y/n)";
		chomp (my $ans = <>);
		
		$go = ($ans eq 'n') ? 0:1;
	}
}

sub counter {
	my @sentence = split ' ', $_[0];
	my %back;
	for(@sentence){
		if(!(/\d/) && /\w/){
			$back{'words'}++;
		}
		elsif(/\d/){
			$back{'numbers'}++;
		}
	}
	return \%back;
}
