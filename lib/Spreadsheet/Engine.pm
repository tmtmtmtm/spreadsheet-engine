package Spreadsheet::Engine;

use strict;
use Spreadsheet::Engine::Sheet (
  qw/parse_sheet_save execute_sheet_command recalc_sheet/);

our $VERSION = '0.05';

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
Spreadsheet::Engine::Functions for the full list.

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
L<Spreadsheet::Engine::Sheet for doumentation>)

=cut

sub load_data { 
  my ($class, $data) = @_;
  my $self  = $class->_new;
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

=head1 HISTORY

The original Spreadsheet::Engine code was taken from SocialCalc version
1.1.0, which in turn originated as wikiCalc(R) version 1.0. 

=head1 AUTHORS

wikiCalc was developed by Dan Bricklin, at Software Garden, Inc. 

SocialCalc 1.1.0 was developed by Dan Bricklin, Casey West, and Tony
Bowden, at Socialtext, Inc. 

Spreadsheet::Engine is developed and maintained by Tony Bowden
<tony@tmtm.com>

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

=cut
