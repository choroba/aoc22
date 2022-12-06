#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

INPUT:
while (<>) {
    for my $pos (3 .. 1 + length) {
        my $string = substr $_, $pos - 3, 4;
        if ($string !~ /(.).*\1/) {
            say $pos + 1;
            next INPUT
        }
    }
}

__DATA__
mjqjpqmgbljsphdztnvjfqwrcgsmlb
bvwbjplbgvbhsrlpgdmjqwftvncz
nppdvjthqldpwncqszvftbrmjlhg
nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg
zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw
