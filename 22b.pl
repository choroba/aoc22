#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use enum qw( RIGHT DOWN LEFT UP );

use Term::ANSIColor;

my @DIRECTION = ([1, 0], [0, 1], [-1, 0], [0, -1]);

my $sleep = .01;

my %grid;
my ($x, $y, $f) = (undef, 1, RIGHT);
my ($X, $Y) = (0, 0);

sub show {
    print color('bright_black');
    for my $j (1 .. $Y) {
        for my $i (1 .. $X) {
            if ($x == $i && $y == $j) {
                print colored(['bright_yellow'], qw( > v < ^ )[$f]);
                print color('bright_black');
            } else {
                print $grid{$i}{$j} // ' ';
            }
        }
        print "\n";
    }
    print "$x $y $f\n";
    #use Time::HiRes; Time::HiRes::sleep($sleep);
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
--$Y;
chomp( my $path = <> );

while ($path =~ s/^([0-9]+|[LRSF])//) {
    my $p = $1;
    if ($p =~ /\d/) {
        my ($xx, $yy, $ff) = ($x, $y, $f);
        for (1 .. $p) {
            my $d = $DIRECTION[$ff];
            $xx += $d->[0];
            $yy += $d->[1];

            if (! exists $grid{$xx}{$yy} || ' ' eq $grid{$xx}{$yy}) {

                if ($yy == 0 && $xx <= 2 * $X / 3 && $ff == UP) {  # A -> F
                    $yy = $Y - 2 * $X / 3 + $xx;
                    $xx = 1;
                    $ff = RIGHT;
                } elsif ($xx == 0 && $yy > 3 * $Y / 4 && $ff == LEFT) {  # F -> A
                    $xx = 2 * $X / 3 - $Y + $yy;
                    $yy = 1;
                    $ff = DOWN;
                } elsif ($xx <= $X / 3 && $yy <= $Y / 4 && $ff == LEFT) {  # A -> D
                    $yy = 3 * $Y / 4 - $yy + 1;
                    $xx = 1;
                    $ff = RIGHT;
                } elsif ($xx == 0 && $ff == LEFT
                         && $yy > 2 * $Y / 4 && $yy <= 3 * $Y / 4
                ) { # D -> A
                    $xx = $X / 3 + 1;
                    $yy = 3 * $Y / 4 - $yy + 1;
                    $ff = RIGHT;
                } elsif ($xx <= $X / 3 && $yy == $Y / 2 && $ff == UP) {  # D -> C
                    $yy = $Y / 4 + $xx;
                    $xx = $X / 3 + 1;
                    $ff = RIGHT;
                } elsif ($xx <= $X && $yy > $Y / 4 && $ff == LEFT) {  # C -> D
                    $xx = $yy - $Y / 4;
                    $yy = $Y / 2 + 1;
                    $ff = DOWN;
                } elsif ($yy > $Y) {  # F -> B
                    $xx = $xx + 2 * $X / 3;
                    $yy = 1;
                    $ff = DOWN;
                } elsif ($yy == 0 && $xx > 2 * $X / 3) {  # B -> F
                    $xx = $xx - 2 * $X / 3;
                    $yy = $Y;
                    $ff = UP;
                } elsif ($xx > 2 * $X / 3 && $yy == 1 + $Y / 4
                         && $ff == DOWN  # B -> C
                ) {
                    $ff = LEFT;
                    $yy = $Y / 4 + $xx - 2 * $X / 3;
                    $xx = 2 * $X / 3;
                } elsif ($xx > 2 * $X / 3 && $ff == RIGHT
                     && $yy > $Y / 4 && $yy <= $Y / 2  # C -> B
                ) {
                    $xx = $yy - $Y / 4 + 2 * $X / 3;
                    $yy = $Y / 4;
                    $ff = UP;
                } elsif ($xx > $X / 3 && $yy > 3 * $Y / 4 && $ff == RIGHT) { # F -> E
                    $xx = 2 * $X / 3 - $Y + $yy;
                    $yy = 3 * $Y / 4;
                    $ff = UP;
                } elsif ($xx > $X / 3 && $yy > 3 * $Y / 4 && $ff == DOWN) {  # E -> F
                    $yy = $xx - $X / 3 + 3 * $Y / 4;
                    $xx = $X / 3;
                    $ff = LEFT;
                } elsif ($xx > $X) {  # B -> E
                    $yy = 1 + 3 * $Y / 4 - $yy;
                    $xx = 2 * $X / 3;
                    $ff = LEFT;
                } elsif ($xx > 2 * $X / 3 && $yy > $Y / 2) {  # E -> B
                    $yy = 3 * $Y / 4 - $yy + 1;
                    $xx = $X;
                    $ff = LEFT;
                } else {
                    print color('white');
                    die "$xx, $yy, $ff.";
                }

            }
            last if '#' eq ($grid{$xx}{$yy} // "");

            ($x, $y, $f) = ($xx, $yy, $ff);
            #show();
        }

    } elsif ('F' eq $1) {
        $sleep = .01;
    } elsif ('S' eq $1) {
        $sleep = .5;

    } else {
        $f = ($f + ($1 eq 'R' ? 1 : -1)) % @DIRECTION;
        #show();
    }
}

print color('white');
say 1000 * $y + 4 * $x + $f;

# Only works for the following shape:
#   A B
#   C
# D E
# F
