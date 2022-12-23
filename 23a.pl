#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %DIRECTION = (
    N  => [0, -1],
    S  => [0, 1],
    W  => [-1, 0],
    E  => [1, 0],
    NW => [-1, -1],
    NE => [1, -1],
    SE => [1, 1],
    SW => [-1, 1]);

my %grid;

my ($minX, $minY, $maxX, $maxY) = (1) x 4;
while (my $line = <>) {
    chomp $line;
    $maxX = length $line;
    for my $i (1 .. $maxX) {
        $grid{$i}{$.} = '#' eq substr $line, $i - 1, 1;
    }
}
$maxY = $.;

my @rules = ([qw[ N NE NW ]],
             [qw[ S SE SW ]],
             [qw[ W NW SW ]],
             [qw[ E NE SE ]]);

for my $round (1 .. 10) {
    say "\n", $round;

    my %wish;
    for my $x ($minX .. $maxX) {
        for my $y ($minY .. $maxY) {
            next unless $grid{$x}{$y};

            my $has_neighbours;
          NEIGHBOUR:
            for my $dx (-1 .. 1) {
                for my $dy (-1 .. 1) {
                    next if 0 == $dx && 0 == $dy;

                    $has_neighbours = 1, last NEIGHBOUR
                        if $grid{ $x + $dx }{ $y + $dy };
                }
            }
            my $can_move = 0;
            if ($has_neighbours) {
                for my $rule (@rules) {
                    my $is_applicable = 1;
                    for my $direction (@$rule) {
                        $is_applicable = 0
                            if $grid{ $x + $DIRECTION{$direction}[0] }
                                    { $y + $DIRECTION{$direction}[1] };
                    }
                    if ($is_applicable) {
                        $can_move = 1;
                        undef $wish{ $x + $DIRECTION{ $rule->[0] }[0] }
                                   { $y + $DIRECTION{ $rule->[0] }[1] }
                                   {"$x $y"};
                        last
                    }
                }
            }
            undef $wish{$x}{$y}{"$x $y"} unless $can_move;
        }
    }

    my %next;
    for my $x (keys %wish) {
        for my $y (keys %{ $wish{$x} }) {
            if (1 == keys %{ $wish{$x}{$y} }) {
                $next{$x}{$y} = 1;
                $minX = $x if $x < $minX;
                $maxX = $x if $x > $maxX;
                $minY = $y if $y < $minY;
                $maxY = $y if $y > $maxY;

            } else {
                for my $k (keys %{ $wish{$x}{$y} }) {
                    my ($i, $j) = split / /, $k;
                    $next{$i}{$j} = 1;
                }
            }
        }
    }
    %grid = %next;

    for my $y ($minY .. $maxY) {
        for my $x ($minX .. $maxX) {
            print $grid{$x}{$y} ? '#' : '.';
        }
        print "\n";
    }

    push @rules, shift @rules;
}

my $empty;
for my $x ($minX .. $maxX) {
    for my $y ($minY .. $maxY) {
        ++$empty unless $grid{$x}{$y};
    }
}
say $empty;

__DATA__
....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..
