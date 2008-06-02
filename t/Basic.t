# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl String-Template.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 4;
BEGIN { use_ok('String::Template') };

#########################

my %fields = ( num => 2, str => 'this', date => 'Feb 27, 2008' );

my $template = "...<num%04d>...<str>...<date:%Y/%m/%d>...\n";

my $correct = "...0002...this...2008/02/27...\n";

my $exp = expand_string($template, \%fields);

ok($exp eq $correct, "test expand");


my $re = qr!...(\d{4})...(\w+)...(\d{4}/\d{2}/\d{2})...!;

my $rec = untemplate($template, $re, $exp);

ok($fields{num} == $rec->{num});

ok($fields{str} eq $rec->{str});

