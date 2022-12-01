#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

local $/ = "";

my @max = (0) x 3;
while (<>) {
    my $sum = sum(split /\s+/);
    if ($sum >= $max[0]) {
        push @max, $sum;
        @max = sort { $a <=> $b } @max;
        shift @max;
    }
}

say sum(@max);


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
