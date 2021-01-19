package REPORT;

use strict;
use warnings;

use Readonly;
use Data::Dumper;

# CONFIGURATIONS

Readonly my $max_input_characters_per_line => 302; 

# configuration for input elements in the input file.
# the value of the hash ref represents the length of the element's string
# Assumption: There must only be one slice per hashref

Readonly::Array my @input_element_placements => (
    { 'RECORD CODE'              => 3, },
    { 'CLIENT TYPE'              => 4, },
    { 'CLIENT NUMBER'            => 4, },
    { 'ACCOUNT NUMBER'           => 4, },
    { 'SUBACCOUNT NUMBER'        => 4, },
    { 'OPPOSITE PARTY CODE'      => 6, },
    { 'PRODUCT GROUP CODE'       => 2, },
    { 'EXCHANGE CODE'            => 4, },
    { 'SYMBOL'                   => 6, },
    { 'EXPIRATION DATE'          => 8, },
    { 'CURRENCY CODE'            => 3, },
    { 'MOVEMENT CODE'            => 2, },
    { 'BUY SELL CODE'            => 1, },
    { 'QUANTITY LONG SIGN'       => 1, },
    { 'QUANTITY LONG'            => 10, },
    { 'QUANTITY SHORT SIGN'      => 1, },
    { 'QUANTITY SHORT'           => 10, },
    { 'EXCH/BROKER FEE / DEC'    => 12, },
    { 'EXCH/BROKER FEE DC'       => 1, },
    { 'EXCH/BROKER FEE CUR CODE' => 3, },
    { 'CLEARING FEE / DEC'       => 12, },
    { 'CLEARING FEE D C'         => 1, },
    { 'CLEARING FEE CUR CODE'    => 3, },
    { 'COMMISSION'               => 12, },
    { 'COMMISSION D C'           => 1, },
    { 'COMMISSION CUR CODE'      => 3, },
    { 'TRANSACTION DATE'         => 8, },
    { 'FUTURE REFERENCE'         => 6, },
    { 'TICKET NUMBER'            => 6, },
    { 'EXTERNAL NUMBER'          => 6, },
    { 'TRANSACTION PRICE  / DEC' => 15, },
    { 'TRADER INITIALS'          => 6, },
    { 'OPPOSITE TRADER ID'       => 7, },
    { 'OPEN CLOSE CODE'          => 1, },
#    { 'FILLER'                   => 127, },
);

# methods
sub identify_transaction_elements
{
	my ($transaction_line) = @_;
	my @raw_data = split qr{}, $transaction_line, $max_input_characters_per_line;

    # Sanitise the data. We don't want trailing spaces at the end of
    # data. For example, 'SGXDC ' will be 'SGXDC' which is much
    # neater for reporting/display purposes.
	@raw_data = map { defined $_ and $_ =~ m{\w} ? $_ : q{ } } @raw_data;

	my %data = ();
	my $index = 0;
	foreach my $element_config (@input_element_placements)
	{
		ELEMENT_NAME: foreach my $element_name (keys %{$element_config})
		{
			my $ending_index = $index + $element_config->{$element_name} - 1;
			$data{ $element_name } = join q{}, @raw_data[ $index .. $ending_index];

			$index = $ending_index+1;
			last ELEMENT_NAME;
		}
	}

	return %data;
}

sub _get_client_information{
	my ($data) = @_;
	return join q{,}, (
		$data->{'CLIENT TYPE'},
		$data->{'CLIENT NUMBER'},
		$data->{'ACCOUNT NUMBER'},
		$data->{'SUBACCOUNT NUMBER'},
	);
}

sub _get_product_information{
	my ($data) = @_;
	return join q{,}, (
		$data->{''},
		$data->{'CLIENT NUMBER'},
		$data->{'ACCOUNT NUMBER'},
		$data->{'SUBACCOUNT NUMBER'},
	);
}

sub generate_report_content_line
{
	my ($data) = @_;

	my $client_information = _get_client_information($data);
	my $product_information

	return (

	);
}

1;
