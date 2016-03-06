use strict;
use warnings;
use Test::More;
use Alien::Builder::Interpolator::TextTemplate;

subtest 'create simple' => sub {
  my $itr = Alien::Builder::Interpolator::TextTemplate->new;
  isa_ok $itr, 'Alien::Builder::Interpolator::TextTemplate';  
  is $itr->interpolate("%"), '%', 'double %';
  is $itr->interpolate("%%"), '%%', 'double double %';
  is $itr->interpolate("\\{"), '{', 'curly brace';
};

subtest 'var' => sub {

  my $itr = Alien::Builder::Interpolator::TextTemplate->new(
    vars => { a => "abc", p => "%a" },
  );
  
  is $itr->interpolate('hi { $a } there'), "hi abc there", "simple interpolate";
  is $itr->interpolate('hi { $a } % { $a } there'), 'hi abc % abc there', "multiple interpolate";
  is $itr->interpolate('hi { $a } { $p } { $a } there'), 'hi abc %a abc there', "var with % as value";

};

subtest 'helper' => sub {

  my $itr = Alien::Builder::Interpolator::TextTemplate->new(
    vars    => { a => "abc" },
    helpers => { ab => '"ab" . "bc"', p2 => '"%{ab}"', p3 => "'%a'" },
  );
  
  is $itr->interpolate('hi { $helper->ab } there'), "hi abbc there", 'simple helper';
  is $itr->interpolate('hi { $helper->ab } { $helper->p2 } there'), "hi abbc %{ab} there", "helper with %{}";
  is $itr->interpolate('hi { $helper->ab } { $helper->p3 } { $a } there'), "hi abbc %a abc there", 'helper with %.';

};

subtest undef => sub {
  plan tests => 1;
  
  my $itr = Alien::Builder::Interpolator::TextTemplate->new;
  
  is $itr->interpolate(undef), undef, 'undef => undef';

};

done_testing;
