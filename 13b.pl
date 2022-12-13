#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };
use experimental 'signatures';

use ARGV::OrDATA;
use List::Util qw{ any };
use Storable qw{ dclone };

sub parse($packet) {
    my @list;
    while ($packet =~ s/((?:,?[0-9]+)+|[\[\]])//) {
        my $token = $1;
        if ($token =~ /[0-9]/) {
            $token =~ s/^,+//;
            push @list, split /,/, $token;

        } elsif ('[' eq $token) {
            my ($parsed, $rest) = parse($packet);
            push @list, $parsed;
            $packet = $rest;

        } elsif (']' eq $token) {
            return \@list, $packet

        } else {
            die "Can't parse '$packet'";
        }
    }
    return @list
}

sub compare(@packets) {
    while (@{ $packets[1] }) {
        my $p1 = shift @{ $packets[0] };
        my $p2 = shift @{ $packets[1] };
        return 1 unless defined $p1;

        if (! ref $p1 && ! ref $p2) {
            return $p1 < $p2 ? 1 : -1 if $p1 != $p2;

        } elsif (! ref $p1 || ! ref $p2) {
            unshift @{ $packets[1] }, ref $p2 ? $p2 : [$p2];
            unshift @{ $packets[0] }, ref $p1 ? $p1 : [$p1];
        } else {
            my $cmp = compare($p1, $p2);
            return $cmp if defined $cmp;
        }
    }
    return -1 if @{ $packets[0] };

    return
}

my @packets = ([[2]], [[6]]);
local $/ = "";
while (<>) {
    push @packets, map { parse($_) } split;
}
@packets = sort { compare(dclone($b), dclone($a)) } @packets;
my $key = 1;
for my $i (0 .. $#packets) {
    $key *= $i + 1 if ref $packets[$i] && 1 == @{ $packets[$i] }
                   && ref $packets[$i][0] && 1 == @{ $packets[$i][0] }
                   && ! ref $packets[$i][0][0]
                   && any { $packets[$i][0][0] == $_} 2, 6;
}
say $key;

__DATA__
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
