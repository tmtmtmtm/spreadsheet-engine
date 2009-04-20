#!/usr/bin/perl

use strict;
use warnings;
use lib ('lib', 't/lib');

use SheetTest;
use Test::More tests => 2 * 9;

my $sheet = run_tests();
for my $cell ('A1' .. 'A9') {
  is $sheet->raw->{valuetypes}->{$cell}, 'e#VALUE!', "$cell = Error";
  like $sheet->raw->{datavalues}->{$cell}, qr/Incorrect arguments/,
    "$cell incorrect args";

}

__DATA__

# series
set A1 formula SUM()

# math
set A2 formula SIN(90,3)

# math2
set A3 formula POWER()
set A4 formula POWER(10)
set A5 formula POWER(10,2,2)

# count
set A6 formula COUNT()

# IS
set A7 formula ISTEXT()
set A8 formula ISTEXT(6, "a")

# Zero args
set A9 formula PI(3)
