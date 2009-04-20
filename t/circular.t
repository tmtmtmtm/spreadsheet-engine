use Test::More tests => 2;

use strict;

use lib 'lib';
use_ok 'Spreadsheet::Engine::Sheet';

my $sheet = {};
parse_sheet_save([] => $sheet);

chomp(my @cmds = <DATA>);
execute_sheet_command($sheet => $_) foreach @cmds;
recalc_sheet($sheet);

is $sheet->{sheetattribs}->{circularreferencecell}, 'A4|A4', 'Circular';

__DATA__
set A1 value n 2
set A2 value n 3
set A3 value n 4
set A4 formula SUM(A1:A4)

