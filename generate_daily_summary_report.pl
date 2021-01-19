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

my %file = (
    'input'  => q{input.csv},
    'output' => q{output.csv},
);

if (defined($input_file))
{
    $file{'input'} = $input_file;
}
else{
    print q{No input file supplied to daily summary report generator. Will use}
    . qq{ the default file, }
    . $file->{'input'}
    . qq{\n}
    ;
}

my $fh = IO::File->new($file{'input'}, q{r});

unless (defined $fh) {
    die q{Cannot open file, }. $file{'input'} . qq{: $!};
}

my @parsed_data = ();
eval
{
# parse all data in each of the input line to recognisable
# elements. The identifies the unique sets of client and product
# information
while (<$fh>)
{
    my %elements = REPORT::identify_transaction_elements($_);
    push @parsed_data, \%elements;
}
undef $fh;


my %summary_data = REPORT::get_summary_data(@parsed_data);

REPORT::generate_csv_report($output_file_name);


use Data::Dumper;
print qq{ Summary is } . Dumper(\%summary_data);
 #   my @report_rows = REPORT::generate_report_contents(\%elements);
#	print qq{REPORT: } . Dumper(@report_rows) . qq{\n};

};
if ($@)
{
    print STDERR qq{Exception trapped: $@};
}
1;
