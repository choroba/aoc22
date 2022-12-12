#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @grid;
my ($x, $y, $tx, $ty);
while (<>) {
    chomp;
    if (/(?=S)/g) {
        $y = @grid;
        $x = pos;
        substr $_, $x, 1, 'a';
    }
    if (/(?=E)/g) {
        $ty = @grid;
        $tx = pos;
        substr $_, $tx, 1, 'z';
    }
    push @grid, [map ord($_) - ord 'a', split //];
}

my %current;
for my $y (0 .. $#grid) {
    for my $x (0 .. $#{ $grid[0] }) {
        undef $current{$x}{$y} if $grid[$y][$x] == 0;
    }
}
my $step = 0;
my %seen;
until (exists $current{$tx}{$ty}) {
    my %next;
    for my $X (keys %current) {
        for my $Y (keys %{ $current{$X} }) {
            undef $seen{$X}{$Y};
            for my $move ([0, 1], [1, 0], [0, -1], [-1, 0]) {
                my $nx = $X + $move->[0];
                my $ny = $Y + $move->[1];
                next if $nx < 0 || $ny < 0
                     || $ny > $#grid || $nx > $#{ $grid[0] }
                     || exists $seen{$nx}{$ny}
                     || $grid[$ny][$nx] - $grid[$Y][$X] > 1;
                undef $next{$nx}{$ny};
            }
        }
    }
    ++$step;
    %current = %next;
}
say $step;

__DATA__
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
