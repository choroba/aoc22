#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use enum qw( RIGHT DOWN LEFT UP );

my @DIRECTION = ([1, 0], [0, 1], [-1, 0], [0, -1]);

my %grid;
my ($x, $y, $f) = (undef, 1, RIGHT);
my ($X, $Y) = (0, 0);

sub show {
    for my $j (1 .. $Y) {
        for my $i (1 .. $X) {
            if ($x == $i && $y == $j) {
                print qw( > v < ^ )[$f];
            } else {
                print $grid{$i}{$j} // ' ';
            }
        }
        print "\n";
    }
    print "$x $y $f\n";
}

while (<>) {
    chomp;
    $Y = $.;
    last unless length;

    for my $i (1 .. length) {
        my $char = substr $_, $i - 1, 1;
        $X = $i if $i > $X;
        $x //= $i,
        $grid{$i}{$.} = $char unless ' ' eq $char;
    }
}
chomp( my $path = <> );

while ($path =~ s/^([0-9]+|[LR])//) {
    my $p = $1;
    if ($p =~ /\d/) {
        my $d = $DIRECTION[$f];
        my ($xx, $yy) = ($x, $y);
        for (1 .. $p) {
            $xx += $d->[0];
            $yy += $d->[1];

            if (! exists $grid{$xx}{$yy} || ' ' eq $grid{$xx}{$yy}) {
                my $dd = [map -$_, @$d];
                while ($grid{ $xx + $dd->[0] }{ $yy + $dd->[1] } // "") {
                    $xx += $dd->[0];
                    $yy += $dd->[1];
                }
            }
            last if '#' eq ($grid{$xx}{$yy} // "");

            ($x, $y) = ($xx, $yy);
        }

    } else {
        $f = ($f + ($1 eq 'R' ? 1 : -1)) % @DIRECTION;
    }
    #show();
}

say 1000 * $y + 4 * $x + $f;

__DATA__
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
