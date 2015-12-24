requires 'DBIx::Simple';
requires 'Exporter::Tidy';
requires 'SQL::Interpol';
requires 'perl', '5.006';
requires 'strict';
requires 'warnings';

on test => sub {
	requires 'Test::More', '0.88';
	requires 'lib';
};

# vim: ft=perl
