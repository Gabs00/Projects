#!/usr/bin/perl

#
#INCOMPLETE
#
package Inventory;
use Moose;
use namespace::autoclean;

has productList => (
	is => 'rw',
	isa => 'HashRef',
	writer => '_set_productList',
	default => sub {{}},
);

has items => (
		is => 'rw',
		isa => 'Int',
		writer => '_set_items',
		builder => 'item_list',
		lazy => 1,
);



1;
