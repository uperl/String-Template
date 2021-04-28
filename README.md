# String::Template ![linux](https://github.com/uperl/String-Template/workflows/linux/badge.svg) ![macos](https://github.com/uperl/String-Template/workflows/macos/badge.svg) ![windows](https://github.com/uperl/String-Template/workflows/windows/badge.svg) ![cygwin](https://github.com/uperl/String-Template/workflows/cygwin/badge.svg) ![msys2-mingw](https://github.com/uperl/String-Template/workflows/msys2-mingw/badge.svg)

Fills in string templates from hash of fields

# SYNOPSIS

```perl
use String::Template;

my %fields = ( num => 2, str => 'this', date => 'Feb 27, 2008' );

my $template = "...<num%04d>...<str>...<date:%Y/%m/%d>...\n";

print expand_string($template, \%fields);
#prints: "...0002...this...2008/02/27..."
```

# DESCRIPTION

Generate strings based on a template.

# FUNCTIONS

## expand\_string

```perl
my $str = expand_string($template, \%fields, $undef_flag);
```

Fills in a simple template with values from a hash, replacing tokens
like "&lt;fieldname>" with the value from the hash $fields->{fieldname}.

Some special characters can be used to impose formatting on the
fields:

```perl
% - treat like a sprintf() format
    e.g.  <int%02d>

: - treat like a L<POSIX::strftime()> format
    e.g. <date:%Y-%m-%d>

! - Just like ':', but with gmtime instead of localtime
    e.g. <gmdate!%Y-%m-%d %H:%M>

# - treat like args to substr()
    e.g. <str#0,2> or <str#4>
```

For the ':' strftime formats, the field is parsed by [Date::Parse](https://metacpan.org/pod/Date::Parse),
so it can handle any format that can handle.

Handling of undefined fields can be controlled with $undef\_flag.  If
it is false (default), undefined fields are simply replaced with an
empty string.  If set to true, the field is kept verbatim.  This can
be useful for multiple expansion passes.

The `{` character is specially special, since it allows fields to
contain additional characters that are not intended for formatting.
This is specially useful for specifying additional content inside a
field that may not exist in the hash, and which should be entirely
replaced with the empty string.

This makes it possible to have templates like this:

```perl
my $template = '<name><nick{ "%s"}><surname{ %s}>';

my $mack = { name => 'Mack', nick    => 'The Knife' };
my $jack = { name => 'Jack', surname => 'Sheppard'  };

expand_string( $template, $mack ); # Returns 'Mack "The Knife"'
expand_string( $template, $jack ); # Returns 'Jack Sheppard'
```

## expand\_stringi

```perl
my $str = expand_stringi($template, \%fields, $undef_flag);
```

expand\_stringi works just like expand\_string, except that tokens
and hash keys are treated case insensitively.

## missing\_values

```perl
my @missing = missing_values($template, \%fields, $dont_allow_undefs);
```

Checks to see if the template variables in a string template exist
in a hash.  Set $dont\_allow\_undefs to 1 to also check to see if the
values for all such keys are defined.

Returns a list of missing keys or an empty list if no keys were missing.

## expand\_hash

```perl
my $status = expand_hash($hash[, $maxdepth]);
```

Expand a hash of templates/values.  This function will repeatedly
replace templates in the values of the hash with the values of the
hash they reference, until either all "<>" templates are gone, or
it has iterated $maxdepth times (default 10).

Returns undef if there are unexpanded templates left, otherwise true.

# SEE ALSO

[String::Format](https://metacpan.org/pod/String::Format) performs a similar function, with a different
syntax.

# AUTHOR

Original author: Brian Duggan

Current maintainer: Graham Ollis <plicease@cpan.org>

Contributors:

Curt Tilmes

Jeremy Mates (thirg, JMATES)

José Joaquín Atria

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Brian Duggan.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
