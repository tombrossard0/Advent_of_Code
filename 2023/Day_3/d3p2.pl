use strict;
use warnings;
use diagnostics;

use feature 'say';


my %gears = ();


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

sub get_num
{
    my ($i, $j) = @_;

    my $size = 0;
    while ($j - 1 >= 0 && ord (substr $engine[$i], $j - 1, 1) >= ord '0' && ord (substr $engine[$i], $j - 1, 1) <= ord '9')
    {
        $j--;
    }

    $j++;

    while ($j - 1 < length $engine[$i] && ord (substr $engine[$i], $j - 1, 1) >= ord '0' && ord (substr $engine[$i], $j - 1, 1) <= ord '9')
    {
        $j++;
        $size++;
    }

    return (substr $engine[$i], $j - 1 - $size, $size);
}

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

    my $num = get_num($i, $j);

    if ($l == ord '*')
    {
        if (!(exists $gears{($i, $j - 1)}))
        {
            $gears{($i, $j - 1)} = [$num, 0];
        }
        else
        {
            $gears{($i, $j - 1)}[1] = $num;
        }
        return 1;
    }

    if ($t == ord '*')
    {
        if (!(exists $gears{($i - 1, $j)}))
        {
            $gears{($i - 1, $j)} = [$num, 0];
        }
        else
        {
            $gears{($i - 1, $j)}[1] = $num;
        }
        return 1;
    }

    if ($r == ord '*')
    {
        if (!(exists $gears{($i, $j + 1)}))
        {
            $gears{($i, $j + 1)} = [$num, 0];
        }
        else
        {
            $gears{($i, $j + 1)}[1] = $num;
        }
        return 1;
    }

    if ($b == ord '*')
    {
        if (!(exists $gears{($i + 1, $j)}))
        {
            $gears{($i + 1, $j)} = [$num, 0];
        }
        else
        {
            $gears{($i + 1, $j)}[1] = $num;
        }
        return 1;
    }

    if ($tl == ord '*')
    {
        if (!(exists $gears{($i - 1, $j - 1)}))
        {
            $gears{($i - 1, $j - 1)} = [$num, 0];
        }
        else
        {
            $gears{($i - 1, $j - 1)}[1] = $num;
        }
        return 1;
    }

    if ($tr == ord '*')
    {
        if (!(exists $gears{($i - 1, $j + 1)}))
        {
            $gears{($i - 1, $j + 1)} = [$num, 0];
        }
        else
        {
            $gears{($i - 1, $j + 1)}[1] = $num;
        }
        return 1;
    }

    if ($bl == ord '*')
    {
        if (!(exists $gears{($i + 1, $j - 1)}))
        {
            $gears{($i + 1, $j - 1)} = [$num, 0];
        }
        else
        {
            $gears{($i + 1, $j - 1)}[1] = $num;
        }
        return 1;
    }

    if ($br == ord '*')
    {
        if (!(exists $gears{($i + 1, $j + 1)}))
        {
            $gears{($i + 1, $j + 1)} = [$num, 0];
        }
        else
        {
            $gears{($i + 1, $j + 1)}[1] = $num;
        }
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
            if (!$valid && check_valid($i, $j + $size - 1))
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
            
            #say substr $engine[$i], $j, $size - 1;
            #$total += substr $engine[$i], $j, $size - 1;
        }
    }
}

for my $key (keys %gears)
{
    #say "$gears{$key}[0] * $gears{$key}[1]";
    $total += $gears{$key}[0] * $gears{$key}[1];
}

say $total;
