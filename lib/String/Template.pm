package String::Template;

use strict;
use warnings;

use base 'Exporter';
use POSIX;
use Date::Parse;
use DateTime::Format::Strptime;

our @EXPORT = qw(expand_string untemplate);

our $VERSION = '0.02';

my %special =
(
    '%' => sub { sprintf("%$_[0]", $_[1]) },
    ':' => sub { strftime($_[0], localtime(str2time($_[1]))) }
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
        return $field unless defined $f->{$1};
        return $special{$2}($3,$f->{$1});
    }

    return defined $f->{$field} ? $f->{$field} : $field;
}

#
# expand_string($string, \%fields)
# find "<fieldname>" or "<fieldname%sprintf format>"
# or "<fieldname:strftime format>" and replace them
#
sub expand_string
{
    my ($string, $fields) = @_;

    $string =~ s/<([^>]+)>/_replace($1, $fields)/ge;

    return $string;
}

#
# untemplate($template, $regex, $string)
# Attempt to go backwards with a regular expression, template
# and string to a record of fields.
#
sub untemplate
{
    my ($template, $re, $str) = @_;

    my %rec;

    my @fields = $template =~ /<([^>]+)>/g;

    @fields = map { s/%.*$// unless /:/; $_ } @fields;

    my @vals = $str =~ $re;

    for (my $i = 0; $i < @fields; $i++)
    {
        if ($fields[$i] =~ /([^:]+):(.+)$/)
        {
            $rec{$1}{format} .= "$2 ";
            $rec{$1}{value}  .= "$vals[$i] ";
        }
        else
        {
            $rec{$fields[$i]} = $vals[$i];
        }
    }

    foreach my $field (keys %rec)
    {
        if (ref $rec{$field})
        {
            my $strp = DateTime::Format::Strptime->new
                (pattern => $rec{$field}{format});
            my $dt = $strp->parse_datetime($rec{$field}{value});
            $rec{$field} = gmtime $dt->epoch;
        }
    }
    return \%rec;
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


  my $re = qr/...(\d{4})...(\w+)...(\d{4}/\d{2}/\d{2}.../;

  my $rec = untemplate($template, $re, $string);

  $rec = {
             'str'  => 'this',
             'num'  => '0002',
             'date' => 'Wed Feb 27 00:00:00 2008'
         };

=head1 DESCRIPTION

=head2 $str = expand_string($template, \%fields).

Fills in a simple template with values from a hash, replacing tokens
like "<fieldname>" with the value from the hash $fields->{fieldname}.

Some special characters can be used to impose formatting on the
fields:

 % - treat like a sprintf() format
 : - treat like a L<POSIX::strftime()> format

For the ':' strftime formats, the field is parsed by L<Date::Parse>,
so it can handle any format that can handle.

=head2 $record = untemplate($template, $regex, $string)

Attempts (dates are, in particular, problematic), to go backwards,
constructing the record of fields from the template, string,
and a regular expression with capturing parens identical to the
regular expression.

=head1 SEE ALSO

L<String::Format> performs a similar function, with a different
syntax.

=head1 AUTHOR

Curt Tilmes, E<lt>curt@tilmes.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by NASA Goddard Space Flight Center

=cut
