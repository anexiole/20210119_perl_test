# 20210119_perl_test


APPLICATION:
============

To run the application, you can optionally provide a '--input_file' flag. Else, by default it will
just use a file called Input.csv in its current path.




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

