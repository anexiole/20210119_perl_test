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
          'TICKET NUMBER' => '0',
          'BUY SELL CODE' => 'B',
          'EXTERNAL NUMBER' => '688058',
          'EXCH/BROKER FEE / DEC' => '000000000060',
          'ACCOUNT NUMBER' => '0002',
          'CLEARING FEE D C' => 'D',
          'CLEARING FEE / DEC' => '000000000030',
          'MOVEMENT CODE' => '01',
          'CURRENCY CODE' => 'JPY',
          'QUANTITY LONG SIGN' => '',
          'COMMISSION' => '000000000010',
          'EXCHANGE CODE' => 'SGX',
          'COMMISSION D C' => 'D',
          'OPPOSITE TRADER ID' => '',
          'SYMBOL' => 'NK',
          'COMMISSION CUR CODE' => 'JPY',
          'EXPIRATION DATE' => '20100910',
          'OPEN CLOSE CODE' => 'O',
          'TRANSACTION DATE' => '20100820',
          'EXCH/BROKER FEE DC' => 'D',
          'EXCH/BROKER FEE CUR CODE' => 'USD',
          'CLIENT TYPE' => 'CL',
          'QUANTITY LONG' => '0000000001',
          'RECORD CODE' => '315',
          'TRANSACTION PRICE  / DEC' => '000092500000000',
          'SUBACCOUNT NUMBER' => '0001',
          'CLEARING FEE CUR CODE' => 'USD',
          'QUANTITY SHORT' => '0000000000',
          'PRODUCT GROUP CODE' => 'FU',
          'TRADER INITIALS' => 'GORDON',
          'OPPOSITE PARTY CODE' => 'SGXDC',
          'FUTURE REFERENCE' => '001240',
          'CLIENT NUMBER' => '4321',
          'QUANTITY SHORT SIGN' => ''	
	);

	is_deeply(
		\%elements,
		\%expected_elements,
		q{Elements parsed as expected from raw transaction line}
	)
}
{
	can_ok('REPORT', q{generate_report_contents});
}

done_testing();