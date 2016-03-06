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
  
  my $helper = Alien::Builder::Interpolator::TextTemplate::Helpers->new($self);
  
  $template->fill_in(
    PACKAGE => 'Foo',
    HASH => {
      %{ $self->vars },
      helper => \$helper,
    },
  );
}

package Alien::Builder::Interpolator::TextTemplate::Helpers;

use strict;
use warnings;
use Object::Method ();

sub new
{
  my($class, $interpolator) = @_;
  my $self = bless { }, $class;
  foreach my $method (keys %{ $interpolator->helpers })
  {
    Object::Method::method($self, $method => sub { $interpolator->execute_helper($method) });
  }
  $self;
}

1;
