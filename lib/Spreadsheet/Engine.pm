package Spreadsheet::Engine;

use strict;
use warnings;

use Spreadsheet::Engine::Sheet (
  qw/parse_sheet_save execute_sheet_command recalc_sheet/);

our $VERSION = '0.13';

=head1 NAME

Spreadsheet::Engine - Core calculation engine for a spreadsheet

=head1 SYNOPSIS

  use Spreadsheet::Engine;
  
  my $sheet = Spreadsheet::Engine->new;
  my $sheet = Spreadsheet::Engine->load_data([@data]);

  $sheet->execute('set A1 value n 2');
  $sheet->execute('set A2 value n 4');
  $sheet->execute('set A3 formula SUM(A1:A2)');
  $sheet->recalc;

  my $data = $sheet->raw;
  print $data->{datavalues}{A3}; # 6

=head1 DESCRIPTION

This provides back-end spreadsheet functionality for creating a
sheet, setting cells to have value or formulae, and performing all
necessary calculations. There is no front-end UI provided - this
is purely the calculation engine.

Over 110 spreadsheet functions are provided: see
Spreadsheet::Engine::Function::* and L<Spreadsheet::Engine::Functions>
for the full list.

=head1 METHODS

=head2 new
  
  my $sheet = Spreadsheet::Engine->new;

Instantiate a new blank spreadsheet.

=cut

sub _new {
  my $class = shift;
  bless { _sheet => {} } => $class;
}

sub new {
  my $class = shift;
  return $class->load_data([]);
}

=head2 load_data

  my $sheet = Spreadsheet::Engine->load_data([@data]);

Instantiate a sheet from lines of data in the saved file format (see
L<Spreadsheet::Engine::Sheet> for doumentation>)

=cut

sub load_data {
  my ($class, $data) = @_;
  my $self = $class->_new;
  parse_sheet_save($data => $self->{_sheet});
  return $self;
}

=head2 execute

  $sheet->execute('set A1 value n 2');
  $sheet->execute('set A2 value n 4');
  $sheet->execute('set A3 formula SUM(A1:A2)');

Execute the given command against the sheet. See
L<Spreadsheet::Engine::Sheet> for documentation of commands.

=cut

sub execute {
  my ($self, $command) = @_;
  execute_sheet_command($self->{_sheet} => $command);
  return $self;
}

=head2 recalc

  $sheet->recalc;

Recalculate the values for all formulae in the sheet. This never happens
automatically - it must be explicitly called.

=cut

sub recalc {
  my $self = shift;
  recalc_sheet($self->{_sheet});
  return $self;
}

=head2 raw

  my $data = $sheet->raw;
  print $data->{datavalues}{A3}; # 6

Access the raw datastructure for the sheet. This is a temporary method
until we provide proper accessors to the underlying data.

=cut

sub raw {
  my $self = shift;
  return $self->{_sheet};
}

1;

=head1 WARNING

Although the core underlying code is relatively mature and featureful,
there will be significant interface changes and refactoring going
forward with this version. There are very few automated tests as yet, so
this process is likely to introduce bugs. Please pay close attention to
the CHANGES file if you upgrade this package.

=head1 OPEN FORMULA SPECIFICATION

Spreadsheet::Engine attemps to conform as closely as possible to the
Open Formula specification and provide all the features of the "Small"
group as defined there. Divergences from that are detailed below. It is
hoped to add the extra functionality of the "Medium" and "Large" groups
eventually, but the initial work is on refactoring the code base to make
it easier for users to plug in their own extensions to provide more of
that functionality.

The latest version of the specification can be found at 
  L<http://www.oasis-open.org/committees/office>

=head1 EXTRAS

On top of the "Small" group functionality the following features are
provided:

=over 4

=item * "Year 1583": Dates between 1593 and 1900 are handled correctly

=item * Text is automatically converted to numbers in some (but not all)
circumstances (see t/of-autonum.t gives examples)

=item * PLAINTEXT() and HTML() functions

=back

=head1 KNOWN BUGS AND SHORTCOMINGS

Patches are welcome to fix any of these!

=over 4

=item * (4.8.7) Whitespace is significant in database tests: '> 2006-01-01

=item * (5.6) Empty parameters cannot be omitted: IF(FALSE(),7,) 

=item * (5.8) Semicolon is not recognised as a separator in function
calls, cell/range lists, etc.: SUM(A1;B2;B3), IF(FALSE();7;8)

=item * (5.8) Cell references of the form [.B1] are not supported

=item * (5.8) References to other sheets are not supported

=item * (5.10.1) Range names cannot contain unicode characters 

=item * (5.10.1) Range names do not support $$ markers 

=item * (5.11) Errors cannot be entered as strings: #N/A, #DIV/0! etc

=item * (6.2.4) Empty cell in numeric context is not treated as 0

=item * (6.2.4) Reference to TRUE in numeric context is not treated as 0

=item * (6.3.10) Whitespace is significant in string-concatenation using &

=item * (6.3.2) Whitespace is significant in unary minus: (5 - - 2) vs (5--2)

=item * (6.3.6) Different types can be equal: 5 = "5"

=item * (6.3.9) Range extensions are not implemented: B4:C4:C5

=item * (6.3.11) Range intersections are not implemented: B3:B5!B5:B6

=item * (6.3.14) Strings are converted to number with prefix +: +"Hello"

=item * (6.9.1) Roll-over dates may not be correct (DATE(2006,25,34) =
2008-02-05 vs 2008-02-03)

=item * (6.12.5) COUNT() includes TRUE/FALSE values

=item * (6.12.32) VALUE("-1 1/2") is interpreted (-1)+(1/2) not -1.5

=item * (6.12.32) VALUE("3/32/2006") is interpreted as 1st April 2006

=item * (6.12.32) VALUE does not raise error for false leap years

=item * (6.12.32) Cannot take VALUE() of a datetime (with space or T)

=item * (6.12.32) Cannot enter dates with alphabetic month names

=item * (6.13.11) VLOOKUP for an integer must be exact, not <=

=item * (6.14.3) IF() does not have default ifTrue/ifFalse values

=item * (6.15.29) FACT() operates on negative numbers

=item * (6.15.44) PRODUCT() with no paramters is an error

=item * (6.17.45) MIN("a") returns 0 rather than an error

=item * (6.19.11) LEFT() does not have a default length

=item * (6.19.14) MID() with a start beyond string returns undef

=item * (6.19.18) RIGHT() does not have a default length

=back

=head2 FIXED

=over 

=item * (6.19.14) MID() does not accept a zero length

=item * (6.15.37) LOG() does not default to base 10

=back

=head1 HISTORY

The original Spreadsheet::Engine code was taken from SocialCalc version
1.1.0, which in turn originated as wikiCalc(R) version 1.0. 

=head1 AUTHORS

Spreadsheet::Engine is developed and maintained by Tony Bowden
<tony@tmtm.com>

SocialCalc 1.1.0 was developed by Dan Bricklin, Casey West, and Tony
Bowden, at Socialtext, Inc. 

wikiCalc was developed by Dan Bricklin, at Software Garden, Inc. 

=head1 COPYRIGHT

Portions (c) Copyright 2005, 2006, 2007 Software Garden, Inc.
All Rights Reserved.

Portions (c) Copyright 2007 Socialtext, Inc.
All Rights Reserved.

Portions (c) Copyright 2007, 2008 Tony Bowden. Some Rights Reserved.

=head1 LICENCE

The contents of this file are subject to the Artistic License 2.0;
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
  http://www.perlfoundation.org/artistic_license_2_0

=cut

