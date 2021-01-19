# 20210119_perl_test


APPLICATION:
============


Configuration:
    By default, its output file will be a file called Output.csv located in the current directory.
    To change the name and path of this default output file, head to generate_daily_summary_report.pl
    and alter the 'output' config element in the hash, %file.


Execution:
    To run the application, you can optionally provide a '--input_file' flag. Else, by default it will
    just use a file called Input.csv in its current path.
    
    PRE: run "chmod 755 generate_daily_summary_report.pl" to set the permissions up
    
    
    To run it:
    
     The command is "././generate_daily_summary_report.pl --input_file <input file other than input.csv>"
    
    
Examples:

1. "./generate_daily_summary_report.pl"
2. "./generate_daily_summary_report.pl --input_file alternative_input.txt"




TESTS
=====

run " prove -v t/report.t"

Example: $ prove -v t/report.t 
t/report.t .. 
ok 1 - use REPORT;
ok 2 - REPORT->can('identify_transaction_elements')
ok 3 - Elements parsed as expected from raw transaction line
ok 4 - REPORT->can('get_summary_data')
ok 5 -   Unique product and customer sets identified with correct net totals
ok 6 - REPORT->can('write_csv_report')
ok 7 - write_csv_report dies as expected when no valid file path is given
ok 8 - write_csv_report does not exit as expected when a valid file path is given
1..8
ok
All tests successful.
Files=1, Tests=8,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.05 cusr  0.00 csys =  0.07 CPU)
Result: PASS
[19:36:09] Perl Test git:(main*) $ 

