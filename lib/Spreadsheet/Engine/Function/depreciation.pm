package Spreadsheet::Engine::Function::depreciation;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::base';

sub argument_count { 3 }

sub result {
  my $self    = shift;
  my $cost    = $self->next_operand_as_number;
  my $salvage = $self->next_operand_as_number;
  my $life    = $self->next_operand_as_number;
  die Spreadsheet::Engine::Error->num('life must be > 1') if $life < 1;
  my $result = $self->depreciate($cost, $salvage, $life);
  return Spreadsheet::Engine::Value->new(type => 'n$', value => $result);

}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::depreciate - base class for depreciation functions

=head1 SYNOPSIS

  use base 'Spreadsheet::Engine::Function::depreciation';

  sub depreciate { ... }

=head1 DESCRIPTION

This provides a base class for spreadsheet functions that perform
different methods of depreciation.

=head1 INSTANCE METHODS

=head2 depreciate

Subclasses should provide a 'depreciate' function that will be called with 
the cost, salvage, and lifetime operands. (Other operands can be taken
from the stack if required.)

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


