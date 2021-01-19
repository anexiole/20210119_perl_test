package REPORT;

use strict;
use warnings;

use Readonly;
use Data::Dumper;

# CONFIGURATIONS - for this test, I have opted to keep everything in the package
# but in the real world, some organisations will opt for a yaml config (which
# can be done easily)

Readonly my $max_input_characters_per_line => 302; 

# configuration for input elements in the input file.
# the value of the hash ref represents the length of the element's string
# Assumption: There must only be one slice per hashref

Readonly::Array my @input_element_placements => (
    { 'RECORD_CODE'              => 3, },
    { 'CLIENT_TYPE'              => 4, },
    { 'CLIENT_NUMBER'            => 4, },
    { 'ACCOUNT_NUMBER'           => 4, },
    { 'SUBACCOUNT_NUMBER'        => 4, },
    { 'OPPOSITE_PARTY_CODE'      => 6, },
    { 'PRODUCT_GROUP_CODE'       => 2, },
    { 'EXCHANGE_CODE'            => 4, },
    { 'SYMBOL'                   => 6, },
    { 'EXPIRATION_DATE'          => 8, },
    { 'CURRENCY_CODE'            => 3, },
    { 'MOVEMENT_CODE'            => 2, },
    { 'BUY_SELL_CODE'            => 1, },
    { 'QUANTITY_LONG_SIGN'       => 1, },
    { 'QUANTITY_LONG'            => 10, },
    { 'QUANTITY_SHORT_SIGN'      => 1, },
    { 'QUANTITY_SHORT'           => 10, },
    { 'EXCH/BROKER_FEE/DEC'    => 12, },
    { 'EXCH/BROKER_FEE_DC'       => 1, }, 
    { 'EXCH/BROKER_FEE_CUR_CODE' => 3, },
    { 'CLEARING_FEE/DEC'       => 12, },
    { 'CLEARING_FEE_D_C'         => 1, },
    { 'CLEARING_FEE_CUR_CODE'    => 3, },
    { 'COMMISSION'               => 12, },
    { 'COMMISSION_D_C'           => 1, },
    { 'COMMISSION_CUR_CODE'      => 3, },
    { 'TRANSACTION_DATE'         => 8, },
    { 'FUTURE_REFERENCE'         => 6, },
    { 'TICKET_NUMBER'            => 6, },
    { 'EXTERNAL_NUMBER'          => 6, },
    { 'TRANSACTION_PRICE/DEC'    => 15, },
    { 'TRADER_INITIALS'          => 6, },
    { 'OPPOSITE_TRADER_ID'       => 7, },
    { 'OPEN_CLOSE_CODE'          => 1, },
#    { 'FILLER'                   => 127, },
);

# methods
sub identify_transaction_elements
{
	my ($transaction_line) = @_;
	my $transaction_line_has_valid_data = (
		(defined($transaction_line))
		and ($transaction_line =~ m{\w})
	);

	unless ($transaction_line_has_valid_data)
	{
		return;
	}

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
#print qq{RAW - } . Dumper(\%data)
	return %data;
}

sub _get_client_information
{
	my ($data) = @_;
	return join q{,}, (
		$data->{'CLIENT_TYPE'},
		$data->{'CLIENT_NUMBER'},
		$data->{'ACCOUNT_NUMBER'},
		$data->{'SUBACCOUNT_NUMBER'},
	);
}

sub _get_product_information
{
	my ($data) = @_;
	return join q{,}, (
		$data->{'EXCHANGE_CODE'},
		$data->{'PRODUCT_GROUP_CODE'},
		$data->{'SYMBOL'},
		$data->{'EXPIRATION_DATE'},
	);	
}

sub _get_total_transaction_amount
{
	my ($data) = @_;
	return $data->{'QUANTITY_LONG'} - $data->{'QUANTITY_SHORT'} + 0;
}


#    REPORT::_update_summary_data(
#        'summary' => $summary_data,
#        'elements' => \%elements,
#    );

sub _update_summary_data
{
	my ($args) = @_;


	print STDERR qq{ The ARGS I got are : }. Dumper($args);

	my $client_information = _get_client_information($args->{'elements'});
	my $product_information = _get_product_information($args->{'elements'});

	print STDERR qq{ CURRENT CLIENT $client_information\nproduct_information:$product_information\n};
	#my $total_transaction_amount = _get_total_transaction_amount($data);
	my $total = _get_total_transaction_amount($args->{'elements'});
	
	if (defined($args->{'summary'}->{$client_information}->{$product_information}))
	{
		$args->{'summary'}->{$client_information}->{$product_information} += $total;
	}
	else{
		$args->{'summary'}->{$client_information}->{$product_information} = $total;
	}

	#return join q{||}, (
	#	$client_information,
	#	$product_information,
	#);
}

1;
