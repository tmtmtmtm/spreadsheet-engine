package Spreadsheet::Engine::Function::VALUE;

use strict;
use warnings;

use base 'Spreadsheet::Engine::Function::base';

use Spreadsheet::Engine::Sheet qw/determine_value_type/;

sub argument_count { 1 }

sub result {
  my $self = shift;
  my $op   = $self->next_operand;

  if ($op->is_num || $op->is_blank) {
    return Spreadsheet::Engine::Value->new(type => 'n', value => $op->value);
  }

  if ($op->is_txt) {
    my $result = determine_value_type($op->value, \my $type);

    # TODO: make this a Value
    die Spreadsheet::Engine::Error->val if substr($type, 0, 1) ne 'n';
    return Spreadsheet::Engine::Value->new(type => 'n', value => $result);
  }

  die Spreadsheet::Engine::Error->val;

}

1;

__END__

=head1 NAME

Spreadsheet::Engine::Function::VALUE - Spreadsheet funtion VALUE()

=head1 SYNOPSIS

  =VALUE(value)

=head1 DESCRIPTION

This provides the spreadsheet text funtion N()

=head2 calculate

Convert a textual value to a number

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


