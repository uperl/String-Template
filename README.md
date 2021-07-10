# String::Template ![static](https://github.com/uperl/String-Template/workflows/static/badge.svg) ![linux](https://github.com/uperl/String-Template/workflows/linux/badge.svg) ![macos](https://github.com/uperl/String-Template/workflows/macos/badge.svg) ![windows](https://github.com/uperl/String-Template/workflows/windows/badge.svg) ![cygwin](https://github.com/uperl/String-Template/workflows/cygwin/badge.svg) ![msys2-mingw](https://github.com/uperl/String-Template/workflows/msys2-mingw/badge.svg)

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

## template language

Replacement tokens are denoted with angle brackets.  That is `<fieldname>`
is replaced by the values in the `\%fields` hash reference provided.

Some special characters can be used after the field name to impose formatting on the
fields:

- `%`

    Treat like a [sprintf](https://metacpan.org/pod/perlfunc#sprintf) format, example: `<int%02d>`.

- `:`

    Treat like a ["strftime" in POSIX](https://metacpan.org/pod/POSIX#strftime) format, example `<date:%Y-%m-%d>`.

    The field is parsed by [Date::Parse](https://metacpan.org/pod/Date::Parse), so it can handle any format that it
    can handle.

- `!`

    \[version 0.05\]

    Same as `:`, but with [gmtime](https://metacpan.org/pod/perlfunc#gmtime) instead of [localtime](https://metacpan.org/pod/perlfunc#localtime).

- `#`

    Treat like args to [substr](https://metacpan.org/pod/perlfunc#substr); example `<str#0,2>` or `<str#4>`.

- `{` and `}`

    \[version 0.20\]

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

# FUNCTIONS

All functions are exported by default, or by request, except for ["expand\_hash"](#expand_hash)

## expand\_string

```perl
my $str = expand_string($template, \%fields);
my $str = expand_string($template, \%fields, $undef_flag);
```

Fills in a simple template with values from a hash, replacing tokens
with the value from the hash `$fields{fieldname}`.

Handling of undefined fields can be controlled with `$undef_flag`.  If
it is false (default), undefined fields are simply replaced with an
empty string.  If set to true, the field is kept verbatim.  This can
be useful for multiple expansion passes.

## expand\_stringi

\[version 0.08\]

```perl
my $str = expand_stringi($template, \%fields);
my $str = expand_stringi($template, \%fields, $undef_flag);
```

`expand_stringi` works just like ["expand\_string"](#expand_string), except that tokens
and hash keys are treated case insensitively.

## missing\_values

\[version 0.06\]

```perl
my @missing = missing_values($template, \%fields);
my @missing = missing_values($template, \%fields, $dont_allow_undefs);
```

Checks to see if the template variables in a string template exist
in a hash.  Set `$dont_allow_undefs` to 1 to also check to see if the
values for all such keys are defined.

Returns a list of missing keys or an empty list if no keys were missing.

## expand\_hash

\[version 0.07\]

```perl
my $status = expand_hash($hash);
my $status = expand_hash($hash, $maxdepth);
```

Expand a hash of templates/values.  This function will repeatedly
replace templates in the values of the hash with the values of the
hash they reference, until either all `<fieldname>` templates are gone, or
it has iterated `$maxdepth` times (default 10).

Returns `undef` if there are unexpanded templates left, otherwise true.

This function must be explicitly exported.

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
