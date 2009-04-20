use Test::More 'no_plan';

use strict;

use lib 'lib';
use Spreadsheet::Engine;

my $sheet = Spreadsheet::Engine->new;

chomp(my @cmds = <DATA>);
foreach my $cmd (@cmds) {
  $sheet->execute($cmd) if $cmd =~ /^(set|name)/;
  $sheet->recalc if $cmd eq 'recalc';
  is($sheet->raw->{datavalues}{$1}, $2, "$1 = $2")
    if $cmd =~ /^test\s+(\w+)\s+(.*?)$/;
}

__DATA__
set A1 value n 2
set A2 value n 3
set A3 value n 4
set A4 formula SUM(A1:A3)
set A5 formula AVERAGE(A1:A3)
name define myrange A1:A3
set A6 formula PRODUCT(myrange)
set A7 formula MIN(myrange)
set A8 formula MAX(myrange)
set A9 formula SUMIF(myrange, ">2", myrange)
recalc
test A3 4
test A4 9
test A5 3
test A6 24
test A7 2
test A8 4
test A9 7

