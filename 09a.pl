#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %DIR = (R => [1, 0],
           L => [-1, 0],
           U => [0, -1],
           D => [0, 1]);

my ($hx, $hy, $tx, $ty) = (0) x 4;
my %grid;
$grid{0}{0} = 1;
my $count = 1;

while (<>) {
    my ($direction, $length) = split;
    for (1 .. $length) {
        $hx += $DIR{$direction}[0];
        $hy += $DIR{$direction}[1];

        my $dx = $hx - $tx;
        my $dy = $hy - $ty;

        next unless abs($dx) > 1 || abs($dy) > 1;

        $tx += $dx > 0 ? 1 : -1 if $dx;
        $ty += $dy > 0 ? 1 : -1 if $dy;
        ++$count unless $grid{$tx}{$ty};
        $grid{$tx}{$ty} = 1;
    }
}

say $count;

__DATA__
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
