#!/usr/bin/perl

use strict;
use warnings;
use RSSManager;
use Data::Dumper;


my $value;
while(!$value){
	print "ATOM feeds not yet supported!\n"
	print "Please enter a RSS feed URL: ";
	chomp (my $ans = <>);
	$value = ($ans) ? $ans:0;
}
my $rss = $value ||  "http://www.peeron.com/tickers/pm.xml"; #test feed now include!!!(TM)
my $man = RSSManager->new();

$man->URL([$rss, 0]);

my @items = @{ $man->RSS->items };



for my $i (0 .. $#items){
	my %item = %{ $items[$i] };
	printf "Title: $item{'title'}\n";
	printf "\tDescription: $item{'description'}\n";
	printf "\n\tLink: $item{'link'}\n";
}
