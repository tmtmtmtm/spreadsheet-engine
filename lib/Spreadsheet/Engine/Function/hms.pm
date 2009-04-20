package Spreadsheet::Engine::Function::hms;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::base';

sub argument_count { 1 }

sub result {
  my $self = shift;

  my $op = $self->next_operand_as_number;
  my $type = $self->optype(oneargnumeric => $op, $op);
  return $type unless $type->is_number;

  my $fraction = $op->value - int($op->value);    # fraction of a day
  $fraction *= 24;

  my $H = int($fraction);
  $fraction -= int($fraction);
  $fraction *= 60;

  my $M = int($fraction);
  $fraction -= int($fraction);
  $fraction *= 60;

  my $S = int($fraction + ($op->value >= 0 ? 0.5 : -0.5));
  return Spreadsheet::Engine::Value->new(
    type  => $type->type,
    value => $self->calculate($H, $M, $S)
  );

}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::hms - base class for HMS functions

=head1 SYNOPSIS

  use base 'Spreadsheet::Engine::Function::hms';

  sub calculate { ... }

=head1 DESCRIPTION

This provides a base class for spreadsheet functions that operate on a
given time pre-split into hours, minutes, and seconds.

=head1 INSTANCE METHODS

=head2 calculate

This will be passed the hour, minute, and second as integers.

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


