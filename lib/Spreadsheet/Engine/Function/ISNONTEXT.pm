package Spreadsheet::Engine::Function::ISNONTEXT;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::is';

sub calculate {
  my ($self, $op) = @_;
  return !$op->is_txt;
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::ISNONTEXT - Spreadsheet funtion ISNONTEXT()

=head1 SYNOPSIS

  =ISNONTEXT(value)

=head1 DESCRIPTION

This provides the spreadsheet text funtion ISNONTEXT()

=head2 calculate

Is the value non-textual?

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


