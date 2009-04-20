package Spreadsheet::Engine::Function::WEEKDAY;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::dates';

sub argument_count { -1 }

sub calculate {
  my ($self, $date) = @_;
  my $type    = $self->_type;
  my $doffset = 6;
  $doffset-- if $type > 1;
  return int($date + $doffset) % 7 + ($type < 3 ? 1 : 0);
}

sub _type {
  my $self = shift;
  return 1 unless @{ $self->foperand } > 0;
  my $op = $self->next_operand_as_number;
  die Spreadsheet::Engine::Error->val
    if !$op->is_num || $op->value < 1 || $op->value > 3;
  return $op->value;
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::WEEKDAY - Spreadsheet funtion WEEKDAY()

=head1 SYNOPSIS

  =WEEKDAY(date, [type])

=head1 DESCRIPTION

This returns the day of the week for the given date. 

If type is 1, then Sunday is the first day of the week (value 1)

If type is 2, then Monday is the first day of the week (value 1)

If type is 3, then Monday is the first day of the week (value 0)

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


