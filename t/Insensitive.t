use Test::More tests => 6;

BEGIN { use_ok('String::Template') };

#########################

my %fields = ( num => 2, str => 'this', date => 'Feb 27, 2008' );

my $template = "...<num%04d>...<str>...<date:%Y/%m/%d>...\n";

my $correct = "...0002...this...2008/02/27...\n";

is( expand_stringi("<this> and <that> and <theother>", { this => 1, that => 2, theother => 3 }),"1 and 2 and 3");
is( expand_stringi("<This> and <that> and <TheotHer>", { this => 1, tHAT => 2, theother => 3 }),"1 and 2 and 3");
is( expand_stringi("<tHis> and <that> and <theother>", { this => 1, that => 2, theother => 3 }),"1 and 2 and 3");
is( expand_stringi("<THIS> and <THAT> and <TheOther>", { this => 1, That => 2, theother => 3 }),"1 and 2 and 3");
is( expand_stringi("<this> and <that> and <theother>", { this => 1, that => 2, TheOther => 3 }),"1 and 2 and 3");
i

