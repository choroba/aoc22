#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %DIRECTION = ('<' => [-1, 0],
                 '>' => [1, 0],
                 '^' => [0, -1],
                 'v' => [0, 1]);

my @grid;
while (<>) {
    chomp;
    push @grid, [split //];
}

my $start_x = grep $grid[0][$_] eq '.', 0 .. $#{ $grid[0] };
my %agenda = ($start_x => {0 => undef});

my $round = 1;
ROUND:
while (1) {
    my @next_g;
    for my $y (0 .. $#grid) {
        for my $x (0 .. $#{ $grid[0] }) {
            if ('#' eq $grid[$y][$x]) {
                $next_g[$y][$x] = $grid[$y][$x];
            } elsif ('.' ne $grid[$y][$x]) {
                for my $blizzard (split //, $grid[$y][$x]) {
                    my $d = $DIRECTION{$blizzard};
                    my $nx = $x + $d->[0];
                    my $ny = $y + $d->[1];
                    if ($grid[$ny][$nx] eq '#') {
                        if ($d->[0]) {
                            my $div = $#{ $grid[0] } - 1;
                            $nx = $nx % $div  || $div;
                        } else {
                            my $div = $#grid - 1;
                            $ny = $ny % $div  || $div;
                        }
                        $next_g[$ny][$nx] .= $blizzard;

                    } else {
                        $next_g[$ny][$nx] .= $blizzard;
                    }
                }
            }
        }
    }
    for my $y (0 .. $#grid) {
        for my $x (0 .. $#{ $grid[0] }) {
            $next_g[$y][$x] //= '.';
        }
    }

    my %next_a;
    for my $x (keys %agenda) {
        for my $y (keys %{ $agenda{$x} }) {
            for my $move ([0, 0], values %DIRECTION) {
                my $nx = $x + $move->[0];
                my $ny = $y + $move->[1];

                next if $ny < 0 || $ny > $#grid;

                if ('.' eq $next_g[$ny][$nx]) {
                    undef $next_a{$nx}{$ny};
                    last ROUND if $ny == $#grid;
                }
            }
        }
    }
    %agenda = %next_a;

    @grid = @next_g;
    for my $y (0 .. $#grid) {
        for my $x (0 .. $#{ $grid[$y] }) {
            my $p = $grid[$y][$x];
            $p = 'E' if exists $agenda{$x}{$y};
            print 1 == length $p ? $p : length $p;
        }
        print "\n";
    }
    print "$round\n";

} continue {
    ++$round;
}
say $round;

__DATA__
#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#
