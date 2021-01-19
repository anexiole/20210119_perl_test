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

GetOptions(
    'input_file=s' => \$input_file,
    'help'         => \$help
) or die(qq{Error in command line arguments\n});

my %file = (
    'input'  => q{Input.txt},
    'output' => q{output.csv},
);

if (defined($input_file))
{
    $file{'input'} = $input_file;
}

my $fh = IO::File->new($file{'input'}, q{r});

unless (defined $fh) {
    die q{Cannot open file, }. $file{'input'} . qq{: $!};
}

eval {
    # parse all data in each of the input line to recognisable
    # elements. The identifies the unique sets of client and product
    # information
    my @parsed_data = ();

    while (<$fh>) {
        my %elements = REPORT::identify_transaction_elements($_);
        push @parsed_data, \%elements;
    }
    undef $fh;

    # get the daily summary contents
    my %summary_data = REPORT::get_summary_data(@parsed_data);

    # write out the contents to the filesystem
    REPORT::write_csv_report(
        {   'file' => $file{'output'},
            'data' => \%summary_data,
        }
    );
};
if ($@) {
    print STDERR qq{Exception trapped: $@};
}

1;
