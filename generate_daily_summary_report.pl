#!/usr/bin/perl

use strict;
use warnings;
use lib 'lib/';
use REPORT;

use Getopt::Long;
use IO::File;

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

my %summary_data = ();
my @parsed_data = ();
while (<$fh>)
{
    my %elements = REPORT::identify_transaction_elements($_);
    push @parsed_data, \%elements;
}
foreach my $parsed_data_element (@parsed_data)
{
    REPORT::_update_summary_data(
        {
            'summary' => \%summary_data,
            'elements' => $parsed_data_element,
        }
    );
}

use Data::Dumper;
print qq{ Summary is } . Dumper(\%summary_data);
 #   my @report_rows = REPORT::generate_report_contents(\%elements);
#	print qq{REPORT: } . Dumper(@report_rows) . qq{\n};



    undef $fh;

1;
