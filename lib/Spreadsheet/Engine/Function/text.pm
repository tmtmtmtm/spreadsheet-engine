package Spreadsheet::Engine::Function::text;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::base';

use Encode;
use Spreadsheet::Engine::Sheet
  qw/function_args_error operand_as_number operand_as_text operand_value_and_type/;

sub argument_count { 1 }

sub _opvals {
  my $self = shift;

  my $numargs = scalar @{ $self->foperand };
  my @argdef  = @{ $self->arguments };

  my @opvals = ();

  for my $sig (@argdef[ 0 .. $numargs - 1 ]) {
    my $op;

    if ($sig =~ /^([<>]=?)(\d+)/) {    # >=0 <1 etc.
      my ($test, $num) = ($1, $2);
      $op = $self->next_operand_as_number;
      my $val = $op->value;
      die Spreadsheet::Engine::Error->val('Invalid arguments')
        unless eval "$val $test $num";
    } elsif ($sig == 0) {              # any number
      $op = $self->next_operand_as_number;
    } elsif ($sig == 1) {              # any string
      $op = $self->next_operand_as_text;
      $op->value(decode('utf8', $op->value));
    }

    die $op if $op->is_error;
    push @opvals, $op->value;
  }
  return @opvals;
}

sub result {
  my $self = shift;

  return Spreadsheet::Engine::Value->new(
    type  => $self->result_type,
    value => encode('utf8', $self->calculate($self->_opvals)),
  );
}

sub result_type { 't' }

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::text - base class for text functions

=head1 SYNOPSIS

  use base 'Spreadsheet::Engine::Function::text';

  sub arguments { [ 1 ] }

  sub calculate { ... }

=head1 DESCRIPTION

This provides a base class for spreadsheet functions that operate on
text, such as UPPER(), LOWER(), REPLACE() etc.

Subclasses should provide an 'arguments' method detailing the number and
type of arguments they should receive, and a 'calculate' function that
will be called with those arguments.

=head1 INSTANCE METHODS

=head2 calculate

Subclasses should provide this as the workhorse. It should either return
the result, or die with an error message (that will be trapped and
turned into a spreadsheet error).

=head2 result_type

Most text functions return a text string, so we provide that as the
default value. Functions that return something different (e.g. LENGTH)
should override this.

=head1 HISTORY

This is a Modified Version of code extracted from SocialCalc::Functions
in SocialCalc 1.1.0

=head1 COPYRIGHT

Portions (c) Copyright 2005, 2006, 2007 Software Garden, Inc.
All Rights Reserved.

Portions (c) Copyright 2007 Socialtext, Inc.
All Rights Reserved.

Portions (c) Copyright 2007, 2008 Tony Bowden

=head1 LICENCE

The contents of this file are subject to the Artistic License 2.0;
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
  http://www.perlfoundation.org/artistic_license_2_0


