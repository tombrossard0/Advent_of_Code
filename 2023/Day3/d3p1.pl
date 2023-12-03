use strict;
use warnings;
use diagnostics;

use feature 'say';

my $filename = 'input.txt';
open(FH, '<', $filename) or die $!;

my @engine;
my $count = 0;

while(<FH>)
{
    push @engine, $_;
    $count++;
}

close(FH);


sub check_valid
{
    my ($i, $j) = @_;
    my $t = $i - 1 >= 0 ? ord (substr $engine[$i - 1], $j, 1) : -1;
    my $r = $j + 1 < (length $engine[$i]) - 1 ? ord (substr $engine[$i], $j + 1, 1) : -1;
    my $b = $i + 1 < scalar @engine ? ord (substr $engine[$i + 1], $j, 1) : -1;
    my $l = $j - 1 >= 0 ? ord (substr $engine[$i], $j - 1, 1) : -1;

    my $tl = $i - 1 >= 0 && $j - 1 >= 0 ? ord (substr $engine[$i - 1], $j - 1, 1) : -1;
    my $tr = $i - 1 >= 0 && $j + 1 < (length $engine[$i - 1]) - 1 ? ord (substr $engine[$i - 1], $j + 1, 1) : -1;
    my $bl = $i + 1 < scalar @engine && $j - 1 >= 0 ? ord (substr $engine[$i + 1], $j - 1, 1) : -1;
    my $br = $i + 1 < scalar @engine && $j + 1 < (length $engine[$i + 1]) - 1 ? ord (substr $engine[$i + 1], $j + 1, 1) : -1;

    if (($l != -1 && $l != ord '.' && ($l < ord '0' || $l > ord '9')) ||
        ($t != -1 && $t != ord '.' && ($t < ord '0' || $t > ord '9')) ||
        ($r != -1 && $r != ord '.' && ($r < ord '0' || $r > ord '9')) ||
        ($b != -1 && $b != ord '.' && ($b < ord '0' || $b > ord '9')) ||
        ($tl != -1 && $tl != ord '.' && ($tl < ord '0' || $tl > ord '9')) ||
        ($tr != -1 && $tr != ord '.' && ($tr < ord '0' || $tr > ord '9')) ||
        ($bl != -1 && $bl != ord '.' && ($bl < ord '0' || $bl > ord '9')) ||
        ($br != -1 && $br != ord '.' && ($br < ord '0' || $br > ord '9'))
        )
    {
        return 1;
    }

    return 0;
}

my $total = 0;
my $size = 1;
for (my $i = 0; $i < $count; $i++)
{
    for (my $j = 0; $j + $size - 1 < length $engine[$i]; $j += $size)
    {
        $size = 1;
        my $valid = 0;
        my @str = substr $engine[$i], $j + $size - 1, 1;
        
        while (ord $str[0] >= ord '0' && ord $str[0] <= ord '9'
            && $size + $j - 1 < length $engine[$i])
        {
            if (check_valid($i, $j + $size - 1))
            {
                $valid = 1;
            }

            $size++;
            if ($j + $size - 1 < length $engine[$i])
            {
                @str = substr $engine[$i], $j + $size - 1, 1;
            }
        }

        if ($size > 1 && $valid)
        {
            say substr $engine[$i], $j, $size - 1;
            $total += substr $engine[$i], $j, $size - 1;
        }
    }
}

say $total;
