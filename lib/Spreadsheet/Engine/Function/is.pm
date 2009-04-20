package Spreadsheet::Engine::Function::is;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::base';

sub argument_count { 1 }

sub result {
  my $self = shift;
  my $result = $self->calculate($self->next_operand) ? 1 : 0;
  return Spreadsheet::Engine::Value->new(type => 'nl', value => $result);
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::is - base class for IS functions

=head1 SYNOPSIS

  use base 'Spreadsheet::Engine::Function::is';

  sub calculate { ... }

=head1 DESCRIPTION

This provides a base class for spreadsheet functions that perform
IS checks (ISBLANK(), ISERR()) etc.
mathematical functions on a single argument (ABS(), SIN(), SQRT() etc).

=head1 INSTANCE METHODS

=head2 calculate

Subclasses should provide 'calculate' function that will be called with 
the major type and the full type of the referenced value.

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


