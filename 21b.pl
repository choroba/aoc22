#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $arg = shift;

my %op = (
    '+' => sub { $_[0] + $_[1] },
    '-' => sub { $_[0] - $_[1] },
    '*' => sub { $_[0] * $_[1] },
    '/' => sub { $_[0] / $_[1] },
    '=' => sub { $_[0] - $_[1] },
);

my %monkey;
while (<>) {
    if (/([a-z]+): ([0-9]+)/) {
        $monkey{$1} = 0+$2;
    } elsif (m{([a-z]+): ([a-z]+) ([-+*/]) ([a-z]+)}) {
        $monkey{$1} = [$3, $2, $4];
    }
}

$monkey{humn} = $arg;
$monkey{root}[0] = '=';

while ('ARRAY' eq ref $monkey{root}) {
    for my $m (grep 'ARRAY' eq ref $monkey{$_}, keys %monkey) {
        next if 'ARRAY' eq ref $monkey{ $monkey{$m}[1] }
             || 'ARRAY' eq ref $monkey{ $monkey{$m}[2] };
        $monkey{$m} = $op{ $monkey{$m}[0] }->(
            $monkey{ $monkey{$m}[1] },
            $monkey{ $monkey{$m}[2] });
    }
}

say $monkey{root};
__DATA__
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
