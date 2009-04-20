package Spreadsheet::Engine::Function::MAX;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::series';

sub calculate {
  return sub {
    my ($in, $max) = @_;
    return $in->{value} if not defined $max;
    return ($in->{value} > $max) ? $in->{value} : $max;
  };
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::MAX - Spreadsheet funtion MAX()

=head1 SYNOPSIS

  =MAX(list_of_numbers)

=head1 DESCRIPTION

This provides the spreadsheet text funtion MAX()

=head2 calculate

This returns the maximum value from the list provided.

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


