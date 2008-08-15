package String::Template;

use strict;
use warnings;

use base 'Exporter';
use POSIX;
use Date::Parse;
use DateTime::Format::Strptime;

our @EXPORT = qw(expand_string);

our $VERSION = '0.03';

use Data::Dumper;

my %special =
(
    '%' => sub { sprintf("%$_[0]", $_[1]) },

    ':' => sub { strftime($_[0], localtime(str2time($_[1]))) },

    '#' => sub { my @args = split(/\s*,\s*/, $_[0]);
                 defined $args[1]
                 ? substr($_[1], $args[0], $args[1])
                 : substr($_[1], $args[0]) }
);

my $specials = join('', keys %special);
my $specialre = qr/^([^$specials]+)([$specials])(.+)$/;

#
# _replace($field, \%fields)
#
# replace a single "<field> or "<field%sprintf format>"
# or "<field:strftime format>"
#
sub _replace
{
    my ($field, $f) = @_;

    if ($field =~ $specialre)
    {
        return '' unless defined $f->{$1};
        return $special{$2}($3,$f->{$1});
    }

    return defined $f->{$field} ? $f->{$field} : '';
}

#
# expand_string($string, \%fields)
# find "<fieldname>"
#
sub expand_string
{
    my ($string, $fields) = @_;

    $string =~ s/<([^>]+)>/_replace($1, $fields)/ge;

    return $string;
}

1;
__END__

=head1 NAME

String::Template - Fills in string templates from hash of fields

=head1 SYNOPSIS

  use String::Template;

  my %fields = ( num => 2, str => 'this', date => 'Feb 27, 2008' );

  my $template = "...<num%04d>...<str>...<date:%Y/%m/%d>...\n";

  print expand_string($template, \%fields);

  prints: "...0002...this...2008/02/27..."

=head1 DESCRIPTION

=head2 $str = expand_string($template, \%fields).

Fills in a simple template with values from a hash, replacing tokens
like "<fieldname>" with the value from the hash $fields->{fieldname}.

Some special characters can be used to impose formatting on the
fields:

 % - treat like a sprintf() format
     e.g.  <int%02d>

 : - treat like a L<POSIX::strftime()> format
     e.g. <date:%Y-%m-%d>

 # - treat like ars to substr()
     e.g. <str#0,2> or <str#4>

For the ':' strftime formats, the field is parsed by L<Date::Parse>,
so it can handle any format that can handle.

=head1 SEE ALSO

L<String::Format> performs a similar function, with a different
syntax.

=head1 AUTHOR

Curt Tilmes, E<lt>ctilmes@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by NASA Goddard Space Flight Center

=cut
