package Spreadsheet::Engine::Function::COUNTBLANK;

use strict;

use base 'Spreadsheet::Engine::Function::counter';

sub calculate {
  return sub {
    my $type = shift;
    return substr($type, 0, 1) eq 'b';
  };
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::COUNTBLANK - Spreadsheet funtion COUNTBLANK()

=head1 SYNOPSIS

  =COUNTBLANK(list)

=head1 DESCRIPTION

This provides the spreadsheet text funtion COUNTBLANK()

=head2 calculate

This returns the count of how many values in the list are blank.

=head2 accumulator

The default accumulator value is zero.

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


