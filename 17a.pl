#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use Storable qw{ dclone };

my @SHAPES = (
    [[0, 0], [1, 0], [2, 0], [3, 0]],          # -
    [[1, 2], [0, 1], [1, 1], [2, 1], [1, 0]],  # +
    [[1, 2], [2, 2], [2, 1], [0, 2], [2, 0]],  # L
    [[0, 3], [0 ,2], [0, 1], [0, 0]],          # I
    [[0, 1], [1, 1], [0, 0], [1, 0]]);         # o

my %JET = ('>' => 1, '<' => - 1);

my $WIDTH = 7;
my $MAX_ROCKS = 2022;

chomp( my $line = <> );
my @moves = map $JET{$_}, split //, $line;

my @grid = ([qw[ W W W W W W W W W ]]);

my $move_index = 0;
for my $tally (0 .. $MAX_ROCKS - 1) {
    my ($x, $y) = (3, 0);

    my $rock = dclone($SHAPES[ $tally % @SHAPES ]);

    my $draw = sub {
        say shift;
        for my $point (@$rock) {
            $grid[ $point->[1] ][ $point->[0] ] =~ s/\./o/;
        }
        for my $line (@grid) {
            say @$line;
        }
        for my $point (@$rock) {
            $grid[ $point->[1] ][ $point->[0] ] =~ s/o/./;
        }
        use Time::HiRes qw{ sleep }; sleep .1;
    };

    my $h = 0;
    ++$h while ! grep '.' ne $_, @{ $grid[$h] }[1 .. $WIDTH];
    warn "H: $h";

    if ($h > 3) {
        shift @grid for 4 .. $h;
    } else {
        unshift @grid, [qw[ W . . . . . . . W ]] for $h .. 2;
    }
    unshift @grid, [qw[ W . . . . . . . W ]] for 0 .. $rock->[0][1];

    say 'ROCK ', $tally % @SHAPES;
    for my $point (@$rock) {
        $point->[$_] += ($x, $y)[$_] for 0, 1;
    }

    # $draw->('init');

    my $has_moved = 1;
    while ($has_moved) {
        undef $has_moved;

        # Horizontal move.
        my $move = $moves[ $move_index % @moves ];
        my $h;
        for my $point (@$rock) {
            push @$h, [@$point];
            $h->[-1][0] += $move;
            if ($grid[ $h->[-1][1] ][ $h->[-1][0] ] ne '.') {
                say 'blocked';
                $h = $rock;
                last
            }
        }
        $rock = $h;
        # $draw->("horizontal $move ($move_index)");

        # Vertical move.
        my $v;
        my $can_move = 1;
        for my $point (@$rock) {
            push @$v, [@$point];
            $v->[-1][1] += 1;
            if ($grid[ $v->[-1][1] ][ $v->[-1][0] ] ne '.' ) {
                undef $can_move;
                last
            }
        }
        if ($can_move) {
            $rock = $v;
            $has_moved = 1;
        } else {
            for my $point (@$rock) {
                $grid[ $point->[1] ][ $point->[0] ] = $tally % 10;
            }
        }

        # $draw->('vertical');

        $draw->('final') if $tally == $MAX_ROCKS - 1;

    } continue {
        ++$move_index;
    }
}

shift @grid until grep '.' ne $_, @{ $grid[0] }[1 .. $WIDTH];
say @grid - 1;  # The floor.

__DATA__
>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
