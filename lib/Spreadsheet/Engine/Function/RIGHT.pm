package Spreadsheet::Engine::Function::RIGHT;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::text';

sub arguments { [ 1, 0 ] }

sub calculate {
  my ($self, $string, $len) = @_;
  die 'Negative length' if ($len ||= 0) < 0;
  return substr $string, -$len, $len;
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::RIGHT - Spreadsheet funtion RIGHT()

=head1 SYNOPSIS

  =RIGHT(string, length)

=head1 DESCRIPTION

This provides the spreadsheet text funtion RIGHT() which returns
the rightmost characters from the end of the string.

=head2 arguments

This takes a single textual argument, and the length required

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


