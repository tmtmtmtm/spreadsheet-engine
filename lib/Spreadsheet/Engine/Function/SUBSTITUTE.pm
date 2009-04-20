package Spreadsheet::Engine::Function::SUBSTITUTE;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::text';

sub arguments { [ 1, 1, 1, 0 ] }

sub calculate {
  my ($self, $string, $oldtext, $newtext, $which) = @_;
  die 'Invalid arguments' if defined $which and $which == 0;
  if (!$which) {
    $string =~ s/\Q$oldtext\E/$newtext/g if length $oldtext > 0;
  } elsif ($which >= 1) {
    for my $i (1 .. $which) {
      if ($i == $which) {
        $string =~ s/\G(.*?)\Q$oldtext\E/$1$newtext/;
        last;
      }
      last unless $string =~ m/\Q$oldtext\E/g;
    }
  }
  return $string;
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::SUBSTITUTE - Spreadsheet funtion SUBSTITUTE()

=head1 SYNOPSIS

  =SUBSTITUTE(string, oldtext, newtext, [which])

=head1 DESCRIPTION

This provides the spreadsheet text funtion SUBSTITUTE()

=head2 arguments

This takes the original string, the text to be replaced, and the text to
replace it with. If the optional 'which' paramater is gien, only that
occurence is replaced.

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


