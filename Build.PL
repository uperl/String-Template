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
    },
    test_requires => {
        'Test::Pod' => 0,
        'Test::Pod::Coverage' => 0,
        $^O eq 'MSWin32' ? ('Time::Piece' => '1.17') : (),
    },
    configure_requires => {
        'Module::Build' => 0.36,
    },
    add_to_cleanup      => [ 'String-Template-*' ],
    meta_merge => {
        resources => {
            repository => 'https://github.com/plicease/String-Template',
            bugtracker => 'https://github.com/plicease/String-Template/issues',
        },
    },
);

$builder->create_build_script();
