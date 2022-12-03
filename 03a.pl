#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %PRIORITY = map { $_    => ord($_) - ord '`',
                     uc $_ =>  ord($_) - 70
               } 'a' .. 'z';

my $sum;
while (<>) {
    chomp;
    my $length = length;
    my $compartment = substr $_, 0, $length / 2, "";
    my %part;
    @part{split //} = ();
    my $common = (grep exists $part{$_}, split //, $compartment)[0];
    $sum += $PRIORITY{$common};
}
say $sum;

__DATA__
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
