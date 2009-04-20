package Spreadsheet::Engine::Function::RATE;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::investment';

sub calculate {
  my $self = shift;
  my ($n, $payment, $pv, $fv, $paytype, $guess) =
    map { defined $_ ? $_->value : 0 } @_;

  $fv ||= 0;
  $paytype = $paytype ? 1 : 0;
  $guess ||= 0.1;

  # rate is calculated by repeated approximations
  # The deltas are used to calculate new guesses

  my $olddelta;
  my $maxloop = 100;
  my $tries   = 0;
  my $delta   = 1;
  my $epsilon = 0.0000001;               # this is close enough
  my $rate    = $guess || 0.00000001;    # zero is not allowed
  my $oldrate = 0;

  while (($delta >= 0 ? $delta : -$delta) > $epsilon && ($rate != $oldrate)) {
    $delta = $fv + $pv * (1 + $rate)**$n + $payment * (1 + $rate * $paytype) *
      ((1 + $rate)**$n - 1) / $rate;
    if (defined $olddelta) {
      my $m = ($delta - $olddelta) / ($rate - $oldrate)
        || .001;                         # get slope (not zero)
      $oldrate  = $rate;
      $rate     = $rate - $delta / $m;    # look for zero crossing
      $olddelta = $delta;
    } else {                              # first time - no old values
      $oldrate  = $rate;
      $rate     = 1.1 * $rate;
      $olddelta = $delta;
    }

    # Barf if we don't converge
    die Spreadsheet::Engine::Error->num if ++$tries >= $maxloop;
  }

  return Spreadsheet::Engine::Value->new(type => 'n%', value => $rate);

}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::RATE - Spreadsheet funtion RATE()

=head1 SYNOPSIS

  =RATE(n, payment, pv, [fv, [paytype, [guess]]])

=head1 DESCRIPTION

This calculates the interest rate per period of an investment.

=head1 HISTORY

This is a Modified Version of code extracted from SocialCalc::Functions
in SocialCalc 1.1.0

=head1 COPYRIGHT

Portions (c) Copyright 2005, 2006, 2007 Software Garden, Inc.
All Rights Reserved.

Portions (c) Copyright 2007 Socialtext, Inc.
All Rights Reserved.

Portions (c) Copyright 2008 Tony Bowden

=head1 LICENCE

The contents of this file are subject to the Artistic License 2.0;
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
  http://www.perlfoundation.org/artistic_license_2_0


