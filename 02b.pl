#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %score = (
    ROCK     => 1,
    PAPER    => 2,
    SCISSORS => 3,
    LOST     => 0,
    DRAW     => 3,
    WON      => 6);

my %result = (
    ROCK     => {SCISSORS => 'LOST',
                 PAPER    => 'WON'},
    PAPER    => {ROCK     => 'LOST',
                 SCISSORS => 'WON'},
    SCISSORS => {PAPER    => 'LOST',
                 ROCK     => 'WON'});
$result{$_}{$_} = 'DRAW' for qw( ROCK PAPER SCISSORS );

my %decode = (
    A => 'ROCK',
    B => 'PAPER',
    C => 'SCISSORS',
    X => 'LOST',
    Y => 'DRAW',
    Z => 'WON');

my %need;
for my $elf (keys %result) {
    $need{$elf} = { reverse %{ $result{$elf} } };
}

my $score = 0;
while (<>) {
    my ($elf, $me) = split;
    my $shape = $need{ $decode{$elf} }{ $decode{$me} };
    $score += $score{$shape}
           + $score{ $result{ $decode{$elf} }{ $shape } };
}
say $score;

__DATA__
A Y
B X
C Z
