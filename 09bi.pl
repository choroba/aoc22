#! /usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

# Size 500x500
# x: -85  .. 283 : + 200
# y: -104 .. 289 : + 200

my $image = 'GD::Image'->new(500, 500);
$image->fill(0, 0, my $bg = $image->colorAllocate(10, 10, 10));
my $fg = $image->colorAllocate(0, 0, 200);
my @colours = reverse
              map $image->colorAllocate(50 + 20 * $_, 20 * $_, 20 * $_),
              0 .. 9;
my $font = gdSmallFont;


my %DIR = (R => [1, 0],
           L => [-1, 0],
           U => [0, -1],
           D => [0, 1]);

my @rope = map [0, 0], 1 .. 10;
my %grid;
$grid{0}{0} = 1;
my $count = 1;

while (<>) {
    print STDERR "$.\r";
    my ($direction, $length) = split;
    for (1 .. $length) {
        $rope[0][0] += $DIR{$direction}[0];
        $rope[0][1] += $DIR{$direction}[1];

        for my $tail (1 .. 9) {
            my ($hx, $hy, $tx, $ty)
                = (@{ $rope[ $tail - 1 ] }, @{ $rope[$tail] });
            my $dx = $hx - $tx;
            my $dy = $hy - $ty;
            next unless abs($dx) > 1 || abs($dy) > 1;

            $tx += $dx > 0 ? 1 : -1 if $dx;
            $ty += $dy > 0 ? 1 : -1 if $dy;
            $rope[$tail] = [$tx, $ty];
        }
        for (0 .. 9) {
            $image->setPixel($rope[$_][0] + 200, $rope[$_][1] + 200,
                             $colours[$_])
                unless $grid{ $rope[$_][0] }{ $rope[$_][1] };
        }
        open my $out, '>', sprintf '09b-%04d-%02d.gif', $., $_ or die $!;
        print {$out} $image->gif;
        close $out;

        for (0 .. 9) {
            $image->setPixel($rope[$_][0] + 200, $rope[$_][1] + 200, $bg)
                unless $grid{ $rope[$_][0] }{ $rope[$_][1] };
        }
        $image->setPixel($rope[9][0] + 200, $rope[9][1] + 200, $fg);
        $image->string($font, 0, 0, $count, $bg);
        ++$count unless $grid{ $rope[9][0] }{ $rope[9][1] };
        $image->string($font, 0, 0, $count, $fg);

        $grid{ $rope[9][0] }{ $rope[9][1] } = 1;
    }
}

say {*STDERR} 'Animating image...';
0 == system 'gifsicle', '-o', '09b.gif',
                        '-lforever',
                        '-d2',
                        glob('09b-*-*.gif'),
    or warn "gifsicle failed: $?\n";
say {*STDERR} 'Done.';

__DATA__
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
