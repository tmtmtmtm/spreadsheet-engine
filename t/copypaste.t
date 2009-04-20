#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use lib 'lib';
use Spreadsheet::Engine::Sheet;

my $sheet = {};
parse_sheet_save([] => $sheet);

chomp(my @cmds = <DATA>);
foreach my $cmd (@cmds) {
  if ($cmd eq 'recalc') {
    recalc_sheet($sheet) if $cmd eq 'recalc';
  } elsif ($cmd =~ /^test\s+(\w+)\s+(.*?)$/) {
    is($sheet->{datavalues}{$1}, $2, "$1 = $2");
  } else {
    execute_sheet_command($sheet => $cmd);
  }
}

__DATA__
set A1 value n 2
set A2 value n 3
set A3 value n 4
copy A1:A3 all
paste A4:A6 all
recalc
test A3 4
test A4 2
test A5 3
test A6 4
