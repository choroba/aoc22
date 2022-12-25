#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };
use experimental qw{ signatures };

use ARGV::OrDATA;


my %DIGIT = (0   => 0,
             1   => 1,
             2   => 2,
             '-' => -1,
             '=' => -2);

sub snafu2dec($s) {
    my $d = 0;
    my $magnitude = 1;
    while (length(my $c = substr $s, -1, 1, "")) {
        $d += $DIGIT{$c} * $magnitude;
        $magnitude *= 5;
    }
    return $d
}


sub incr($s) {
    my $last = substr $s, -1, 1, "";
    if ($last ne '2') {
        return $s . {1 => '2', 0 => '1', '-' => 0, '=' => '-'}->{$last}
    }
    return incr($s) . '='
}

sub dec2snafu($d) {
    my $magnitude = 5 ** int(log($d) / log 5);
    my $result = 0;
    while ($magnitude >= 1) {
        my $r = int($d / $magnitude);
        $d = $d % $magnitude;
        $magnitude /= 5;
        if ($r > 2) {
            $result = incr($result);
            $r = qw( = - )[ $r - 3 ]
        }
        $result .= $r;
    }
    return $result =~ s/^0+//r
}

my $sum;
while (<>) {
    chomp;
    my $n = snafu2dec($_);
    $sum += $n;
}
say dec2snafu($sum);

__DATA__
1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122
