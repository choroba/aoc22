#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $LENGTH = 14;

INPUT:
while (<>) {
    for my $pos ($LENGTH - 1 .. length() - 2) {
        my $string = substr $_, $pos - $LENGTH + 1, $LENGTH;
        if ($string !~ /(.).*\1/) {
            say $pos + 1;
            next INPUT
        }
    }
    warn "NOT FOUND";
}

__DATA__
mjqjpqmgbljsphdztnvjfqwrcgsmlb
bvwbjplbgvbhsrlpgdmjqwftvncz
nppdvjthqldpwncqszvftbrmjlhg
nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg
zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw
