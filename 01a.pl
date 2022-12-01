#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

local $/ = "";

my $max = 0;
while (<>) {
    my $sum = sum(split /\s+/);
    $max = $sum if $sum > $max;
}

say $max;

__DATA__
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
