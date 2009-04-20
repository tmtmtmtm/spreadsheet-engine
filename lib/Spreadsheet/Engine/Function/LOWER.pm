package Spreadsheet::Engine::Function::LOWER;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::text';

sub arguments { [1] }

sub calculate {
  my ($self, $string) = @_;
  return lc $string;
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::LOWER - Spreadsheet funtion LOWER()

=head1 SYNOPSIS

  =LOWER(string)

=head1 DESCRIPTION

This provides the spreadsheet text funtion LOWER()

=head2 arguments

This takes a single textual argument.

=head2 calculate

This transforms the string using Perl's lc() function.

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


