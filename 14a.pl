#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @MOVES = ([0, 1], [-1, 1], [1, 1]);

my %grid;
my $max_y;
while (my $line = <>) {
    $line =~ s/([0-9]+),([0-9]+) -> //;
    my ($x0, $y0) = ($1, $2);
    $max_y //= $y0;
    while (length $line) {
        $line =~ s/([0-9]+),([0-9]+)(?:\n?$| -> )//;
        my ($x1, $y1) = my ($xx, $yy) = ($1, $2);
        if ($x0 == $x1) {
            ($y0, $y1) = ($y1, $y0) if $y1 < $y0;
            $grid{$x0}{$_} = '#' for $y0 .. $y1;
        } else {
            ($x0, $x1) = ($x1, $x0) if $x1 < $x0;
            $grid{$_}{$y0} = '#' for $x0 .. $x1;
        }
        $max_y = $y0 if $y0 > $max_y;
        ($x0, $y0) = ($xx, $yy);
    }
    $max_y = $y0 if $y0 > $max_y;
}
my ($xs, $ys) = (500, 0);

my $count = 0;
SAND:
while (1) {
    my ($x, $y) = ($xs, $ys);
  MOVE:
    while (1) {
        for my $move_index (0 .. 2) {
            my $move = $MOVES[$move_index];
            if (! $grid{$x + $move->[0]}{$y + $move->[1]} && $y <= $max_y) {
                $x += $move->[0];
                $y += $move->[1];
                next MOVE
            }
        }
        last MOVE
    }
    if ($y <= $max_y) {
        $grid{$x}{$y} = 'o';
        ++$count;
        next SAND
    } else {
        last SAND
    }
}
say $count;

__DATA__
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
