use Test::More;
use strict;

eval "use Test::Pod::Coverage 1.00";

plan skip_all => "Test::Pod::Coverage required for testing POD" if $@;
all_pod_coverage_ok();
