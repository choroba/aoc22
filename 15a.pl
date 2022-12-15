#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
my $Y = $ARGV[0] ? 2000000 : 10;

my ($min_x, $max_x);
my %grid;
while (<>) {
    my ($sx, $sy, $bx, $by) = /(-?[0-9]+)/g;
    $grid{$sx}{$sy} = {type   => 'sensor',
                       beacon => [$bx, $by]};
    $grid{$bx}{$by} = {type   => 'beacon'};
    $min_x //= $sx;
    $max_x //= $sx;
    for my $x ($sx, $bx) {
        $min_x = $x if $x < $min_x;
        $max_x = $x if $x > $max_x;
    }
}
for my $x (keys %grid) {
    for my $y (keys %{ $grid{$x} }) {
        next unless ($grid{$x}{$y}{type} // "") eq 'sensor';

        my $dist = abs($x - $grid{$x}{$y}{beacon}[0])
                 + abs($y - $grid{$x}{$y}{beacon}[1]);

        for my $m ($x - $dist .. $x + $dist) {
            for my $n ($Y) {
                next if ($grid{$m}{$n}{type} // "") eq 'beacon';
                my $d = abs($x - $m) + abs($y - $n);
                $grid{$m}{$n}{no_beacon} = 1 if $d <= $dist;
                $min_x = $m if $m < $min_x;
                $max_x = $m if $m > $max_x;
            }
        }
    }
}
my $count = 0;
for my $x ($min_x .. $max_x) {
    ++$count if exists $grid{$x}{$Y}{no_beacon};
}
say $count;

__DATA__
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
