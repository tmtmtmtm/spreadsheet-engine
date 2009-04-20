package Spreadsheet::Engine::Function::math;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::base';

use Spreadsheet::Engine::Sheet qw/lookup_result_type/;

use constant PI => atan2(1, 1) * 4;

sub argument_count { 1 }

sub result {
  my $self = shift;

  my $op = $self->next_operand_as_number;

  my $result_type =
    lookup_result_type($op->{type}, $op->{type},
    $self->typelookup->{oneargnumeric});

  if (my $check = $self->arg_check) {
    die {
      type  => 'e#NUM!',
      value => 'Invalid arguments',
      }
      unless $check->($op->{value});
  }

  my $result = $result_type eq 'n' ? $self->calculate($op->{value}) : 0;

  return { type => $result_type, value => $result };

}

sub arg_check { }

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::math - base class for math functions

=head1 SYNOPSIS

  use base 'Spreadsheet::Engine::Function::math';

  sub calculate { ... }

=head1 DESCRIPTION

This provides a base class for spreadsheet functions that perform
mathematical functions on a single argument (ABS(), SIN(), SQRT() etc).

Subclasses should provide 'calculate' function that will be called with 
the argument provided.

=head1 INSTANCE METHODS

=head2 calculate

Subclasses should provide this as the workhorse. It should either return
the result, or die with an error message (that will be trapped and
turned into a e#NUM! error).

=head2 arg_check

Before calulate is called, an arg_check subref, if provided, will be
called to check that the argument passed to the function is acceptable.
This is an interim step towards proper argument validation. Be careful
about relying on it.

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


