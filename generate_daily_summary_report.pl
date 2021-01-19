#!/usr/bin/perl

use strict;
use warnings;
use lib 'lib/';
use REPORT;

use Getopt::Long;
use IO::File;
use Data::Dumper;

my $help = undef;
my $input_file = undef;
 
      GetOptions (
                  "input_file=s"   => \$input_file,
                  "help"  => \$help)
      or die("Error in command line arguments\n");

unless (defined($input_file))
{
    die qq{No input file supplied to daily summary report generator.\n};
}

my $fh = IO::File->new($input_file, q{r});

unless (defined $fh) {
    die qq{Cannot open file, $input_file: $!};
}


my @parsed_data = ();
# parse all data in each of the input line to recognisable
# elements. The identifies the unique sets of client and product
# information
while (<$fh>)
{
    my %elements = REPORT::identify_transaction_elements($_);
    push @parsed_data, \%elements;
}

my %summary_data = REPORT::get_summary_data(@parsed_data);


use Data::Dumper;
print qq{ Summary is } . Dumper(\%summary_data);
 #   my @report_rows = REPORT::generate_report_contents(\%elements);
#	print qq{REPORT: } . Dumper(@report_rows) . qq{\n};



    undef $fh;

1;
