#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @cwd;
my %fs = ('/' => {});

sub set {
    my ($dir, $size, @path) = @_;
    if (@path > 1) {
        my $first = shift @path;
        set($dir->{$first}, $size, @path);
    } elsif (! exists $dir->{ $path[0] }) {
        $dir->{ $path[0] } = $size;
    }
}

my %size;
sub size {
    my ($dir, $path) = @_;
    my $size = 0;
    for my $file (keys %$dir) {
        if (ref $dir->{$file}) {
            $size += size($dir->{$file}, "$path/$file");
        } else {
            $size += $dir->{$file};
        }
    }
    $size{$path} = $size;
}

while (<>) {
    chomp;
    if (m{^\$ cd \.\.$}) {
        pop @cwd;
    } elsif (m{^\$ cd /$}) {
        @cwd = ();
    } elsif (m{^\$ cd (.+)}) {
        push @cwd, $1;
        set($fs{'/'}, {}, @cwd);
    } elsif (/^dir (.+)/) {
    } elsif (/^([0-9]+) (.+)/) {
        set($fs{'/'}, $1, @cwd, $2);
    }
}

size(\%fs, "");
delete $size{""};
my $sum = 0;
for my $size (values %size) {
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
