use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'String::Template',
    VERSION_FROM      => 'lib/String/Template.pm',
    PREREQ_PM         => {Date::Parse => 0},
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/String/Template.pm',
       AUTHOR         => 'C. Tilmes <curt@tilmes.org') : ()),
);
