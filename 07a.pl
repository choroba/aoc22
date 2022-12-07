#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @cwd = ("");
my %dirsize;

while (<>) {
    chomp;
    if (m{^\$ cd \.\.$}) {
        pop @cwd if @cwd > 1;
    } elsif (m{^\$ cd /$}) {
        @cwd = ("");
    } elsif (m{^\$ cd (.+)}) {
        push @cwd, $1;
    } elsif (/^([0-9]+) (.+)/) {
        my ($size, $name) = ($1, $2);
        $dirsize{ join '/', @cwd[0 .. $_] } += $size for 0 .. $#cwd;
    }
}

my $sum = 0;
for my $size (values %dirsize) {
    $sum += $size if $size <= 100_000;
}
say $sum;

__DATA__
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
