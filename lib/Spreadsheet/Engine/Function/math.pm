package Spreadsheet::Engine::Function::math;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::base';

use Spreadsheet::Engine::Sheet qw/operand_as_number lookup_result_type/;

use constant PI => atan2(1, 1) * 4;

sub execute {
  my $self = shift;

  my $fname      = $self->fname or die 'Name not set';
  my $operand    = $self->operand;
  my $foperand   = $self->foperand;
  my $errortext  = $self->errortext;
  my $typelookup = $self->typelookup;
  my $sheetdata  = $self->sheetdata;

  my $value =
    operand_as_number($sheetdata, $foperand, $errortext, \my $tostype);
  my $result_type =
    lookup_result_type($tostype, $tostype, $typelookup->{oneargnumeric});
  my $result = 0;

  if ($result_type eq 'n') {
    $result = eval { $self->calculate($value) };
  }

  if ($@) {
    $result      = $@;
    $result_type = 'e#NUM!';
  }

  push @{$operand}, { type => $result_type, value => $result };
  return;

}

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

=head2 execute

This checks that the parameters passed to the function are correct, and
if so delegates to the subclass to calculate().

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


