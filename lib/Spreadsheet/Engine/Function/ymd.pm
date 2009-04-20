package Spreadsheet::Engine::Function::ymd;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::base';

use Spreadsheet::Engine::Sheet qw/convert_date_julian_to_gregorian/;

use constant JULIAN_OFFSET => 2_415_019;

sub argument_count { 1 }

sub result {
  my $self = shift;
  my $op   = $self->next_operand_as_number;
  my $type = $self->optype(oneargnumeric => $op, $op);
  my ($y, $m, $d) =
    convert_date_julian_to_gregorian(int($op->value + JULIAN_OFFSET));
  my $result = $type->is_number ? $self->calculate($y, $m, $d) : 0;
  return Spreadsheet::Engine::Value->new(type => $type->type,
    value => $result);
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::ymd - base class for DMY functions

=head1 SYNOPSIS

  use base 'Spreadsheet::Engine::Function::ymd';

  sub calculate { ... }

=head1 DESCRIPTION

This provides a base class for spreadsheet functions that operate on a
single date pre-split into year, month, and day.

=head1 INSTANCE METHODS

=head2 calculate

This will be passed the year, month, and day.

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


