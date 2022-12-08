#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @grid;
while (<>) {
    chomp;
    push @grid, [split //];
}

my $best = 0;
for my $y (0 .. $#grid) {
    for my $x (0 .. $#{ $grid[$y] }) {
        my @distances;
        for my $direction ([0, 1], [0, -1], [1, 0], [-1, 0]) {
            push @distances, 0;
            my ($i, $j) = ($x, $y);
            my ($dx, $dy) = @$direction;
            while (1) {
                $i += $dx;
                $j += $dy;
                last if $i < 0
                     || $j < 0
                     || $j > $#grid
                     || $i > $#{ $grid[$y] };

                ++$distances[-1];
                last if $grid[$j][$i] >= $grid[$y][$x];
            }
        }
        my $distance = $distances[0];
        $distance *= $_ for @distances[1, 2, 3];
        $best = $distance if $best < $distance;
    }
}
say $best;

__DATA__
30373
25512
65332
33549
35390
