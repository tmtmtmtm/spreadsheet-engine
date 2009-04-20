package Spreadsheet::Engine::Function::LEFT;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::text';

sub argument_count { -2 }
sub arguments      { [ 1, '>=0' ] }

sub calculate {
  my ($self, $string, $len) = @_;
  return substr $string, 0, $len;
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::LEFT - Spreadsheet funtion LEFT()

=head1 SYNOPSIS

  =LEFT(string, length)

=head1 DESCRIPTION

This provides the spreadsheet text funtion LEFT()

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


