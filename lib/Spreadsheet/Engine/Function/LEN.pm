package Spreadsheet::Engine::Function::LEN;

use strict;

use base 'Spreadsheet::Engine::Function::text';

sub arguments { [1] }

sub calculate {
  my ($self, $string) = @_;
  return length $string;
}

sub result_type { 'n' }

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::LEN - Spreadsheet funtion LEN()

=head1 SYNOPSIS

  =LEN(string)

=head1 DESCRIPTION

This provides the spreadsheet text funtion LEN()

=head2 arguments

This takes a single textual argument.

=head2 calculate

This returns the length of the string using Perl's length() function.

=head2 result_type

This returns a number.

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


