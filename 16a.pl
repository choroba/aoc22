#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ max uniq };

my $TIME = 30;

use enum qw( VALVE OPENED RATE SUM );

## TODO Remove
$|--;

my %valve;
while (<>) {
    if (
        /Valve ([[:upper:]]+) has .*=([0-9]+); tunnels? leads? to valves? (.*)/
    ) {
        my ($source, $rate, $targets) = ($1, $2, $3);
        $valve{$source} = {rate    => $rate,
                           connect => [$targets =~ /([[:upper:]]+)/g]};
    }
}

my @agenda = ([AA => "", 0, 0]);
for (1 .. $TIME) {
    print "$_ \r";
    my %next;
    for my $state (@agenda) {
        my ($valve, $opened, $rate, $sum) = @$state;
        # Open.
        if (-1 == index($opened, $valve) && $valve{$valve}{rate} != 0) {
            my $opened2 = join ',', sort +uniq($valve, split /,/, $opened);
            my $rate2 = $rate + $valve{$valve}{rate};
            my $sum2 = $sum + $rate;
            $next{"$valve:$opened2:$rate2"}{$sum2} = undef;
        }
        # Use tunnel.
        for my $target (@{ $valve{$valve}{connect} }) {
            $next{"$target:$opened:$rate"}{ $sum + $rate } = undef;
        }
    }
    my @next;
    for my $valve_opened_rate (keys %next) {
        my $max_sum = max(keys %{ $next{$valve_opened_rate} });
        push @next, [split(/:/, $valve_opened_rate), $max_sum];
    }
    @agenda = @next;
}
say max(map $_->[3], @agenda);

__DATA__
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
