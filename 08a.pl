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

my $visible = 2 * (@grid + @{ $grid[0] }) - 4;
for my $y (1 .. $#grid - 1) {
  TREE:
    for my $x (1 .. $#{ $grid[$y] } - 1) {
        for my $direction ([0, 1], [0, -1], [1, 0], [-1, 0]) {
            my $is_visible = 1;
            my ($i, $j) = ($x, $y);
            my ($dx, $dy) = @$direction;
            while (   $i > 0
                   && $j > 0
                   && $j < $#grid
                   && $i < $#{ $grid[$y] }
            ) {
                $i += $dx;
                $j += $dy;
                $is_visible = 0 if $grid[$j][$i] >= $grid[$y][$x];
            }
            $visible += $is_visible;
            next TREE if $is_visible;
        }
    }
}
say $visible;

__DATA__
30373
25512
65332
33549
35390
