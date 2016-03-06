package Alien::Builder::Interpolator::TextTemplate;

use strict;
use warnings;
use Text::Template;
use base qw( Alien::Builder::Interpolator );

# ABSTRACT: Alien::Builder interpolator using Text::Template
# VERSION

=head1 METHODS

=head2 interpolate

 my $string = $itr->interpolate($template);

=cut

sub interpolate
{
  my($self, $string) = @_;
  
  return undef unless defined $string;
  
  my $template = Text::Template->new(
    TYPE   => 'STRING',
    SOURCE => $string,
  );
    
  $template->fill_in(
    PACKAGE => 'Foo',
    HASH => {
      %{ $self->vars },
      map { tie my $helper, 'Alien::Builder::Interpolator::TextTemplate::Helper', $self, $_; $_ => $helper } keys %{ $self->helpers },
    },
  );
}

package Alien::Builder::Interpolator::TextTemplate::Helper;

use strict;
use warnings;
use Carp qw( croak );

sub TIESCALAR
{
  my($class, $interpolator, $name) = @_;
  bless { interpolator => $interpolator, name => $name }, $class;
}

sub FETCH
{
  my($self) = @_;
  $self->{interpolator}->execute_helper($self->{name});
}

sub STORE
{
  croak "helpers are read-only";
}

1;
