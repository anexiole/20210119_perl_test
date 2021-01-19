package REPORT;

use strict;
use warnings;

use Readonly;
use IO::File;
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
	print STDERR qq{ _get_total_transaction_amount : } . ($data->{'QUANTITY_LONG'} - $data->{'QUANTITY_SHORT'} + 0);
	return $data->{'QUANTITY_LONG'} - $data->{'QUANTITY_SHORT'} + 0;
}

# Pass it an array which has hashref of parsed data
# It will find the unique sets of product and customers, and get its totals
sub get_summary_data
{
	my (@parsed_data) = @_;
	my %summary_data = ();
foreach my $parsed_data_element (@parsed_data)
{
	my $client_information = _get_client_information($parsed_data_element);
	my $product_information = _get_product_information($parsed_data_element);
	my $total = _get_total_transaction_amount($parsed_data_element);
	if (defined($summary_data{$client_information}->{$product_information}))
	{
		#print STDERR qq{ \t--> MUTTLEY - UPDATING the count for client, $client_information and product, $product_information from } . $summary_data{$client_information}->{$product_information} . qq{\n};
		$summary_data{$client_information}->{$product_information} += $total;
	}
	else{
		#print STDERR qq{ \t--> MUTTLEY -  INITIALISATING the count for client $client_information and product, $product_information  from ZERO with total of ($total) }  . $parsed_data_element->{'QUANTITY_LONG'}  . " , SHORT =". $parsed_data_element->{'QUANTITY_SHORT'}. qq{\n};
		$summary_data{$client_information}->{$product_information} = $total;
	}
}
return %summary_data;

}

# Given a file name and a hashref of data, it will generate a csv file
sub write_csv_report
{
	my ($file, $data) = @_;
my $fh = IO::File->new($file, q{w});
if (defined $fh) {
    foreach my $customer ( keys %{$data} )
	{
		##print $fh $data_line
		foreach my $product (keys %{$data->{$customer}})
		{
			my $data_string = join q{,}, (
				$customer,
				$product,
				$data->{$customer}->{$product},
				qq{\n}
			);
			print STDERR $data_string;
			print $fh $data_string;
		}
	}
    undef $fh;       # automatically closes the file
}

}

1;
