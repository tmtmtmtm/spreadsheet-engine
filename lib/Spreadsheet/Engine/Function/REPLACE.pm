package Spreadsheet::Engine::Function::REPLACE;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::text';

sub argument_count { 4 }
sub arguments      { [ 1, '>=1', '>=0', 1 ] }

sub calculate {
  my ($self, $string, $start, $len, $new) = @_;
  substr $string, $start - 1, $len, $new;
  return $string;
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::REPLACE - Spreadsheet funtion REPLACE()

=head1 SYNOPSIS

  =REPLACE(string, start, length, newtext)

=head1 DESCRIPTION

This provides the spreadsheet text funtion REPLACE()

=head2 arguments

This takes the initial string, the offset into that string at which to
begin, the number of characters to replace, and the text to be replaced
with.

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


