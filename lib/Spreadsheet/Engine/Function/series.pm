package Spreadsheet::Engine::Function::series;

use strict;

use Spreadsheet::Engine::Sheet qw/lookup_result_type operand_value_and_type/;

use base 'Spreadsheet::Engine::Function::base';

sub argument_count { -1 }

sub execute {
  my $self = shift;

  my $type = "";

  my $calculator  = $self->calculate;
  my $accumulator = $self->accumulator;

  return unless defined(my $foperand = $self->foperand);
  while (@$foperand) {
    my $value =
      operand_value_and_type($self->sheetdata, $foperand, $self->errortext,
      \my $tostype);

    if (substr($tostype, 0, 1) eq "n") {
      $accumulator =
        $calculator->({ value => $value, type => $tostype }, $accumulator);

      $type = lookup_result_type(
        $tostype,
        $type || $tostype,
        $self->typelookup->{plus}
      );

    } elsif (substr($tostype, 0, 1) eq "e" && substr($type, 0, 1) ne "e") {
      $type = $tostype;
    }
  }

  my $operand = $self->operand;
  my $result  = $self->result($accumulator) || 0;
  ($result, $type) = @$result if ref $result eq 'ARRAY';

  push @$operand, { type => $type || 'n', value => $result };

  return;
}

sub accumulator { undef }

sub result {
  my ($self, $accumulator) = @_;
  return $accumulator;
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::series - base class for series functions

=head1 SYNOPSIS

  use base 'Spreadsheet::Engine::Function::series';

  sub calculate { 
    return sub { 
      my ($value, $accumulator) = @_;
      # ... do stuff
      return $accumulator;
    };
  }

=head1 DESCRIPTION

This provides a base class for spreadsheet functions that reduce a list
of values to a single number, such as SUM(), MIN(), MAX() etc.

=head1 METHODS 

=head2 argument_count

By default all such functions take one or more argument.

=head2 execute 

This takes care of fetching the values from the list one at a time, and
then applies the sub provided by a subclass's 'calculate' method to each
in turn. For examples have a look at how SUM(), AVERAGE() etc are
implemented.

=head2 result_type

This usualy depends on the types of the arguments passed. See the
typelookup table in L<Spreadsheet::Engine::Sheet> for more details.

=head1 TO SUBCLASS

=head2 calculate

Returns a subref that is given each value in turn along with the
accumulator, and returns the new value for the accumulator. 

=head2 accumulator

This should provide the initial accumulator value. The default is to
set it to undef. 

=head2 result

Calculate the result based on the accumulator. The default is that the
result is whatever value is in the accumulator. Functions such as
AVERAGE() that need to perform extra calculations at the end can
override this.

=head1 HISTORY

This is a Modified Version of code extracted from SocialCalc::Functions
in SocialCalc 1.1.0

=head1 COPYRIGHT

Portions (c) Copyright 2005, 2006, 2007 Software Garden, Inc.
All Rights Reserved.

Portions (c) Copyright 2007 Socialtext, Inc.
All Rights Reserved.

Portions (c) Copyright 2007 Tony Bowden

=head1 LICENSE

The contents of this file are subject to the Artistic License 2.0;
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
  http://www.perlfoundation.org/artistic_license_2_0


