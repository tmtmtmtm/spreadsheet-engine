package Spreadsheet::Engine::Function::FV;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::investment';

sub calculate {
  my $self = shift;
  my ($r, $n, $pmt, $pv, $type) = map { defined $_ ? $_->value : 0 } @_;

  $type = $type ? 1 : 0;

  my $fv = ($r == 0)    # simple calculation if no interest
    ? -$pv - ($pmt * $n)
    : -(
    $pv * (1 + $r)**$n + $pmt * (1 + $r * $type) * ((1 + $r)**$n - 1) / $r);

  return Spreadsheet::Engine::Value->new(type => 'n$', value => $fv);

}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::FV - Spreadsheet funtion FV()

=head1 SYNOPSIS

  =FV(rate, n, payment, [pv, [paytype]])

=head1 DESCRIPTION

This calculates the future value of an investment.

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


