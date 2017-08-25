use strict;
use warnings;
use Test::More;
use String::Template;

my $template = 'I <str{"%s" }>mean literally';

is expand_string( $template, { str => 'literally' } ),
  'I "literally" mean literally', "Parsed extended field";

is expand_string( $template, { str => undef } ),
  'I mean literally', "Extended field is treated as a whole";

is expand_string( '<str{"%s"\}}>', { str => 'foo' } ),
  '"foo"}', "Escaped curly brace";

is expand_string( $template, { str => undef }, 1 ),
  $template, "Template is unchanged if undefined";

is expand_string( '<str{--#2}>', { str => 'foobar' }, 1 ),
  '--obar', "Extended substr with undef flag";

is expand_string( '<str{--#2}>', { str => undef } ),
  q{}, "Extended subtr without undef flag";

is expand_string( '<str{--#1,3}-->', { str => 'foobar' }, 1 ),
  '--oob--', "Extended field with suffix";

done_testing();
