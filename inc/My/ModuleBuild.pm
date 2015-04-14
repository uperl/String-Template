package My::ModuleBuild;

use strict;
use warnings;
use 5.008001;
use base qw( Module::Build );

sub new
{
  my($class, %args) = @_;

  $args{test_requires}->{'Time::Piece'} = '1.17' if $^O eq 'MSWin32';
  
  my $self = $class->SUPER::new(%args);
  
  $self;
}

1;
