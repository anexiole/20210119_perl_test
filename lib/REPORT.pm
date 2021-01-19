package REPORT;

use strict;
use warnings;

# configuration for input elements in the input file.
# the value of the hash ref represents the length of the element's string

my %input_element_placements = (
	'RECORD CODE' => 3,
	'CLIENT TYPE' => 4,
	'CLIENT NUMBER' => 4,
	'ACCOUNT NUMBER' => 4,
	'SUBACCOUNT NUMBER' => 4,
	'OPPOSITE PARTY CODE' =>6,
        'PRODUCT GROUP CODE' => 2,
	'EXCHANGE CODE' => 4,
	'SYMBOL' =>6,
	'EXPIRATION DATE' => 8,
	'CURRENCY CODE' => 3,
	'MOVEMENT CODE' => 2,
	'BUY SELL CODE' => 1,
	'QUANTITY LONG SIGN'=> 1,
	'QUANTITY LONG' => 10,
	'QUANTITY SHORT SIGN' => 1,
	'QUANTITY SHORT' => 10,
	'EXCH/BROKER FEE / DEC' => 12,
	'EXCH/BROKER FEE DC' => 1,
	'EXCH/BROKER FEE CUR CODE' => 3,
	'CLEARING FEE / DEC' => 12,
	'CLEARING FEE D C' => 1,
	'CLEARING FEE CUR CODE' => 3,
	'COMMISSION' => 12,
	'COMMISSION D C' => 1,
	'COMMISSION CUR CODE' => 3,
	'TRANSACTION DATE' => 8,
	'FUTURE REFERENCE' => 6,
	'TICKET NUMBER' => 6,
	'EXTERNAL NUMBER' => 6,
	'TRANSACTION PRICE  / DEC' => 15,
	'TRADER INITIALS' => 6,
	'OPPOSITE TRADER ID' => 7,
	'OPEN CLOSE CODE' => 1,
	'FILLER' => 127,
);



# methods


sub identify_transaction_elements
{
	my ($transaction_line) = @_;

	my @raw_data = split qr{}, $r;

 
}

sub generate_report_contents
{

}

1;
