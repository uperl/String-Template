package String::Template;

use strict;
use warnings;

use base 'Exporter';
use POSIX;
use Date::Parse;

our @EXPORT = qw(expand_string);

our $VERSION = '0.01';

my %special =
(
    '%' => sub { sprintf("%$_[0]", $_[1]) },
    ':' => sub { strftime($_[0], localtime(str2time($_[1]))) }
);

my $specials = join('', keys %special);
my $specialre = qr/^([^$specials]+)([$specials])(.+)$/;

sub _replace
{
    my ($field, $f) = @_;

    if ($field =~ $specialre)
    {
        return $field unless defined $f->{$1};
        return $special{$2}($3,$f->{$1});
    }

    return defined $f->{$field} ? $f->{$field} : $field;
}

sub expand_string
{
    my ($s, $f) = @_;

    $s =~ s/<([^>]+)>/_replace($1, $f)/ge;

    return $s;
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

Exports a single function expand_string($template, \%fields).

Fills in a simple template with values from a hash, replacing tokens
like "<fieldname>" with the value from the hash $fields->{fieldname}.

Some special characters can be used to impose formatting on the
fields:

 % - treat like a sprintf() format
 : - treat like a L<POSIX::strftime()> format

For the ':' strftime formats, the field is parsed by L<Date::Parse>,
so it can handle any format that can handle.

=head1 SEE ALSO

L<String::Format> performs a similar function, with a different
syntax.

=head1 AUTHOR

Curt Tilmes, E<lt>curt@tilmes.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by NASA Goddard Space Flight Center

=cut
