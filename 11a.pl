#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @monkeys;

while (<>) {
    if (/^Monkey [0-9]+:/) {
        push @monkeys, {};

    } elsif (/Starting items: ([0-9, ]*)/) {
        $monkeys[-1]{items} = [split /, /, $1];

    } elsif (/Operation: new = (.*)/) {
        $monkeys[-1]{operation} = $1;

    } elsif (/Test: divisible by ([0-9]+)/) {
        $monkeys[-1]{test} = $1;

    } elsif (/If (true|false): throw to monkey ([0-9]+)/) {
        $monkeys[-1]{$1} = $2;

    } elsif (/^.+$/) {
        die "Can't parse $_.\n";
    }
}

for my $round (1 .. 20) {
    for my $monkey (@monkeys) {
        while (@{ $monkey->{items} }) {
            ++$monkey->{active};
            my $item = shift @{ $monkey->{items} };
            my $expression = $monkey->{operation};
            $expression =~ s/old/$item/g;
            my $level = eval $expression;
            $level = int($level / 3);
            push @{ $monkeys[ $monkey->{
                (0 == $level % $monkey->{test}) ? 'true'
                                                : 'false'
            } ]{items} }, $level;
        }
    }
}

my @business = (0, 0);
for my $monkey (@monkeys) {
    if ($monkey->{active} >= $business[0]) {
        splice @business,
            ($monkey->{active} >= $business[1])
                ? 2
                : 1,
            0,
            $monkey->{active};
        shift @business;
    }
}
say $business[0] * $business[1];


__DATA__
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
