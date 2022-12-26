#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ max sum uniq min };

my $TIME = 26;

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

my @VALVES = sort keys %valve;
my $i = 0;
my %CODE = map {; $_ => 2 ** $i++ } grep $valve{$_}{rate}, @VALVES;
my %CODE_R = reverse %CODE;
my $ALL = sum(values %CODE);
my $all;
my $max_rate = sum(map $_->{rate}, values %valve);
my $min = 0;

sub rate {
    my ($opened) = @_;
    my $rate = 0;
    my $i = 1;
    while ($i <= $opened) {
        $rate += $valve{ $CODE_R{$i} }{rate}
            if (0 + $opened) & $i;
        $i *= 2;
    }
    return $rate
}

my @agenda = (['AA', 'AA', 0, 0]);
for my $time (1 .. $TIME) {
    say {*STDERR} $time;

    my %next;
    for my $state (@agenda) {
        my %half;
        my ($v1, $v2, $opened, $sum) = @$state;

        $sum += rate($opened);

        if ($opened < $ALL) {
            my $can_open1 = $CODE{$v1} && ! ((0 + $CODE{$v1}) & $opened);
            my $can_open2 = $CODE{$v2} && ! ((0 + $CODE{$v2}) & $opened);
            $can_open2 = 0 if $v1 eq $v2 && $can_open1 && $can_open2;

            for my $who (0, 1) {
                my $valve = ($v1, $v2)[$who];
                my $can_open = ($can_open1, $can_open2)[$who];

                if ($can_open) {
                    undef $half{$who}{"$valve:1"};
                }

                for my $c (@{ $valve{$valve}{connect} }) {
                    undef $half{$who}{"$c:0"};
                }
            }

            for my $h1 (keys %{ $half{0} }) {
                my ($valve1, $can_open1) = split /:/, $h1;
                for my $h2 (keys %{ $half{1} }) {
                    my ($valve2, $can_open2) = split /:/, $h2;

                    my $o = $opened;
                    $o |= $CODE{$valve1} if $can_open1;
                    $o |= $CODE{$valve2} if $can_open2;

                    my @v = sort $valve1, $valve2;
                    my $k = join ':', @v, $o;
                    $next{$k} = $sum if $sum >= ($next{$k} // 0);
                }
            }
        } else {
            my @v = sort $v1, $v2;
            my $k = join ':', @v, $opened;
            $next{$k} = $sum if $sum >= ($next{$k} // 0);
        }
    }

    @agenda = map [split(/:/), $next{$_}], keys %next;

    # Keep only the states that can still beat the max.
    my $max = max(map $_->[3], @agenda);
    @agenda = grep $_->[3] + $max_rate > $max, @agenda;
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
