package Spreadsheet::Engine::Function::PRODUCT;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::series';

sub calculate {
  return sub {
    my ($in, $total) = @_;
    return $total * $in->{value};
  };
}

sub accumulator { 1 }

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::PRODUCT - Spreadsheet funtion PRODUCT()

=head1 SYNOPSIS

  =PRODUCT(list_of_numbers)

=head1 DESCRIPTION

This provides the spreadsheet text funtion PRODUCT()

=head2 calculate

This returns the sum of the values

=head2 accumulator

The default accumulator value for PRODUCT() is one.

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


