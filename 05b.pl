#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @stacks;
while (<>) {
    last if /\d/;

    for (my $i = 1; $i < length; $i += 4) {
        my $crate = substr $_, $i, 1;
        push @{ $stacks[ ($i - 1 ) / 4 ] }, $crate
            if ' ' ne $crate;
    }
}
<>;
while (<>) {
    my ($quantity, $from, $to) = /move ([0-9]+) from ([0-9]+) to ([0-9]+)/;
    unshift @{ $stacks[ $to - 1 ] },
         splice @{ $stacks[ $from - 1 ] }, 0, $quantity;
}
say map $_->[0], @stacks;



__DATA__
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
