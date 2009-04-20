package Spreadsheet::Engine::Function::DDB;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::depreciation';
use List::Util 'min';

sub argument_count { -4 }

sub depreciate {
  my ($self, $cost, $salvage, $lifetime) = @_;
  my $period = $self->next_operand_as_number;
  my $method =
    @{ $self->foperand } ? $self->next_operand_as_number->value : 2;

  my $depreciation = 0;    # calculated for each period
  my $accumulated  = 0;    # accumulated by adding each period's

  # calculate for each period based on net from previous
  for my $i (1 .. min($period->value, $lifetime->value)) {
    $depreciation =
      ($cost->value - $accumulated) * ($method / $lifetime->value);
    {                      # don't go lower than salvage value
      my $bottom = $cost->value - $salvage->value - $accumulated;
      $depreciation = $bottom if $bottom < $depreciation;
    }
    $accumulated += $depreciation;
  }
  return $depreciation;
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::DDB - Spreadsheet funtion DDB()

=head1 SYNOPSIS

  =DDB(cost, salvage, lifetime, period, [lifetime])

=head1 DESCRIPTION

This calculates depreciation by double declining balance.

See: http://en.wikipedia.org/wiki/Depreciation

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


