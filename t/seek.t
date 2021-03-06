use warnings;
use strict;

use Test::More tests => 36;

my $test_input = "\x01\x02\x04\x08\x10\x20\x40\x80" .
	"\x92\x07\x58\x97\x0c\x21\xd5\x82\xc8\xb8\xec\xe8\xb2\x85\x1e\x4c";
my $out;
my $f;

open($f, "<:bitswap(4)", \$test_input);
$/ = \1;
is scalar(<$f>), "\x10";
is scalar(<$f>), "\x20";
is scalar(<$f>), "\x40";
ok seek($f, 5, 0);
is scalar(<$f>), "\x02";
ok seek($f, -3, 1);
is scalar(<$f>), "\x80";
ok seek($f, -19, 2);
is scalar(<$f>), "\x02";
$f = undef;

open($f, "<:bitswap(24)", \$test_input);
$/ = \1;
is scalar(<$f>), "\x08";
is scalar(<$f>), "\x04";
is scalar(<$f>), "\x02";
is scalar(<$f>), "\x01";
ok seek($f, 12, 0);
is scalar(<$f>), "\x82";
is scalar(<$f>), "\xd5";
is scalar(<$f>), "\x21";
is scalar(<$f>), "\x0c";
ok seek($f, -8, 1);
is scalar(<$f>), "\x97";
is scalar(<$f>), "\x58";
is scalar(<$f>), "\x07";
is scalar(<$f>), "\x92";
ok seek($f, -8, 2);
is scalar(<$f>), "\xe8";
is scalar(<$f>), "\xec";
is scalar(<$f>), "\xb8";
is scalar(<$f>), "\xc8";
$f = undef;

$out = "";
open($f, ">:bitswap(4)", \$out);
print $f "\x10\xaa\x40\xbb\x01\xcc\x04\x08";
ok seek($f, 3, 0);
print $f "\x80";
ok seek($f, -3, 1);
print $f "\x20";
ok seek($f, -3, 2);
print $f "\x02";
$f = undef;
is $out, "\x01\x02\x04\x08\x10\x20\x40\x80";

$out = "";
open($f, ">:bitswap(24)", \$out);
print $f "\x08";
print $f "\x04";
print $f "\x02";
print $f "\x01";
print $f "\x80";
print $f "\x40";
print $f "\x20";
print $f "\x10";
print $f "\xaa";
print $f "\xaa";
print $f "\xaa";
print $f "\xaa";
print $f "\xcc";
print $f "\xcc";
print $f "\xcc";
print $f "\xcc";
print $f "\xbb";
print $f "\xbb";
print $f "\xbb";
print $f "\xbb";
print $f "\x4c";
print $f "\x1e";
print $f "\x85";
print $f "\xb2";
ok seek($f, 16, 0);
print $f "\xe8";
print $f "\xec";
print $f "\xb8";
print $f "\xc8";
ok seek($f, -12, 1);
print $f "\x97";
print $f "\x58";
print $f "\x07";
print $f "\x92";
ok seek($f, -12, 2);
print $f "\x82";
print $f "\xd5";
print $f "\x21";
print $f "\x0c";
$f = undef;
is $out, $test_input;

1;
