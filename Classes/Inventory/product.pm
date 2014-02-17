#!/usr/bin/perl

package Product;

use Moose;
use namespace::autoclean; #removes imported symbols from your class's namespace at the end of your package's compile cycle, including Moose keywords

#product class,
#keeps item name, price, item id, and quantity on hand
#quantity -> getQuantity, setquantity, increasequanty, decreasequantity

has 'itemName' => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has 'itemId' => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has 'price' => (
	traits => ['Counter'],
	is => 'rw',
	isa => 'Num',
	default => 0.00,
	handles => {
		increase_price => 'inc',
		decrease_price => 'dec',
	}
	
);

has 'quantity' => (
	traits => ['Counter'],
	is => 'rw',
	isa => 'Int',
	default => 0,
	handles => {
		increase_items => 'inc',
		decrease_items => 'dec',		
	}
);

has 'toString' => (
	is => 'ro',
	lazy => 1,
	builder => '_toString',
	isa => 'Str',
);

sub _toString {
	my $self = shift;
	my $price = get_price($self);
	my $string = $self->itemName . "," . $self->itemId . "," . $price . "," . $self->quantity;
	return $string;
}

sub get_price {
	my $self = shift;
	my $price = $self->price;
	my ($dollars, $cents) = split('\.', $price);
	
	if(length($cents) > 2){
		$cents = substr($cents,0,1);
	}
	if(length($cents) < 2){
		$cents.= "0";
	}

	return $dollars . ".$cents";
}

1;
