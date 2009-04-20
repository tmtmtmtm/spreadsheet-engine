#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

use lib 'lib';
use Spreadsheet::Engine;

my @data = <DATA>;
my $sheet = Spreadsheet::Engine->load_data(\@data);

$sheet->execute( 'set C2 formula DSUM(A4:D8,"Cost",A1:B2)');
$sheet->recalc;
is $sheet->raw->{datavalues}{C2}, 31, "DSUM";

$sheet->execute( 'set A2 text t >1001');
$sheet->recalc;
is $sheet->raw->{datavalues}{C2}, 19, "change criteria";

__DATA__
version:1.3
cell:A1:t:OrderNo
cell:B1:t:Qty
cell:A2:t:>=1000
cell:B2:t:>5
cell:A4:t:OrderNo
cell:B4:t:Qty
cell:C4:t:Cost
cell:A5:v:1000
cell:B5:v:4
cell:C5:v:30
cell:A6:v:1001
cell:B6:v:8
cell:C6:v:12
cell:A7:v:1002
cell:B7:v:2
cell:C7:v:24
cell:A8:v:1003
cell:B8:v:14
cell:C8:v:19
sheet:r:8:c:5

