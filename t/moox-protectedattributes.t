#!perl
use strict;
use warnings;
use Test::More;

use t::lib::myTestClass;

my $t = t::lib::myTestClass->new();

$t->foo("123");
$t->bar("456");

eval { $t->foo };
like $@, qr{\QYou can't use the attribute <foo> outside the package <t::lib::myTestClass> !\E}, 'reading foo is forbidden';

eval { $t->bar };
like $@, qr{\QYou can't use the attribute <bar> outside the package <t::lib::myTestClassRole> !\E}, 'reading bar is forbidden';


done_testing;