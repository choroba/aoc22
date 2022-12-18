#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %grid;
my (@min, @max);
while (<>) {
    chomp;
    $grid{$_} = 1;
    my @coord = split /,/;
    for my $pos (0, 1, 2) {
        $min[$pos] //= $coord[$pos];
        $min[$pos]   = $coord[$pos] if $coord[$pos] < $min[$pos];
        $max[$pos] //= $coord[$pos];
        $max[$pos]   = $coord[$pos] if $coord[$pos] > $max[$pos];
    }
}

--$min[$_], ++$max[$_] for 0, 1, 2;

my %accessible;
my %seen;
my %agenda = ("@min" => "");

while (%agenda) {
    my %next;
    for my $coord (keys %agenda) {
        for my $pos (0, 1, 2) {
            for my $shift (-1, 1) {
                my @coord = split / /, $coord;
                $coord[$pos] += $shift;
                next if $coord[$pos] < $min[$pos] || $coord[$pos] > $max[$pos];

                if (exists $grid{ join ',', @coord }) {
                    local $" = ',';
                    undef $accessible{"@coord:$pos:$shift"};
                } else {
                    undef $next{"@coord"} unless exists $seen{"@coord"};
                }
                undef $seen{"$coord"};
            }
        }
    }
    %agenda = %next;
}

say scalar keys %accessible;

__DATA__
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
