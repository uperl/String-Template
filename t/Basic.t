# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl String-Template.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 2;
BEGIN { use_ok('String::Template') };

#########################

my %fields = ( num => 2, str => 'this', date => 'Feb 27, 2008' );

my $template = "...<num%04d>...<str>...<date:%Y/%m/%d>...\n";

my $correct = "...0002...this...2008/02/27...\n";

my $exp = expand_string($template, \%fields);

is($exp, $correct, "test expand");
