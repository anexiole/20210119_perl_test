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

    while (<$fh>)
{
    print "File" . $_ . "\n";
}


    undef $fh;

1;
