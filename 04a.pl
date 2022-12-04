#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $count = 0;
while (<>) {
    chomp;
    my @ranges = sort { $a->[0] <=> $b->[0] || $b->[1] <=> $a->[1] }
                 map [split /-/],
                 split /,/;
    ++$count if $ranges[1][1] <= $ranges[0][1];
}
say $count;


__DATA__
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
