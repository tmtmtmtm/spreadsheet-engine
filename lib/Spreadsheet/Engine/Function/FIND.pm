package Spreadsheet::Engine::Function::FIND;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::text';

sub argument_count { -2 }

sub arguments { [ 1, 1, 0 ] }

sub calculate {
  my ($self, $want, $string, $offset) = @_;
  $offset = 1 unless defined $offset;

  # TODO create signature for optional args
  die Spreadsheet::Engine::Error->val('Start is before string')
    if $offset < 1;
  my $result = index $string, $want, $offset - 1;
  die Spreadsheet::Engine::Error->val('Not found') unless $result >= 0;
  return $result + 1;
}

sub result_type { 'n' }

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::FIND - Spreadsheet funtion FIND()

=head1 SYNOPSIS

  =FIND(want, string, [offset])

=head1 DESCRIPTION

This provides the spreadsheet text funtion LEN()

=head2 arguments

This takes the string you want to find, the string you want to find it
in, and an optional offset.

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


