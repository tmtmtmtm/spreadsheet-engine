package Spreadsheet::Engine::Function::base;

use strict;
use warnings;

use Spreadsheet::Engine::Sheet qw/copy_function_args function_args_error/;

use Class::Struct;

struct(__PACKAGE__,
  {
    fname      => '$',
    operand    => '$',
    errortext  => '$',
    typelookup => '$',
    sheetdata  => '$'
  }
);

sub argument_count { undef }

sub foperand {
  my $self = shift;
  return $self->{_foperand} if defined $self->{_foperand};

  copy_function_args($self->operand, \my @foperand);

  my $want_args = $self->argument_count;
  return ($self->{_foperand} = \@foperand) unless defined $want_args;

  my $have_args = scalar @foperand;
  if ( ($want_args < 0 and $have_args < -$want_args)
    or ($want_args >= 0 and $have_args != $want_args)) {
    function_args_error($self->fname, $self->operand, $self->errortext);
    return ($self->{_foperand} = undef);
  }

  return ($self->{_foperand} = \@foperand);
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::base - base class for spreadsheet functions

=head1 SYNOPSIS

  use base 'Spreadsheet::Engine::Function::text';

=head1 DESCRIPTION

This provides a base class for spreadsheet functions.

Each function will generally have an intermediate base class that
extends this with methods specific to the type of function that it is
providing.

=head1 CONSTRUCTOR

=head2 new

Instantiates with the given variables.

=head1 INSTANCE VARIABLES

=head2 fname / operand / foperand / errortext / typelookup / sheetdata 

As per SocialCalc (to document fully later)

=head1 METHODS TO SUBCLASS

=head2 argument_count

Each function should declare how many arguments it expects. This should
be 0 for no arguments, a positive integer for exactly that many
arguments, or a negative integer for at least that many arguments (based
on the absolute value). If this method is not provided no checking of
arguments is performed.

=head1 HISTORY

This is a Modified Version of code extracted from SocialCalc::Functions
in SocialCalc 1.1.0

=head1 COPYRIGHT

Portions (c) Copyright 2005, 2006, 2007 Software Garden, Inc.
All Rights Reserved.

Portions (c) Copyright 2007 Socialtext, Inc.
All Rights Reserved.

Portions (c) Copyright 2007 Tony Bowden

=head1 LICENCE

The contents of this file are subject to the Artistic License 2.0;
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
  http://www.perlfoundation.org/artistic_license_2_0


