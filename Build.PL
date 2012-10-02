use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'String::Template',
    license             => 'perl',
    dist_author         => 'Brian Duggan <brian.duggan@nasa.gov>',
    dist_version_from   => 'lib/String/Template.pm',
    dist_abstract_from  => 'lib/String/Template.pm',
    requires => {
        'Date::Parse' => 0,
        POSIX => 0,
        'DateTime::Format::Strptime' => 0,
    },
    add_to_cleanup      => [ 'String-Template-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
