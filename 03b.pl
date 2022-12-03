#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %PRIORITY = map { $_    => ord($_) - ord '`',
                     uc $_ =>  ord($_) - 70
               } 'a' .. 'z';

my $sum;
while (1) {
    my @group = map scalar <>, 1 .. 3;
    chomp @group;
    my %score;
    for my $g (0 .. 2) {
        undef $score{$_}{$g} for split //, $group[$g];
    }
    my $common = (grep 3 == keys %{ $score{$_} }, keys %score)[0];
    $sum += $PRIORITY{$common};
    last if eof;
}
say $sum;

__DATA__
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
