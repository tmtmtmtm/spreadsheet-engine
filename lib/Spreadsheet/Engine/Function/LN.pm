package Spreadsheet::Engine::Function::LN;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::math';

sub calculate {
  my ($self, $value) = @_;
  die 'LN argument must be greater than 0' unless $value > 0;
  return log $value;
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::LN - Spreadsheet funtion LN()

=head1 SYNOPSIS

  =LN(value)

=head1 DESCRIPTION

This returns the natural log of the given value.

=head2 arguments

This takes a single numeric argument.

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


