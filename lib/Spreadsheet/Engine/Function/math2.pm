package Spreadsheet::Engine::Function::math2;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::base';

use Spreadsheet::Engine::Sheet qw/lookup_result_type/;

sub argument_count { 2 }

sub result {
  my $self = shift;

  my $op1 = $self->next_operand_as_number;
  my $op2 = $self->next_operand_as_number;

  my $result_type =
    lookup_result_type($op1->{type}, $op2->{type},
    $self->typelookup->{twoargnumeric});

  my $result =
    ($result_type eq 'n')
    ? eval { $self->calculate($op1->{value}, $op2->{value}) }
    : 0;

  if ($@) {
    $result      = $@->{message} || 'Invalid arguments';
    $result_type = $@->{type}    || 'e#NUM!';
  }

  return { type => $result_type, value => $result };

}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::math2 - base class for 2arg math functions

=head1 SYNOPSIS

  use base 'Spreadsheet::Engine::Function::math2';

  sub calculate { ... }

=head1 DESCRIPTION

This provides a base class for spreadsheet functions that perform
mathematical functions with two arguments (POWER(), MOD(), etc)

Subclasses should provide 'calculate' function that will be called with 
the arguments provided.

=head1 INSTANCE METHODS

=head2 calculate

Subclasses should provide this as the workhorse. It should either return
the result, or die with an error message (that will be trapped and
turned into a e#NUM! error).

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


