package Spreadsheet::Engine::Functions;
## no critic

=head1 NAME

Spreadsheet::Engine::Functions - Spreadsheet functions (SUM, MAX, etc)

=head1 SYNOPSIS

  my $ok = calculate_function($fname, \@operand, \$errortext, \%typelookup, \%sheetdata);

=head1 DESCRIPTION

This provides all the spreadsheet functions (SUM, MAX, IRR, ISNULL,
etc). 

=cut

use strict;

use Spreadsheet::Engine::Sheet;    # bah!
use Time::Local;                   # For timegm in NOW and TODAY
use Encode;

use base 'Exporter';
our @EXPORT = qw(calculate_function);

#0 = no arguments
#>0 = exactly that many arguments
#<0 = that many arguments (abs value) or more

our %function_list = (
  AND       => [ \&and_or_function,         -1 ],
  CHOOSE    => [ \&choose_function,         -2 ],
  COLUMNS   => [ \&columns_rows_function,   1 ],
  COUNTIF   => [ \&countif_sumif_functions, 2 ],
  DAVERAGE  => [ \&dseries_functions,       3 ],
  DCOUNT    => [ \&dseries_functions,       3 ],
  DCOUNTA   => [ \&dseries_functions,       3 ],
  DGET      => [ \&dseries_functions,       3 ],
  DMAX      => [ \&dseries_functions,       3 ],
  DMIN      => [ \&dseries_functions,       3 ],
  DPRODUCT  => [ \&dseries_functions,       3 ],
  DSTDEV    => [ \&dseries_functions,       3 ],
  DSTDEVP   => [ \&dseries_functions,       3 ],
  DSUM      => [ \&dseries_functions,       3 ],
  DVAR      => [ \&dseries_functions,       3 ],
  DVARP     => [ \&dseries_functions,       3 ],
  EXACT     => [ \&exact_function,          2 ],
  HLOOKUP   => [ \&lookup_functions,        -3 ],
  IF        => [ \&if_function,             3 ],
  INDEX     => [ \&index_function,          -1 ],
  IRR       => [ \&irr_function,            -1 ],
  LOG       => [ \&log_function,            -1 ],
  MATCH     => [ \&lookup_functions,        -2 ],
  NOT       => [ \&not_function,            1 ],
  NOW       => [ \&zeroarg_functions,       0 ],
  OR        => [ \&and_or_function,         -1 ],
  ROUND     => [ \&round_function,          -1 ],
  ROWS      => [ \&columns_rows_function,   1 ],
  SUMIF     => [ \&countif_sumif_functions, -2 ],
  TODAY     => [ \&zeroarg_functions,       0 ],
  VLOOKUP   => [ \&lookup_functions,        -3 ],
  HTML      => [ \&html_function,           -1 ],
  PLAINTEXT => [ \&text_function,           -1 ],
);

=head1 EXTENDING

=head2 register

  Spreadsheet::Engine->register(SUM => 'Spreadsheet::Engine::Function::SUM');

If you wish to make a new function available you should register it
here. A series of base classes are provided that do all the argument
checking etc., allowing you to concentrate on the calculations. Have a
look at how the existing functions are implemented for details (it
should hopefully be mostly self-explanatory!)

information on how many arguments should be passed:

=cut

my $_reg = {};

sub register {
  my ($class, %to_reg) = @_;
  while (my ($name, $where) = each %to_reg) {
    eval "use $where";
    die $@ if $@;
    $_reg->{$name} = $where;
  }
}

__PACKAGE__->register(
  map +($_ => "Spreadsheet::Engine::Function::$_"),
  qw/ ABS ACOS ASIN ATAN ATAN2 AVERAGE COS COUNT COUNTA COUNTBLANK DATE
    DAY DDB DEGREES ERRCELL EVEN EXP FACT FALSE FIND FV HOUR INT ISBLANK
    ISERR ISERROR ISLOGICAL ISNA ISNONTEXT ISNUMBER ISTEXT LEFT LEN LN
    LOG10 LOWER MAX MID MIN MINUTE MOD MONTH N NA NPER NPV ODD PI PMT
    POWER PRODUCT PROPER PV RADIANS RATE REPLACE REPT RIGHT SECOND SIN SLN
    SQRT STDEV STDEVP SUBSTITUTE SUM SYD T TAN TIME TRIM TRUE TRUNC UPPER
    VALUE VAR VARP WEEKDAY YEAR /
);

=head1 EXPORTS

=head2 calculate_function

  my $ok = calculate_function($fname, \@operand, \$errortext, \%typelookup, \%sheetdata);

=cut

sub calculate_function {

  my ($fname, $operand, $errortext, $typelookup, $sheetdata) = @_;

  # has the function been registered? (new style)
  if (my $fclass = $_reg->{$fname}) {
    my $fn = $fclass->new(
      fname      => $fname,
      operand    => $operand,
      errortext  => $errortext,
      typelookup => $typelookup,
      sheetdata  => $sheetdata,
    );
    $fn->execute;
    return 1;
  }

  # Otherwise is it in our function_list (old style)
  my ($function_sub, $want_args) = @{ $function_list{$fname} }[ 0, 1 ];

  if ($function_sub) {
    copy_function_args($operand, \my @foperand);

    my $have_args = scalar @foperand;

    if ( ($want_args < 0 and $have_args < -$want_args)
      or ($want_args >= 0 and $have_args != $want_args)) {
      function_args_error($fname, $operand, $errortext);
      return 0;
    }

    $function_sub->(
      $fname, $operand, \@foperand, $errortext, $typelookup, $sheetdata
    );
  } else {
    my $ttext = $fname;
    if (@$operand && $operand->[ @$operand - 1 ]->{type} eq "start")
    {    # no arguments - name or zero arg function
      pop @$operand;
      push @$operand, { type => "name", value => $ttext };
    } else {
      $$errortext = "Unknown function $ttext. ";
    }
  }
  return 1;
}

=head1 FUNCTION providers

=head2 series_functions

=over

=item AVERAGE(v1,c1:c2,...) - See <Spreadsheet::Engine::Function::AVERAGE>

=item COUNT(v1,c1:c2,...) - See <Spreadsheet::Engine::Function::COUNT>

=item COUNTA(v1,c1:c2,...) - See <Spreadsheet::Engine::Function::COUNTA>

=item COUNTBLANK(v1,c1:c2,...) - See <Spreadsheet::Engine::Function::COUNTBLANK>

=item MAX(v1,c1:c2,...) - See L<Spreadsheet::Engine::Function::MAX>

=item MIN(v1,c1:c2,...) - See L<Spreadsheet::Engine::Function::MIN>

=item PRODUCT(v1,c1:c2,...) - See L<Spreadsheet::Engine::Function::PRODUCT>

=item STDEV(v1,c1:c2,...) - See L<Spreadsheet::Engine::Function::STDEV>

=item STDEVP(v1,c1:c2,...) - See L<Spreadsheet::Engine::Function::STDEVP>

=item SUM(v1,c1:c2,...) - See L<Spreadsheet::Engine::Function::SUM>

=item VAR(v1,c1:c2,...) - See L<Spreadsheet::Engine::Function::VAR>

=item VARP(v1,c1:c2,...) - See L<Spreadsheet::Engine::Function::VARP>

=back


=head2 dseries_functions

=over 

=item DAVERAGE(databaserange, fieldname, criteriarange)

=item DCOUNT(databaserange, fieldname, criteriarange)

=item DCOUNTA(databaserange, fieldname, criteriarange)

=item DGET(databaserange, fieldname, criteriarange)

=item DMAX(databaserange, fieldname, criteriarange)

=item DMIN(databaserange, fieldname, criteriarange)

=item DPRODUCT(databaserange, fieldname, criteriarange)

=item DSTDEV(databaserange, fieldname, criteriarange)

=item DSTDEVP(databaserange, fieldname, criteriarange)

=item DSUM(databaserange, fieldname, criteriarange)

=item DVAR(databaserange, fieldname, criteriarange)

=item DVARP(databaserange, fieldname, criteriarange)

=back

=cut

# Calculate all of these and then return the desired one (overhead is in accessing not calculating)
# If this routine is changed, check the series_functions, too.

sub dseries_functions {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my ($value1, $tostype, $cr);

  my $sum           = 0;
  my $resulttypesum = "";
  my $count         = 0;
  my $counta        = 0;
  my $countblank    = 0;
  my $product       = 1;
  my $maxval;
  my $minval;
  my ($mk, $sk, $mk1, $sk1); # For variance, etc.: M sub k, k-1, and S sub k-1
       # as per Knuth "The Art of Computer Programming" Vol. 2 3rd edition, page 232

  my ($dbrange, $dbrangetype) =
    top_of_stack_value_and_type($sheetdata, $foperand, $errortext);
  my $fieldtype;
  my $fieldname =
    operand_value_and_type($sheetdata, $foperand, $errortext, \$fieldtype);
  my ($criteriarange, $criteriarangetype) =
    top_of_stack_value_and_type($sheetdata, $foperand, $errortext);

  if ($dbrangetype ne "range" || $criteriarangetype ne "range") {
    function_args_error($fname, $operand, $errortext);
    return 0;
  }

  my ($dbsheetdata, $dbcol1num, $ndbcols, $dbrow1num, $ndbrows) =
    decode_range_parts($sheetdata, $dbrange, $dbrangetype);
  my (
    $criteriasheetdata, $criteriacol1num, $ncriteriacols,
    $criteriarow1num,   $ncriteriarows
    )
    = decode_range_parts($sheetdata, $criteriarange, $criteriarangetype);

  my $fieldasnum =
    field_to_colnum($dbsheetdata, $dbcol1num, $ndbcols, $dbrow1num,
    $fieldname, $fieldtype);
  $fieldasnum = int($fieldasnum);
  if ($fieldasnum <= 0) {
    push @$operand, { type => "e#VALUE!", value => 0 };
    return;
  }

  my $targetcol = $dbcol1num + $fieldasnum - 1;

  my (@criteriafieldnums, $criteriafieldname, $criteriafieldtype,
    $criterianum);

  for (my $i = 0 ; $i < $ncriteriacols ; $i++) {  # get criteria field colnums
    my $criteriacr = cr_to_coord($criteriacol1num + $i, $criteriarow1num);
    $criteriafieldname = $criteriasheetdata->{datavalues}->{$criteriacr};
    $criteriafieldtype = $criteriasheetdata->{valuetypes}->{$criteriacr};
    $criterianum       =
      field_to_colnum($dbsheetdata, $dbcol1num, $ndbcols, $dbrow1num,
      $criteriafieldname, $criteriafieldtype);
    $criterianum = int($criterianum);
    if ($criterianum <= 0) {
      push @$operand, { type => "e#VALUE!", value => 0 };
      return;
    }
    push @criteriafieldnums, $dbcol1num + $criterianum - 1;
  }

  my ($testok, $criteria, $testcol, $testcr);

  for (my $i = 1 ; $i < $ndbrows ; $i++)
  {    # go through each row of the database
    $testok = 0;
    CRITERIAROW:
    for (my $j = 1 ; $j < $ncriteriarows ; $j++)
    {    # go through each criteria row
      for (my $k = 0 ; $k < $ncriteriacols ; $k++) {    # look at each column
        my $criteriacr =
          cr_to_coord($criteriacol1num + $k, $criteriarow1num + $j)
          ;                                             # where criteria is
        $criteria = $criteriasheetdata->{datavalues}->{$criteriacr};
        next unless $criteria;                          # blank items are OK
        $testcol =
          $criteriasheetdata->{datavalues}
          ->{ cr_to_coord($criteriacol1num + $k, $criteriarow1num) };
        $testcol = $criteriafieldnums[$k];
        $testcr = cr_to_coord($testcol, $dbrow1num + $i);    # cell to check
        next CRITERIAROW
          unless test_criteria($criteriasheetdata->{datavalues}->{$testcr},
          ($criteriasheetdata->{valuetypes}->{$testcr} || "b"), $criteria);
      }
      $testok = 1;
      last CRITERIAROW;
    }
    next unless $testok;

    $cr =
      cr_to_coord($targetcol, $dbrow1num + $i)
      ;    # get cell of this row to do the function on
    $value1  = $dbsheetdata->{datavalues}->{$cr};
    $tostype = $dbsheetdata->{valuetypes}->{$cr};
    $tostype ||= "b";
    if ($tostype eq "b") {    # blank
      $value1 = 0;
    }

    $count += 1 if substr($tostype, 0, 1) eq "n";
    $counta += 1 if substr($tostype, 0, 1) ne "b";
    $countblank += 1 if substr($tostype, 0, 1) eq "b";

    if (substr($tostype, 0, 1) eq "n") {
      $sum += $value1;
      $product *= $value1;
      $maxval =
        (defined $maxval) ? ($value1 > $maxval ? $value1 : $maxval) : $value1;
      $minval =
        (defined $minval) ? ($value1 < $minval ? $value1 : $minval) : $value1;
      if ($count eq 1)
      { # initialize with with first values for variance used in STDEV, VAR, etc.
        $mk1 = $value1;
        $sk1 = 0;
      } else {    # Accumulate S sub 1 through n as per Knuth noted above
        $mk = $mk1 + ($value1 - $mk1) / $count;
        $sk = $sk1 + ($value1 - $mk1) * ($value1 - $mk);
        $sk1 = $sk;
        $mk1 = $mk;
      }
      $resulttypesum =
        lookup_result_type($tostype, $resulttypesum || $tostype,
        $typelookup->{plus});
    } elsif (substr($tostype, 0, 1) eq "e"
      && substr($resulttypesum, 0, 1) ne "e") {
      $resulttypesum = $tostype;
    }
  }

  $resulttypesum ||= "n";

  if ($fname eq "DSUM") {
    push @$operand, { type => $resulttypesum, value => $sum };
  } elsif ($fname eq "DPRODUCT")
  {    # may handle cases with text differently than some other spreadsheets
    push @$operand, { type => $resulttypesum, value => $product };
  } elsif ($fname eq "DMIN") {
    push @$operand, { type => $resulttypesum, value => ($minval || 0) };
  } elsif ($fname eq "DMAX") {
    push @$operand, { type => $resulttypesum, value => ($maxval || 0) };
  } elsif ($fname eq "DCOUNT") {
    push @$operand, { type => "n", value => $count };
  } elsif ($fname eq "DCOUNTA") {
    push @$operand, { type => "n", value => $counta };
  } elsif ($fname eq "DAVERAGE") {
    if ($count > 0) {
      push @$operand, { type => $resulttypesum, value => ($sum / $count) };
    } else {
      push @$operand, { type => "e#DIV/0!", value => 0 };
    }
  } elsif ($fname eq "DSTDEV") {
    if ($count > 1) {
      push @$operand,
        { type => $resulttypesum, value => (sqrt($sk / ($count - 1))) };
    } else {
      push @$operand, { type => "e#DIV/0!", value => 0 };
    }
  } elsif ($fname eq "DSTDEVP") {
    if ($count > 1) {
      push @$operand,
        { type => $resulttypesum, value => (sqrt($sk / $count)) };
    } else {
      push @$operand, { type => "e#DIV/0!", value => 0 };
    }
  } elsif ($fname eq "DVAR") {
    if ($count > 1) {
      push @$operand,
        { type => $resulttypesum, value => ($sk / ($count - 1)) };
    } else {
      push @$operand, { type => "e#DIV/0!", value => 0 };
    }
  } elsif ($fname eq "DVARP") {
    if ($count > 1) {
      push @$operand, { type => $resulttypesum, value => ($sk / $count) };
    } else {
      push @$operand, { type => "e#DIV/0!", value => 0 };
    }
  } elsif ($fname eq "DGET") {
    if ($count == 1) {
      push @$operand, { type => $resulttypesum, value => $sum };
    } elsif ($count == 0) {
      push @$operand, { type => "e#VALUE!", value => 0 };
    } else {
      push @$operand, { type => "e#NUM!", value => 0 };
    }
  }

  return;
}

=head2 lookup_functions

=over

=item HLOOKUP(value, range, row, [rangelookup])

=item VLOOKUP(value, range, col, [rangelookup])

=item MATCH(value, range, [rangelookup])

=back

=cut

sub lookup_functions {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my ($value, $value8, $tostype, $cr);

  my $lookuptype;
  my $lookupvalue =
    operand_value_and_type($sheetdata, $foperand, $errortext, \$lookuptype);
  my $lookupvalue8 = lc(decode('utf8', $lookupvalue));

  my ($range, $rangetype) =
    top_of_stack_value_and_type($sheetdata, $foperand, $errortext);
  my ($offsetvalue, $offsettype);
  my $rangelookup = 1;    # default to true or 1
  if ($fname eq "MATCH") {
    if (scalar @$foperand) {
      $rangelookup =
        operand_as_number($sheetdata, $foperand, $errortext, \$tostype);
      if (substr($tostype, 0, 1) ne "n") {
        push @$operand, { type => "e#VALUE!", value => 0 };
        return;
      }
      if (scalar @$foperand) {
        function_args_error($fname, $operand, $errortext);
        return 0;
      }
    }
  } else {
    $offsetvalue =
      int(operand_as_number($sheetdata, $foperand, $errortext, \$offsettype));
    if (scalar @$foperand) {
      $rangelookup =
        operand_as_number($sheetdata, $foperand, $errortext, \$tostype);
      if (substr($tostype, 0, 1) ne "n") {
        push @$operand, { type => "e#VALUE!", value => 0 };
        return;
      }
      if (scalar @$foperand) {
        function_args_error($fname, $operand, $errortext);
        return 0;
      }
      $rangelookup = $rangelookup ? 1 : 0;    # convert to 1 or 0
    }
  }
  $lookuptype = substr($lookuptype, 0, 1);    # only deal with general type

  if ($rangetype ne "range") {
    function_args_error($fname, $operand, $errortext);
    return 0;
  }
  my ($rangesheetdata, $rangecol1num, $nrangecols, $rangerow1num, $nrangerows)
    = decode_range_parts($sheetdata, $range, $rangetype);

  my $c     = 0;
  my $r     = 0;
  my $cincr = 0;
  my $rincr = 0;
  if ($fname eq "HLOOKUP") {
    $cincr = 1;
    if ($offsetvalue > $nrangerows) {
      push @$operand, { type => "e#REF!", value => 0 };
      return;
    }
  } elsif ($fname eq "VLOOKUP") {
    $rincr = 1;
    if ($offsetvalue > $nrangecols) {
      push @$operand, { type => "e#REF!", value => 0 };
      return;
    }
  } elsif ($fname eq "MATCH") {
    if ($nrangecols > 1) {
      if ($nrangerows > 1) {
        push @$operand, { type => "e#N/A", value => 0 };
        return;
      }
      $cincr = 1;
    } else {
      $rincr = 1;
    }
  } else {
    function_args_error($fname, $operand, $errortext);
    return 0;
  }

  # Added defined test here. 31/12/07 TODO give it a sensible default.
  if (defined $offsetvalue && $offsetvalue < 1 && $fname ne "MATCH") {
    push @$operand, { type => "e#VALUE!", value => 0 };
    return 0;
  }

  my $previousOK = 0;  # if 1, previous test was <. If 2, also this one wasn't
  my ($csave, $rsave); # col and row of last OK

  while (1) {
    $cr      = cr_to_coord($rangecol1num + $c, $rangerow1num + $r);
    $value   = $rangesheetdata->{datavalues}->{$cr};
    $tostype = $rangesheetdata->{valuetypes}->{$cr};
    $tostype = substr($tostype, 0, 1);    # only deal with general types
    $tostype ||= "b";
    if ($rangelookup) {    # look for within brackets for matches
      if ($lookuptype eq "n" && $tostype eq "n") {
        last if ($lookupvalue == $value);    # match
        if ( ($rangelookup > 0 && $lookupvalue > $value)
          || ($rangelookup < 0 && $lookupvalue < $value))
        {                                    # possible match: wait and see
          $previousOK = 1;
          $csave      = $c;
          $rsave      = $r;
        } elsif ($previousOK) {              # last one was OK, this one isn't
          $previousOK = 2;
          last;
        }
      } elsif ($lookuptype eq "t" && $tostype eq "t") {
        $value8 = decode('utf8', $value);
        $value8 = lc $value8;
        last if ($lookupvalue8 eq $value8);    # match
        if ( ($rangelookup > 0 && $lookupvalue gt $value)
          || ($rangelookup < 0 && $lookupvalue lt $value))
        {                                      # possible match: wait and see
          $previousOK = 1;
          $csave      = $c;
          $rsave      = $r;
        } elsif ($previousOK) {    # last one was OK, this one isn't
          $previousOK = 2;
          last;
        }
      }
    } else {    # exact value matches
      if ($lookuptype eq "n" && $tostype eq "n") {
        last if ($lookupvalue == $value);    # match
      } elsif ($lookuptype eq "t" && $tostype eq "t") {
        $value8 = decode('utf8', $value);
        $value8 = lc $value8;
        last if ($lookupvalue8 eq $value8);    # match
      }
    }
    $r += $rincr;
    $c += $cincr;
    if ($r >= $nrangerows || $c >= $nrangecols)
    {    # end of range to check, no exact match
      if ($previousOK) {    # at least one could have been OK
        $previousOK = 2;
        last;
      }
      push @$operand, { type => "e#N/A", value => 0 };
      return;
    }
  }

  if ($previousOK == 2) {    # back to last OK
    $r = $rsave;
    $c = $csave;
  }

  if ($fname eq "MATCH") {
    $value   = $c + $r + 1;    # only one may be <> 0
    $tostype = "n";
  } else {
    $cr = cr_to_coord(
      $rangecol1num + $c + ($fname eq "VLOOKUP" ? $offsetvalue - 1 : 0),
      $rangerow1num + $r + ($fname eq "HLOOKUP" ? $offsetvalue - 1 : 0)
    );
    $value   = $rangesheetdata->{datavalues}->{$cr};
    $tostype = $rangesheetdata->{valuetypes}->{$cr};
  }
  push @$operand, { type => $tostype, value => $value };
  return;

}

=head2 index_function

=over

=item INDEX(range, rownum, colnum)

=back

=cut

sub index_function {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my ($range, $rangetype) =
    top_of_stack_value_and_type($sheetdata, $foperand, $errortext)
    ;    # get range
  if ($rangetype ne "range") {
    function_args_error($fname, $operand, $errortext);
    return 0;
  }
  my ($indexsheetdata, $col1num, $ncols, $row1num, $nrows) =
    decode_range_parts($sheetdata, $range, $rangetype);

  my $rowindex = 0;
  my $colindex = 0;
  my $tostype;

  if (scalar @$foperand) {    # look for row number
    $rowindex =
      operand_as_number($sheetdata, $foperand, $errortext, \$tostype);
    if (substr($tostype, 0, 1) ne "n" || $rowindex < 0) {
      push @$operand, { type => "e#VALUE!", value => 0 };
      return;
    }
    if (scalar @$foperand) {    # look for col number
      $colindex =
        operand_as_number($sheetdata, $foperand, $errortext, \$tostype);
      if (substr($tostype, 0, 1) ne "n" || $colindex < 0) {
        push @$operand, { type => "e#VALUE!", value => 0 };
        return;
      }
      if (scalar @$foperand) {
        function_args_error($fname, $operand, $errortext);
        return 0;
      }
    } else {                    # col number missing
      if ($nrows == 1) {   # if only one row, then rowindex is really colindex
        $colindex = $rowindex;
        $rowindex = 0;
      }
    }
  }

  if ($rowindex > $nrows || $colindex > $ncols) {
    push @$operand, { type => "e#REF!", value => 0 };
    return;
  }

  my ($result, $resulttype);

  if ($rowindex == 0) {
    if ($colindex == 0) {
      if ($nrows == 1 && $ncols == 1) {
        $result = cr_to_coord($col1num, $row1num);
        $resulttype = "coord";
      } else {
        $result =
          cr_to_coord($col1num, $row1num) . "|"
          . cr_to_coord($col1num + $ncols - 1, $row1num + $nrows - 1) . "|";
        $resulttype = "range";
      }
    } else {
      if ($nrows == 1) {
        $result = cr_to_coord($col1num + $colindex - 1, $row1num);
        $resulttype = "coord";
      } else {
        $result =
          cr_to_coord($col1num + $colindex - 1, $row1num) . "|"
          . cr_to_coord($col1num + $colindex - 1, $row1num + $nrows - 1)
          . "|";
        $resulttype = "range";
      }
    }
  } else {
    if ($colindex == 0) {
      if ($ncols == 1) {
        $result = cr_to_coord($col1num, $row1num + $rowindex - 1);
        $resulttype = "coord";
      } else {
        $result =
          cr_to_coord($col1num, $row1num + $rowindex - 1) . "|"
          . cr_to_coord($col1num + $ncols - 1, $row1num + $rowindex - 1)
          . "|";
        $resulttype = "range";
      }
    } else {
      $result =
        cr_to_coord($col1num + $colindex - 1, $row1num + $rowindex - 1);
      $resulttype = "coord";
    }
  }

  push @$operand, { type => $resulttype, value => $result };
  return;

}

=head2 countif_sumif_functions

=over

=item COUNTIF(c1:c2,"criteria")

=item SUMIF(c1:c2,"criteria")

=back

=cut

sub countif_sumif_functions {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my ($tostype, $tostype2, $sumrangevalue, $sumrangetype);

  my ($rangevalue, $rangetype) =
    top_of_stack_value_and_type($sheetdata, $foperand, $errortext)
    ;    # get range or coord
  my ($criteriavalue, $criteriatype) =
    operand_as_text($sheetdata, $foperand, $errortext, \$tostype)
    ;    # get criteria
  if ($fname eq "SUMIF") {
    if ((scalar @$foperand) == 1) {    # three arg form of SUMIF
      ($sumrangevalue, $sumrangetype) =
        top_of_stack_value_and_type($sheetdata, $foperand, $errortext);
    } elsif ((scalar @$foperand) == 0) {    # two arg form
      $sumrangevalue = $rangevalue;
      $sumrangetype  = $rangetype;
    } else {
      function_args_error($fname, $operand, $errortext);
      return 0;
    }
  } else {
    $sumrangevalue = $rangevalue;
    $sumrangetype  = $rangetype;
  }

  my $ct = substr($criteriatype || '', 0, 1) || '';
  if ($ct eq "n") {
    $criteriavalue = "$criteriavalue";
  } elsif ($ct eq "e") {    # error
    undef $criteriavalue;
  } elsif ($ct eq "b") {    # blank here is undefined
    undef $criteriavalue;
  }

  if ($rangetype ne "coord" && $rangetype ne "range") {
    function_args_error($fname, $operand, $errortext);
    return 0;
  }

  if ( $fname eq "SUMIF"
    && $sumrangetype ne "coord"
    && $sumrangetype ne "range") {
    function_args_error($fname, $operand, $errortext);
    return 0;
  }

  push @$foperand, { type => $rangetype, value => $rangevalue };
  my @f2operand;    # to allow for 3 arg form
  push @f2operand, { type => $sumrangetype, value => $sumrangevalue };

  my $sum           = 0;
  my $resulttypesum = "";
  my $count         = 0;

  while (@$foperand) {
    my $value1 =
      operand_value_and_type($sheetdata, $foperand, $errortext, \$tostype);
    my $value2 =
      operand_value_and_type($sheetdata, \@f2operand, $errortext, \$tostype2);

    next unless test_criteria($value1, $tostype, $criteriavalue);

    $count += 1;

    if (substr($tostype2, 0, 1) eq "n") {
      $sum += $value2;
      $resulttypesum =
        lookup_result_type($tostype2, $resulttypesum || $tostype2,
        $typelookup->{plus});
    } elsif (substr($tostype2, 0, 1) eq "e"
      && substr($resulttypesum, 0, 1) ne "e") {
      $resulttypesum = $tostype2;
    }
  }

  $resulttypesum ||= "n";

  if ($fname eq "SUMIF") {
    push @$operand, { type => $resulttypesum, value => $sum };
  } elsif ($fname eq "COUNTIF") {
    push @$operand, { type => "n", value => $count };
  }

  return;

}

=head2 if_function

=over

=item IF(cond,truevalue,falsevalue)

=back

=cut

sub if_function {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my $tostype;

  my $cond =
    operand_value_and_type($sheetdata, $foperand, $errortext, \$tostype);
  if (substr($tostype, 0, 1) ne "n" && substr($tostype, 0, 1) ne "b") {
    push @$operand, { type => "e#VALUE!", value => 0 };
    return;
  }

  pop @$foperand if !$cond;
  push @$operand, $foperand->[ @$foperand - 1 ];
  pop @$foperand if $cond;

  return;

}

=head2 exact_function

=over

=item EXACT(v1,v2)

=back

=cut

sub exact_function {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my ($tostype, $tostype2);

  my $value1 =
    operand_value_and_type($sheetdata, $foperand, $errortext, \$tostype);
  my $value2 =
    operand_value_and_type($sheetdata, $foperand, $errortext, \$tostype2);

  my $result     = 0;
  my $resulttype = "nl";

  if (substr($tostype, 0, 1) eq "t") {
    if (substr($tostype2, 0, 1) eq "t") {
      $result = $value1 eq $value2 ? 1 : 0;
    } elsif (substr($tostype2, 0, 1) eq "b") {
      $result = len($value1) ? 0 : 1;
    } elsif (substr($tostype2, 0, 1) eq "n") {
      $result = $value1 eq "$value2" ? 1 : 0;
    } elsif (substr($tostype2, 0, 1) eq "e") {
      $result     = $value2;
      $resulttype = $tostype2;
    } else {
      $result = 0;
    }
  } elsif (substr($tostype, 0, 1) eq "n") {
    if (substr($tostype2, 0, 1) eq "n") {
      $result = $value1 == $value2 ? 1 : 0;
    } elsif (substr($tostype2, 0, 1) eq "b") {
      $result = 0;
    } elsif (substr($tostype2, 0, 1) eq "t") {
      $result = "$value1" eq $value2 ? 1 : 0;
    } elsif (substr($tostype2, 0, 1) eq "e") {
      $result     = $value2;
      $resulttype = $tostype2;
    } else {
      $result = 0;
    }
  } elsif (substr($tostype, 0, 1) eq "b") {
    if (substr($tostype2, 0, 1) eq "t") {
      $result = len($value2) ? 0 : 1;
    } elsif (substr($tostype2, 0, 1) eq "b") {
      $result = 1;
    } elsif (substr($tostype2, 0, 1) eq "n") {
      $result = 0;
    } elsif (substr($tostype2, 0, 1) eq "e") {
      $result     = $value2;
      $resulttype = $tostype2;
    } else {
      $result = 0;
    }
  } elsif (substr($tostype, 0, 1) eq "e") {
    $result     = $value1;
    $resulttype = $tostype;
  }

  push @$operand, { type => $resulttype, value => $result };

  return;

}

=head2 log_function

=over

=item LOG(value,[base])

=back

=cut

sub log_function {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my ($tostype, $tostype2, $value2);
  my $result = 0;

  my $value = operand_as_number($sheetdata, $foperand, $errortext, \$tostype);
  my $resulttype =
    lookup_result_type($tostype, $tostype, $typelookup->{oneargnumeric});
  if ((scalar @$foperand) == 1) {
    $value2 =
      operand_as_number($sheetdata, $foperand, $errortext, \$tostype2);
    if (substr($tostype2, 0, 1) ne "n" || $value2 <= 0) {
      function_specific_error($fname, $operand, $errortext, "e#NUM!",
        "LOG second argument must be numeric greater than 0");
      return 0;
    }
  } elsif ((scalar @$foperand) != 0) {
    function_args_error($fname, $operand, $errortext);
    return 0;
  } else {
    $value2 = exp(1);
  }

  if ($resulttype eq "n") {
    if ($value <= 0) {
      function_specific_error($fname, $operand, $errortext, "e#NUM!",
        "LOG first argument must be greater than 0");
      return 0;
    }
    $result = log($value) / log($value2);
  }

  push @$operand, { type => $resulttype, value => $result };

  return;

}

=head2 round_function

=over

=item ROUND(value,[precision])

=back

=cut

sub round_function {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my ($tostype, $tostype2, $value2);
  my $result = 0;

  my $value = operand_as_number($sheetdata, $foperand, $errortext, \$tostype);
  my $resulttype =
    lookup_result_type($tostype, $tostype, $typelookup->{oneargnumeric});
  if ((scalar @$foperand) == 1) {
    $value2 =
      operand_as_number($sheetdata, $foperand, $errortext, \$tostype2);
    if (substr($tostype2, 0, 1) ne "n") {
      function_specific_error($fname, $operand, $errortext, "e#NUM!",
        "ROUND second argument must be numeric");
      return 0;
    }
  } elsif ((scalar @$foperand) != 0) {
    function_args_error($fname, $operand, $errortext);
    return 0;
  } else {
    $value2 = 0;    # if no second arg, assume 0 for simple round
  }

  if ($resulttype eq "n") {
    if ($value2 == 0) {
      $result = int($value + ($value >= 0 ? 0.5 : -0.5));
    } elsif ($value2 > 0) {
      my $decimalscale = 1;    # cut down to required number of decimal digits
      $value2 = int($value2);
      for (my $i = 0 ; $i < $value2 ; $i++) {
        $decimalscale *= 10;
      }
      my $scaledvalue =
        int($value * $decimalscale + ($value >= 0 ? 0.5 : -0.5));
      $result = $scaledvalue / $decimalscale;
    } elsif ($value2 < 0) {
      my $decimalscale = 1;    # cut down to required number of decimal digits
      $value2 = int(-$value2);
      for (my $i = 0 ; $i < $value2 ; $i++) {
        $decimalscale *= 10;
      }
      my $scaledvalue =
        int($value / $decimalscale + ($value >= 0 ? 0.5 : -0.5));
      $result = $scaledvalue * $decimalscale;
    }
  }

  push @$operand, { type => $resulttype, value => $result };

  return;

}

=head2 and_or_function

=over

=item AND(v1,c1:c2,...)

=item OR(v1,c1:c2,...)

=back

=cut

sub and_or_function {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my ($value1, $tostype, $resulttype);

  my $result;
  if ($fname eq "AND") {
    $result = 1;
  } elsif ($fname eq "OR") {
    $result = 0;
  }
  $resulttype = "";
  while (@$foperand) {
    $value1 =
      operand_value_and_type($sheetdata, $foperand, $errortext, \$tostype);
    if (substr($tostype, 0, 1) eq "n") {
      if ($fname eq "AND") {
        $result = $value1 != 0 ? $result : 0;
      } elsif ($fname eq "OR") {
        $result = $value1 != 0 ? 1 : $result;
      }
      $resulttype = lookup_result_type(
        $tostype,
        $resulttype || "nl",
        $typelookup->{propagateerror}
      );
    } elsif (substr($tostype, 0, 1) eq "e"
      && substr($resulttype, 0, 1) ne "e") {
      $resulttype = $tostype;
    }
  }
  if (length($resulttype) < 1) {
    $resulttype = "e#VALUE!";
    $result     = 0;
  }
  push @$operand, { type => $resulttype, value => $result };

  return;

}

=head2 not_function

=over

=item NOT(value)

=back

=cut

sub not_function {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my $tostype;
  my $result = 0;

  my $value =
    operand_value_and_type($sheetdata, $foperand, $errortext, \$tostype);
  my $resulttype =
    lookup_result_type($tostype, $tostype, $typelookup->{oneargnumeric});

  if (substr($resulttype, 0, 1) eq "n") {
    $result = $value != 0 ? 0 : 1;    # do the "not" operation
    $resulttype = "nl";
  }

  push @$operand, { type => $resulttype, value => $result };

  return;

}

=head2 choose_function

=over

=item CHOOSE(index,value1,value2,...)

=back

=cut

sub choose_function {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my ($value1, $tostype, $resultvalue, $resulttype);

  my $cindex =
    operand_as_number($sheetdata, $foperand, $errortext, \$tostype);
  $cindex = 0 if substr($tostype, 0, 1) ne "n";
  $cindex = int($cindex);

  my $count = 0;
  while (@$foperand) {
    ($value1, $tostype) =
      top_of_stack_value_and_type($sheetdata, $foperand, $errortext);
    $count += 1;
    if ($cindex == $count) {
      $resultvalue = $value1;
      $resulttype  = $tostype;
    }
  }
  if ($resulttype) {    # found something
    push @$operand, { type => $resulttype, value => $resultvalue };
  } else {
    push @$operand, { type => "e#VALUE!", value => 0 };
  }

  return;

}

=head2 columns_rows_function

=over

=item COLUMNS(c1:c2)

=item ROWS(c1:c2)

=back

=cut

sub columns_rows_function {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my ($value1, $tostype, $resultvalue, $resulttype);

  ($value1, $tostype) =
    top_of_stack_value_and_type($sheetdata, $foperand, $errortext);

  if ($tostype eq "coord") {
    $resultvalue = 1;
    $resulttype  = "n";
  } elsif ($tostype eq "range") {
    my ($v1, $v2, $sequence) = split (/\|/, $value1);
    my ($sheet1, $sheet2);
    ($v1, $sheet1) = split (/!/, $v1);
    ($v2, $sheet2) = split (/!/, $v2);
    my ($c1, $r1) = coord_to_cr($v1);
    my ($c2, $r2) = coord_to_cr($v2);
    ($c2, $c1) = ($c1, $c2) if ($c1 > $c2);
    ($r2, $r1) = ($r1, $r2) if ($r1 > $r2);

    if ($fname eq "COLUMNS") {
      $resultvalue = $c2 - $c1 + 1;
    } elsif ($fname eq "ROWS") {
      $resultvalue = $r2 - $r1 + 1;
    }
    $resulttype = "n";
  } else {
    $resultvalue = 0;
    $resulttype  = "e#VALUE!";
  }

  push @$operand, { type => $resulttype, value => $resultvalue };

  return;

}

=head2 zeroarg_functions

=over

=item NOW()

=item TODAY()

=back

=cut

sub zeroarg_functions {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my $result = 0;
  my $resulttype;

  if ($fname eq "NOW") {
    my $startval       = time();
    my $start_1_1_1970 =
      25569;    # Day number of 1/1/1970 starting with 1/1/1900 as 1
    my $seconds_in_a_day = 24 * 60 * 60;
    my @tmstr            = localtime($startval);
    my $time2            =
      timegm($tmstr[0], $tmstr[1], $tmstr[2], $tmstr[3], $tmstr[4],
      $tmstr[5]);
    my $offset = ($time2 - $startval) / (60 * 60);
    my $nowdays =
      $start_1_1_1970 + $startval / $seconds_in_a_day + $offset / 24;
    $nowdays    = $start_1_1_1970 + $time2 / $seconds_in_a_day;
    $resulttype = "ndt";
    $result     = $nowdays;
  } elsif ($fname eq "TODAY") {
    my $startval       = time();
    my $start_1_1_1970 =
      25569;    # Day number of 1/1/1970 starting with 1/1/1900 as 1
    my $seconds_in_a_day = 24 * 60 * 60;
    my @tmstr            = localtime($startval);
    my $time2            = timegm(0, 0, 0, $tmstr[3], $tmstr[4], $tmstr[5]);
    my $offset           = ($time2 - $startval) / (60 * 60);
    my $nowdays          =
      $start_1_1_1970 + $startval / $seconds_in_a_day + $offset / 24;
    $nowdays    = $start_1_1_1970 + $time2 / $seconds_in_a_day;
    $resulttype = "nd";
    $result     = $nowdays;
  }

  push @$operand, { type => $resulttype, value => $result };

  return;

}

#
# * * * * * FINANCIAL FUNCTIONS * * * * *
#

=head2 irr_function

=over

=item IRR(c1:c2,[guess])

=back

=cut

sub irr_function {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my ($value1, $tostype);

  my @rangeoperand;
  push @rangeoperand, pop @$foperand;    # first operand is a range

  my @cashflows;
  while (@rangeoperand)
  {    # get values from range so we can do iterative approximations
    $value1 =
      operand_value_and_type($sheetdata, \@rangeoperand, $errortext,
      \$tostype);
    if (substr($tostype, 0, 1) eq "n") {
      push @cashflows, $value1;
    } elsif (substr($tostype, 0, 1) eq "e") {
      push @$operand, { type => "e#VALUE!", value => 0 };
      return;
    }
  }

  my $guess = 0;

  if (@$foperand) {    # guess is provided
    $guess = operand_as_number($sheetdata, $foperand, $errortext, \$tostype);
    if (substr($tostype, 0, 1) ne "n" && substr($tostype, 0, 1) ne "b") {
      push @$operand, { type => "e#VALUE!", value => 0 };
      return;
    }
    if (@$foperand) {    # should be no more args
      function_args_error($fname, $operand, $errortext);
      return;
    }
  }

  $guess ||= 0.1;

  # rate is calculated by repeated approximations
  # The deltas are used to calculate new guesses

  my $oldsum;
  my $maxloop = 20;
  my $tries   = 0;
  my $epsilon = 0.0000001;    # this is close enough
  my $rate    = $guess;
  my $oldrate = 0;
  my $m;
  my $sum = 1;
  my $factor;

  while (($sum >= 0 ? $sum : -$sum) > $epsilon && ($rate != $oldrate)) {
    $sum    = 0;
    $factor = 1;
    for (my $i = 0 ; $i < @cashflows ; $i++) {
      $factor *= (1 + $rate);
      if ($factor == 0) {
        push @$operand, { type => "e#DIV/0!", value => 0 };
        return;
      }
      $sum += $cashflows[$i] / $factor;
    }

    if (defined $oldsum) {
      $m = ($sum - $oldsum) / ($rate - $oldrate);    # get slope
      $oldrate = $rate;
      $rate   = $rate - $sum / $m;                   # look for zero crossing
      $oldsum = $sum;
    } else {    # first time - no old values
      $oldrate = $rate;
      $rate    = 1.1 * $rate;
      $oldsum  = $sum;
    }
    $tries++;
    if ($tries >= $maxloop) {    # didn't converge yet
      push @$operand, { type => "e#NUM!", value => 0 };
      return;
    }
  }

  push @$operand, { type => 'n%', value => $rate };

  return;

}

=head2 text_function

=over

=item PLAINTEXT

=back

=cut

sub text_function {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my ($value1, $tostype, $resulttype);

  my $textstr = "";
  $resulttype = "";
  while (@$foperand) {
    $value1 = operand_as_text($sheetdata, $foperand, $errortext, \$tostype);
    if (substr($tostype, 0, 1) eq "t") {
      $textstr .= $value1;
      $resulttype = lookup_result_type($tostype, $resulttype || $tostype,
        $typelookup->{concat});
    } elsif (substr($tostype, 0, 1) eq "e"
      && substr($resulttype, 0, 1) ne "e") {
      $resulttype = $tostype;
    }
  }
  $resulttype = substr($resulttype, 0, 1) eq "t" ? "t" : $resulttype;
  push @$operand, { type => $resulttype, value => $textstr };

  return;

}

=head2 html_function

=over

=item HTML

=back

=cut

sub html_function {

  my ($fname, $operand, $foperand, $errortext, $typelookup, $sheetdata) = @_;

  my ($value1, $tostype, $resulttype);

  my $textstr = "";
  $resulttype = "";
  while (@$foperand) {
    $value1 = operand_as_text($sheetdata, $foperand, $errortext, \$tostype);
    if (substr($tostype, 0, 1) eq "t") {
      $textstr .= $value1;
      $resulttype = lookup_result_type($tostype, $resulttype || $tostype,
        $typelookup->{concat});
    } elsif (substr($tostype, 0, 1) eq "e"
      && substr($resulttype, 0, 1) ne "e") {
      $resulttype = $tostype;
    }
  }
  $resulttype = substr($resulttype, 0, 1) eq "t" ? "th" : $resulttype;
  push @$operand, { type => $resulttype, value => $textstr };

  return;

}

=head1 HELPERS

=head2 field_to_colnum

  $colnum = field_to_colnum(\@sheetdata, $col1num, $ncols, $row1num, $fieldname, $fieldtype)

If fieldname is a number, uses it, otherwise looks up string in cells in row to find field number

If not found, returns 0.

=cut

sub field_to_colnum {

  my ($sheetdata, $col1num, $ncols, $row1num, $fieldname, $fieldtype) = @_;

  if (substr($fieldtype, 0, 1) eq "n") {    # number - return it if legal
    if ($fieldname <= 0 || $fieldname > $ncols) {
      return 0;
    }
    return int($fieldname);
  }

  if (substr($fieldtype, 0, 1) ne "t") {    # must be text otherwise
    return 0;
  }

  $fieldname = decode('utf8', $fieldname);    # change UTF-8 bytes to chars
  $fieldname = lc $fieldname;

  my ($cr, $value);

  for (my $i = 0 ; $i < $ncols ; $i++)
  {    # look through column headers for a match
    $cr    = cr_to_coord($col1num + $i, $row1num);
    $value = $sheetdata->{datavalues}->{$cr};
    $value = decode('utf8', $value);
    $value = lc $value;                              #ignore case
    next if $value ne $fieldname;                    # no match
    return $i + 1;                                   # match
  }
  return 0;    # looked at all and no match
}

1;

__END__

=head1 HISTORY

This is a Modified Version of SocialCalc::Functions from SocialCalc 1.1.0

=head1 COPYRIGHT

Portions (c) Copyright 2005, 2006, 2007 Software Garden, Inc.
All Rights Reserved.

Portions (c) Copyright 2007 Socialtext, Inc.
All Rights Reserved.

Portions (c) Copyright 2007, 2008 Tony Bowden

=head1 LICENCE

The contents of this file are subject to the Artistic License 2.0;
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
  http://www.perlfoundation.org/artistic_license_2_0


