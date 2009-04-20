package Spreadsheet::Engine::Function::MID;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::text';

sub arguments { [ 1, 0, 0 ] }

sub calculate {
  my ($self, $string, $start, $len) = @_;
  $len ||= 0;
  $len ||= 0;
  die 'Bad arguments' if $len < 0 or $start < 1;
  no warnings 'substr';
  return substr($string, $start - 1, $len);
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::MID - Spreadsheet funtion MID()

=head1 SYNOPSIS

  =MID(string, start, length)

=head1 DESCRIPTION

This provides the spreadsheet text funtion MID()

=head2 arguments

This takes a single textual argument, where to start, and the length
required.

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

