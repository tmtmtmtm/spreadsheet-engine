package Spreadsheet::Engine::Function::AVERAGE;

use strict;

use base 'Spreadsheet::Engine::Function::series';

sub calculate {
  return sub {
    my ($in,    $accum) = @_;
    my ($count, $sum)   = @$accum;
    $count++ if substr($in->{type}, 0, 1) eq 'n';
    $sum += $in->{value};    # Will be zero if type is not a number
    return [ $count, $sum ];
  };
}

sub accumulator { [ 0, 0 ] }

sub result {
  my ($self,  $accum) = @_;
  my ($count, $sum)   = @$accum;
  return [ 0, "e#DIV/0!" ] unless $count;
  return $sum / $count;
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::AVERAGE - Spreadsheet funtion AVERAGE()

=head1 SYNOPSIS

  =AVERAGE(list_of_numbers)

=head1 DESCRIPTION

This provides the spreadsheet text funtion AVERAGE()

=head2 calculate

This returns the numeric mean of the values

=head2 accumulator / result

The accumulator for AVERAGE() maintains a count and a running sum.

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


