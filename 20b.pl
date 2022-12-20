#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use enum qw( VALUE PREV NEXT );

my $KEY = 811589153;

my @numbers = (my $first = []);
my $zero;
my $next = $first;

sub show {
    my $start = shift;
    my $node = $start;
    do {
        print $node->[VALUE], ' ';
        $node = $node->[NEXT];
    } until $node == $start;
    print "\n";
}

while (my $number = <>) {
    chomp $number;
    $number *= $KEY;
    $zero = $next if 0 == $number;
    $next->[VALUE] = $number;
    $next->[NEXT] = [undef, $next, []];
    $next = $next->[NEXT];
    push @numbers, $next;
}

pop @numbers;
$first->[PREV] = $next->[PREV];
$next->[PREV][NEXT] = $first;
undef $next;

for (1 .. 10) {
    for my $n (@numbers) {
        my $v = $n->[VALUE];

        my $shift = abs($v) % (@numbers - 1) or next;
        #my $shift = abs $v or next;

        --$shift if $v < 0;

        my $direction = $v > 0 ? NEXT : PREV;
        my $target = $n->[$direction];

        $n->[PREV][NEXT] = $n->[NEXT];
        $n->[NEXT][PREV] = $n->[PREV];

        $target = $target->[$direction] for 1 .. $shift;

        $n->[NEXT] = $target;
        $n->[PREV] = $target->[PREV];
        $target->[PREV][NEXT] = $n;
        $target->[PREV] = $n;
    }
}

my $n = $zero;
my $step = 1000 % @numbers;
my $sum = 0;
for (1 .. 3) {
    $n = $n->[NEXT] for 1 .. $step;
    say $n->[VALUE];
    $sum += $n->[VALUE];
}
say $sum;

__DATA__
1
2
-3
3
-2
0
4
