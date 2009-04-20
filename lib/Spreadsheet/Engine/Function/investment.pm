package Spreadsheet::Engine::Function::investment;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::base';

use Spreadsheet::Engine::Sheet qw/lookup_result_type/;

sub argument_count { -3 }

sub result {
  my $self   = shift;
  my @op     = map $self->next_operand_as_number, 1 .. @{ $self->foperand };
  my $type   = $self->optype(twoargnumeric => @op);
  my $result = $type->is_number ? $self->calculate(@op) : 0;
  return ref $result
    ? $result
    : Spreadsheet::Engine::Value->new(type => $type->type, value => $result);
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::investment - base class for investment functions

=head1 SYNOPSIS

  use base 'Spreadsheet::Engine::Function::investment';

  sub calculate { ... }

=head1 DESCRIPTION

This provides a base class for spreadsheet functions that calculate
interest rates, returns, etc. on investments.

=head1 INSTANCE METHODS

=head2 calculate

Subclasses should provide a 'calculate' method that return the final
value. They will be passed the full operand list.

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


