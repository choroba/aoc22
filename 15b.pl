#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
my $MAX = $ARGV[0] ? 4_000_000 : 20;
use enum qw( SX SY DISTANCE );

my @sensors;
while (<>) {
    my ($sx, $sy, $bx, $by) = /(-?[0-9]+)/g;
    push @sensors, [$sx, $sy, abs($sx - $bx) + abs($sy - $by)];
}

my $result;
for my $y (0 .. $MAX) {
    my @intervals;
    for my $sensor (@sensors) {
        next if abs($y - $sensor->[SY]) > $sensor->[DISTANCE];

        my $from = $sensor->[SX] - (($sensor->[SY] < $y)
                                    ? $sensor->[SY] + $sensor->[DISTANCE] - $y
                                    : $y - $sensor->[SY] + $sensor->[DISTANCE]);
        next if $from > $MAX;

        my $to = $sensor->[SX] + ($sensor->[SX] - $from);

        $from = 0    if $from < 0;
        $to   = $MAX if $to > $MAX;
        push @intervals, [$from, $to];
    }

    @intervals = sort { $a->[0] <=> $b->[0] } @intervals;
    for my $i (1 .. $#intervals) {
        next if $intervals[$i][0] - 1 > $intervals[ $i - 1 ][1];

        if ($intervals[$i][1] <= $intervals[ $i - 1 ][1]) {
            $intervals[$i][1] = $intervals[ $i - 1 ][1];
        }
        $intervals[$i][0] = $intervals[ $i - 1 ][0];
        undef $intervals[ $i - 1 ];
    }
    @intervals = grep defined, @intervals;

    if (@intervals > 1) {
        $result = 4_000_000 * ($intervals[0][1] + 1) + $y;
        last

    } else {
        if ($intervals[0][0] != 0) {
            $result = $y;
            last

        } elsif ($intervals[0][1] != $MAX) {
            $result = 4_000_000 * $MAX + $y;
            last
        }
    }
}

say $result;

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
