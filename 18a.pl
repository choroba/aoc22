#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %grid;
while (<>) {
    chomp;
    $grid{$_} = 1;
}

my $count = 0;
for my $xyz (keys %grid) {
    my @coord = split /,/, $xyz;
    for my $pos (0, 1, 2) {
        for my $shift (-1, 1) {
            my @c = @coord;
            $c[$pos] += $shift;
            ++$count unless exists $grid{ join ',', @c };
        }
    }
}
say $count;

__DATA__
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
