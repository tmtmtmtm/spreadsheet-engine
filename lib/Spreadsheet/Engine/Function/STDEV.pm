package Spreadsheet::Engine::Function::STDEV;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::VAR';

sub result {
  my ($self, $A) = @_;
  return [ 0, 'e#DIV/0!' ] unless $A->{count} > 1;
  return sqrt $self->SUPER::result($A);
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::STDEV - Spreadsheet funtion STDEV()

=head1 SYNOPSIS

  =STDEV(list_of_numbers)

=head1 DESCRIPTION

This provides the spreadsheet text funtion STDEV()

=head2 calculate

This returns the standard deviation.

=head2 result

We calculate as per Knuth 'The Art of Computer Programming" Vol. 2
3rd edition, page 232

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


