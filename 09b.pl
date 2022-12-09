#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %DIR = (R => [1, 0],
           L => [-1, 0],
           U => [0, -1],
           D => [0, 1]);

my @rope = map [0, 0], 1 .. 10;
my %grid;
$grid{0}{0} = 1;
my $count = 1;

while (<>) {
    my ($direction, $length) = split;
    for (1 .. $length) {
        $rope[0][0] += $DIR{$direction}[0];
        $rope[0][1] += $DIR{$direction}[1];

        for my $tail (1 .. 9) {
            my ($hx, $hy, $tx, $ty)
                = (@{ $rope[ $tail - 1 ] }, @{ $rope[$tail] });
            my $dx = $hx - $tx;
            my $dy = $hy - $ty;
            next unless abs($dx) > 1 || abs($dy) > 1;

            $tx += $dx > 0 ? 1 : -1 if $dx;
            $ty += $dy > 0 ? 1 : -1 if $dy;
            $rope[$tail] = [$tx, $ty];
        }
        ++$count unless $grid{ $rope[9][0] }{ $rope[9][1] };
        $grid{ $rope[9][0] }{ $rope[9][1] } = 1;
    }
}

say $count;

__DATA__
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
