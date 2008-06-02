use Test::More;
use String::Template;

my @TestCases =
(
    {
        Name     => 'Simple, nothing replaced',
        Template => 'foo',
        Fields   => {},
        Correct  => 'foo'
    },
    {
        Name     => '1 replace',
        Template => '<foo>',
        Fields   => { foo => 12 },
        Correct  => '12'
    },
    {
        Name     => '1 replace, with whitespace',
        Template => '  <foo> ',
        Fields   => { foo => 12, ignored => 72},
        Correct  => '  12 '
    },
    {
        Name     => '2 replaces',
        Template => '  <foo>  <bar>',
        Fields   => { foo => 12, bar => 72},
        Correct  => '  12  72'
    },
    {
        Name     => 'Missing field',
        Template => '  <foo>  <bar>',
        Fields   => { foo => 12, ignored => 72},
        Correct  => '  12  '
    },
    {
        Name     => '2 replaces with sprintf format',
        Template => '  <foo>  <bar%04d>',
        Fields   => { foo => 12, bar => 72},
        Correct  => '  12  0072'
    },
    {
        Name     => '2 replaces with date format',
        Template => '  <foo>  <date:%Y-%m-%d> ',
        Fields   => { foo => 12, date => 'May 17, 2008'},
        Correct  => '  12  2008-05-17 '
    }
);

plan tests => scalar @TestCases;

foreach my $t (@TestCases)
{
    my $exp = expand_string($t->{Template}, $t->{Fields});

    is($exp, $t->{Correct}, $t->{Name});
}
