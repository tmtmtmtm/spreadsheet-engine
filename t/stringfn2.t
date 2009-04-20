#!/usr/bin/perl

use strict;
use warnings;
use lib ('lib', 't/lib');

use SheetTest;
use Test::More 'no_plan';

run_tests();

__DATA__
set A1 value n test string
set A2 value n  test   string  
set A3 value n TEST string
set A4 value n t
set A5 value n test 

set B1 formula RIGHT(A1,4)
test B1 ring
testtype B1 t

set B2 formula RIGHT(A1,0)
test B2 

set B3 formula RIGHT(A1)
like B3 Incorrect arguments
testtype B3 e#VALUE!

set B4 formula RIGHT(A1,-1)
like B4 Negative length

set B5 formula UPPER("fred")
test B5 FRED
# Can't capitalise an error message!
set B6 formula UPPER(B4)
test B6 

set C1 formula LEFT(A1,4)
test C1 test
set C2 formula LEFT(A1,0)
test C2 
set C3 formula LEFT(A1)
like C3 Incorrect arguments
set C4 formula LEFT(A1,-1)
like C4 Negative length

set D1 formula MID(A1,2,3)
test D1 est
set D2 formula MID(A1,2)
like D2 Incorrect arguments
set D3 formula MID(A1,-1,2)
like D3 Bad arguments

set E1 formula PROPER(A1)
test E1 Test String

set F1 formula LOWER(A3)
test F1 test string
set G1 formula REPT(A4,5)
test G1 ttttt
set G2 formula REPT(A5,0)
test G2 
set G3 formula REPT(A5,2)
test G3 test test 

set H1 formula REPLACE(A1,5,0,"ing")
test H1 testing string

set I1 formula SUBSTITUTE(A1,"t","h")
test I1 hesh shring
set I2 formula SUBSTITUTE(A1,"st","pool")
test I2 tepool poolring
set I3 formula SUBSTITUTE(A1,"t","k",2)
test I3 tesk string
set I4 formula SUBSTITUTE(A1,"t","k",5)
test I4 test string
set J1 formula FIND("st", A1)
test J1 3
set J2 formula FIND("st", A1, 4)
test J2 6
set K1 formula LEN(A1)
test K1 11
testtype K1 n
set L1 formula TRIM(A2)
test L1 test string
