package Spreadsheet::Engine::Function::text;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::base';

use Encode;
use Spreadsheet::Engine::Sheet
  qw/function_args_error operand_as_number operand_as_text operand_value_and_type/;

sub result {
  my $self = shift;

  my $fname      = $self->fname or die 'Name not set';
  my $operand    = $self->operand;
  my $foperand   = $self->foperand;
  my $errortext  = $self->errortext;
  my $typelookup = $self->typelookup;
  my $sheetdata  = $self->sheetdata;

  my ($value, $tostype, @operand_value, @operand_type);

  my $numargs = scalar @{$foperand};
  my @argdef  = @{ $self->arguments };

  # go through each arg, get value and type, and check for errors
  for my $i (1 .. $numargs) {
    if ($i > scalar @argdef) {    # too many args
      function_args_error($fname, $self->operand, $errortext);
      return;
    }

    if ($argdef[ $i - 1 ] == 0) {
      $value =
        operand_as_number($sheetdata, $foperand, $errortext, \$tostype);
    } elsif ($argdef[ $i - 1 ] == 1) {
      $value = operand_as_text($sheetdata, $foperand, $errortext, \$tostype);
      $value = decode('utf8', $value);
    } elsif ($argdef[ $i - 1 ] == -1) {
      $value =
        operand_value_and_type($sheetdata, $foperand, $errortext, \$tostype);
    }

    $operand_value[$i] = $value;
    $operand_type[$i]  = $tostype;
    if (substr($tostype, 0, 1) eq 'e') {
      push @{$operand}, { type => $tostype, value => $value };
    }
  }

  my $result =
    eval { $self->calculate(@operand_value[ 1 .. $#operand_value ]) };
  my $result_type = $self->result_type;

  if ($@) {
    $result      = $@;
    $result_type = 'e#VALUE!';
  } else {
    $result = encode('utf8', $result);    # convert UTF-8 back to bytes
  }

  return { type => $result_type, value => $result };
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


