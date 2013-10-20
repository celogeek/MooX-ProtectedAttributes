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

eval { $t->baz };
like $@, qr{\QYou can't use the attribute <baz> outside the package <t::lib::myTestClassRole> !\E}, 'reading baz is forbidden even if redefined';

eval { $t->display_role_bar_direct };
like $@, qr{\QYou can't use the attribute <bar> outside the package <t::lib::myTestClassRole> !\E}, 'reading bar is forbidden even in the main class';


is $t->display_foo, "DISPLAY: 123", "foo can be read from main class";
is $t->display_bar, "DISPLAY: 456", "bar can be read from role class";
is $t->display_baz, "DISPLAY: 789", "baz can be read from role class";
is $t->display_role_bar, "DISPLAY: 456", "bar can be read from role class";

done_testing;