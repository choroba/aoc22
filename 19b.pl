#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use threads stack_size => 8 * 4096;;
use Thread::Queue;

my $MINUTES = 32;
my @RESOURCES = qw( geode obsidian clay ore );

my @blueprints;
while (<>) {
    my ($id,
        $ore_ore,
        $clay_ore,
        $obsidian_ore, $obsidian_clay,
        $geode_ore, $geode_obsidian
    ) = /([0-9]+)/g;

    push @blueprints, {id       => $id,
                       ore      => {ore      => $ore_ore},
                       clay     => {ore      => $clay_ore},
                       obsidian => {ore      => $obsidian_ore,
                                    clay     => $obsidian_clay},
                       geode    => {ore      => $geode_ore,
                                    obsidian => $geode_obsidian}};

    last if @blueprints == 3;
}

my $q_in = 'Thread::Queue'->new;
my $q_out = 'Thread::Queue'->new;

my @threads = map threads->create(sub {
    my $blueprint = $q_in->dequeue;
    my %agenda = (pack('N4', 0, 0, 0, 0) => {pack('N4', 0, 0, 0, 1) => undef});

    for my $minute (1 .. $MINUTES) {
        my %next;
        for my $res_state (keys %agenda) {
            my %resources; @resources{@RESOURCES} = unpack('N4', $res_state);
            for my $rob_state (keys %{ $agenda{$res_state} }) {
                my %robots; @robots{@RESOURCES} = unpack('N4', $rob_state);

                my $count = 0;
                for my $to_build (@RESOURCES, 'none') {
                    # It doesn't make sense not to build if we can build all types.
                    last if $count == @RESOURCES;

                    my %res = %resources;
                    my %rob = %robots;

                    my @resources = 'none' eq $to_build
                        ? ()
                        : keys %{ $blueprint->{$to_build} };
                    if (! grep $blueprint->{$to_build}{$_} > $resources{$_},
                        @resources
                    ) {
                        $res{$_} -= $blueprint->{$to_build}{$_}
                            for @resources;
                        ++$rob{$to_build};
                        ++$count;
                    }
                    $res{$_} += $robots{$_} for keys %robots;
                    ++$next{pack('N4', @res{@RESOURCES})}
                           {pack('N4', @rob{@RESOURCES})};
                }
            }
        }
        for my $k (keys %next) {
            my @sorted = sort { $b->[0] <=> $a->[0]
                                || $b->[1] <=> $a->[1]
                                || $b->[2] <=> $a->[2]
                                || $b->[3] <=> $a->[3]
                         } map [unpack 'N4', $_],
                         keys %{ $next{$k} };
            my @delete;
            for my $i (0 .. $#sorted - 1) {
                for my $j ($i + 1 .. $#sorted) {
                    my $should_delete = 0;
                    for my $pos (0 .. 3) {
                        ++$should_delete
                            if $sorted[$i][$pos] >= $sorted[$j][$pos];
                    }
                    push @delete, pack 'N4', @{ $sorted[$j] }
                        if $should_delete == @RESOURCES;
                }
            }
            delete @{ $next{$k} }{@delete} if @delete;
            if ($minute > 25) {
                for my $k2 (keys %{ $next{$k} }) {
                    delete $next{$k}{$k2} if 0 == unpack 'N1', $k2;
                }
            }
        }
        %agenda = %next;
    }
    my $max = 0;
    for my $state (keys %agenda) {
        my ($geod) = unpack 'N1', $state;
        $max = $geod if $geod > $max;
    }
    $q_out->enqueue($max);
}), @blueprints;

for my $blueprint (@blueprints) {
    $q_in->enqueue($blueprint);
}
$q_in->end;
my $geodes_product = 1;
for (@blueprints) {
    my $max = $q_out->dequeue;
    say $max;
    $geodes_product *= $max;
}
$_->join for @threads;

say $geodes_product;

__DATA__
Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
