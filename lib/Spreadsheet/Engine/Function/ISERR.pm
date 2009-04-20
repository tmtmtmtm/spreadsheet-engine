package Spreadsheet::Engine::Function::ISERR;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::is';

sub calculate {
  my ($self, $major, $full) = @_;
  return $major eq 'e' && $full ne 'e#N/A';
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::ISERR - Spreadsheet funtion ISERR()

=head1 SYNOPSIS

  =ISERR(value)

=head1 DESCRIPTION

This provides the spreadsheet text funtion ISERR()

=head2 calculate

Is the value an error, other than NA?

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


