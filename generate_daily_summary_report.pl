#!/usr/bin/perl
use REPORT;

use strict;
use warnings;
use lib 'lib/';

{
	use_ok('REPORT');
}
{
	can_ok('REPORT', q{identify_transaction_elements});
}
{
	can_ok('REPORT', q{generate_report_contents});
}
