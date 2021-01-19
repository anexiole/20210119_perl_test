#!/usr/bin/perl

use strict;
use warnings;
use lib 'lib/';
use Test::More;

{
	use_ok('REPORT');
}
{
	can_ok('REPORT', q{identify_transaction_elements});
	my $transaction_line = q{315CL  432100020001SGXDC FUSGX NK    20100910JPY01B 0000000001 0000000000000000000060DUSD000000000030DUSD000000000010DJPY201008200012400     688058000092500000000GORDON       O};
	my %elements = REPORT::identify_transaction_elements($transaction_line);

	my %expected_elements = (
          'TICKET_NUMBER' => '0     ',
          'BUY_SELL_CODE' => 'B',
          'EXTERNAL_NUMBER' => '688058',
          'EXCH/BROKER_FEE/DEC' => '000000000060',
          'ACCOUNT_NUMBER' => '0002',
          'CLEARING_FEE_D_C' => 'D',
          'CLEARING_FEE/DEC' => '000000000030',
          'MOVEMENT_CODE' => '01',
          'CURRENCY_CODE' => 'JPY',
          'QUANTITY_LONG_SIGN' => ' ',
          'COMMISSION' => '000000000010',
          'EXCHANGE_CODE' => 'SGX ',
          'COMMISSION_D_C' => 'D',
          'OPPOSITE_TRADER_ID' => '       ',
          'SYMBOL' => 'NK    ',
          'COMMISSION_CUR_CODE' => 'JPY',
          'EXPIRATION_DATE' => '20100910',
          'OPEN_CLOSE_CODE' => 'O',
          'TRANSACTION_DATE' => '20100820',
          'EXCH/BROKER_FEE_DC' => 'D',
          'EXCH/BROKER_FEE_CUR_CODE' => 'USD',
          'CLIENT_TYPE' => 'CL  ',
          'QUANTITY_LONG' => '0000000001',
          'RECORD_CODE' => '315',
          'TRANSACTION_PRICE/DEC' => '000092500000000',
          'SUBACCOUNT_NUMBER' => '0001',
          'CLEARING_FEE_CUR_CODE' => 'USD',
          'QUANTITY_SHORT' => '0000000000',
          'PRODUCT_GROUP_CODE' => 'FU',
          'TRADER_INITIALS' => 'GORDON',
          'OPPOSITE_PARTY_CODE' => 'SGXDC ',
          'FUTURE_REFERENCE' => '001240',
          'CLIENT_NUMBER' => '4321',
          'QUANTITY_SHORT_SIGN' => ' '	
	);

	is_deeply(
		\%elements,
		\%expected_elements,
		q{Elements parsed as expected from raw transaction line}
	);

	can_ok('REPORT', q{generate_report_content_line});
	my $r = REPORT::generate_report_content_line(\%elements);
	print $r;
}

done_testing();
