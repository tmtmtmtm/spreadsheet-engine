package Spreadsheet::Engine::Function::TIME;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::hms';

sub argument_count { 3 }

sub result {
  my $self = shift;

  my $h_op = $self->next_operand_as_number;
  my $m_op = $self->next_operand_as_number;
  my $s_op = $self->next_operand_as_number;

  my $type = $self->optype(twoargnumeric => $h_op, $m_op, $s_op);
  return $type unless $type->is_num;

  my $result =
    (($h_op->value * 60 * 60) + ($m_op->value * 60) + $s_op->value) /
    (24 * 60 * 60);

  return Spreadsheet::Engine::Value->new(type => 'nt', value => $result);
}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::TIME - Spreadsheet funtion TIME()

=head1 SYNOPSIS

  =TIME(H,M,S)

=head1 DESCRIPTION

This converts an Hour, Minute, Second list into a time.

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


1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::TIME - Spreadsheet funtion TIME()

=head1 SYNOPSIS

  =TIME(h,m,s)

=head1 DESCRIPTION

This converts an HMS list into a time.

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


