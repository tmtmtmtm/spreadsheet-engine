#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';

use lib 'lib';
use Spreadsheet::Engine;

my $sheet = Spreadsheet::Engine->new;

chomp(my @cmds = <DATA>);
foreach my $cmd (@cmds) {
  next                  if $cmd =~ /^#/;
  $sheet->execute($cmd) if $cmd =~ /^(set|name)/;
  $sheet->recalc if $cmd eq 'recalc';
  is($sheet->raw->{datavalues}{$1}, $2, "$1 = $2")
    if $cmd =~ /^test\s(\w+)\s(.*?)$/;    # not multi-space
  is($sheet->raw->{valuetypes}{$1}, $2, "$1 = $2")
    if $cmd =~ /^testtype\s(\w+)\s(.*?)$/;
  like($sheet->raw->{datavalues}{$1}, qr/$2/, "$1 =~ $2")
    if $cmd =~ /^like\s(\w+)\s(.*?)$/;
}

__DATA__
set A1 value n test string
set A2 value n  test   string  
set A3 value n TEST string
set A4 value n t
set A5 value n test 

set B1 formula RIGHT(A1,4)
set B2 formula RIGHT(A1,0)
set B3 formula RIGHT(A1)
set B4 formula RIGHT(A1,-1)
set B5 formula UPPER(B4)
set C1 formula LEFT(A1,4)
set C2 formula LEFT(A1,0)
set C3 formula LEFT(A1)
set C4 formula LEFT(A1,-1)
set D1 formula MID(A1,2,3)
set D2 formula MID(A1,2)
set D3 formula MID(A1,-1,2)
set E1 formula PROPER(A1)
set F1 formula LOWER(A3)
set G1 formula REPT(A4,5)
set G2 formula REPT(A5,0)
set G3 formula REPT(A5,2)
set H1 formula REPLACE(A1,5,0,"ing")
set I1 formula SUBSTITUTE(A1,"t","h")
set I2 formula SUBSTITUTE(A1,"st","pool")
set I3 formula SUBSTITUTE(A1,"t","k",2)
set I4 formula SUBSTITUTE(A1,"t","k",5)
set J1 formula FIND("st", A1)
set J2 formula FIND("st", A1, 4)
set K1 formula LEN(A1)
set L1 formula TRIM(A2)
recalc

test B1 ring
testtype B1 t
test B2 
like B3 Incorrect arguments
testtype B3 e#VALUE!
like B4 Negative length
# Can't capitalise an error message!
test B5 
test C1 test
test C2 
like C3 Incorrect arguments
like C4 Negative length
test D1 est
like D2 Incorrect arguments
like D3 Bad arguments
test E1 Test String
test F1 test string
test G1 ttttt
test G2 
test G3 test test 
test H1 testing string
test I1 hesh shring
test I2 tepool poolring
test I3 tesk string
test I4 test string
test J1 3
test J2 6
test K1 11
testtype K1 n
test L1 test string
