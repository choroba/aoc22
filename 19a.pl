#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $MINUTES = 24;
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
}

my $quality;
for my $blueprint (@blueprints) {
    my %agenda = ('0 0 0 0' => {'0 0 0 1' => undef});

    for my $minute (1 .. $MINUTES) {
        my %next;
        for my $res_state (keys %agenda) {
            my %resources; @resources{@RESOURCES} = split / /, $res_state;
            for my $rob_state (keys %{ $agenda{$res_state} }) {
                my %robots; @robots{@RESOURCES} = split / /, $rob_state;

                for my $to_build ('none', @RESOURCES) {
                    my %res = %resources;
                    my %rob = %robots;

                    my @resources = keys %{ $blueprint->{$to_build} };
                    if (! grep $blueprint->{$to_build}{$_} > $resources{$_},
                        @resources
                    ) {
                        for my $resource (@resources) {
                            $res{$resource}
                                -= $blueprint->{$to_build}{$resource};
                        }
                        ++$rob{$to_build};
                    }

                    for my $robot (keys %robots) {
                        $res{$robot} += $robots{$robot};
                    }

                    ++$next{"@res{@RESOURCES}"}{"@rob{@RESOURCES}"};
                }
            }
        }
        for my $k (keys %next) {
            my @sorted = sort { $a->[0] <=> $b->[0]
                                || $a->[1] <=> $b->[1]
                                || $a->[2] <=> $b->[2]
                                || $a->[3] <=> $b->[3]
                         } map [split],
                         keys %{ $next{$k} };
            for my $s (@sorted) {
                for my $pos (0 .. 3) {
                    --$s->[$pos];
                    delete $next{$k}{"@$s"};
                    ++$s->[$pos];
                }
            }
        }
        %agenda = %next;
    }
    my $max = 0;
    for my $state (keys %agenda) {
        my ($geod) = $state =~ /^([0-9]+)/;
        $max = $geod if $geod > $max;
    }
    $quality += $blueprint->{id} * $max;
}
say $quality;

__DATA__
Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
