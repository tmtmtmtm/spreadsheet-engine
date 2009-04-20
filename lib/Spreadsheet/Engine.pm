package Spreadsheet::Engine;

use strict;

our $VERSION = '0.01';

1;

__END__

=head1 NAME

Spreadsheet::Engine - Core calculation engine for a spreadsheet

=head1 SYNOPSIS

  use Spreadsheet::Engine::Sheet;
	
	my $sheet = {};
	parse_sheet_save( [] => $sheet );

	execute_sheet_command($sheet => 'set A1 value n 2');
	execute_sheet_command($sheet => 'set A2 value n 4');
	execute_sheet_command($sheet => 'set A3 formula SUM(A1:A2)');
	recalc_sheet($sheet);
	print $sheet->{datavalues}{A3}; # 6

=head1 DESCRIPTION

This provides back-end spreadsheet functionality for creating a
sheet, setting cells to have value or formulae, and performing all
necessary calculations. There is no front-end UI provided - this
is purely the calculation engine.

Over 110 spreadsheet functions are provided: see
Spreadsheet::Engine::Functions for the full list.

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


