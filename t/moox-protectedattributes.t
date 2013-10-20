#!perl
use strict;
use warnings;
use Test::More;

use t::lib::myTestClass;
use t::lib::myTestClass2;

sub run_test {
	my ($main_class, $role) = @_;
	my $t = $main_class->new();
	
	$t->foo("123");
	$t->bar("456");
	
	eval { $t->foo };
	like $@, qr{\QYou can't use the attribute <foo> outside the package <$main_class> !\E}, 'reading foo is forbidden';
	
	eval { $t->bar };
	like $@, qr{\QYou can't use the attribute <bar> outside the package <$role> !\E}, 'reading bar is forbidden';
	
	eval { $t->baz };
	like $@, qr{\QYou can't use the attribute <baz> outside the package <$role> !\E}, 'reading baz is forbidden even if redefined';
	
	eval { $t->display_role_bar_direct };
	like $@, qr{\QYou can't use the attribute <bar> outside the package <$role> !\E}, 'reading bar is forbidden even in the main class';
	
	
	is $t->display_foo, "DISPLAY: 123", "foo can be read from main class";
	is $t->display_bar, "DISPLAY: 456", "bar can be read from role class";
	is $t->display_indirect_bar, "DISPLAY: 456", "bar can be read from role class by indirect call";
	is $t->display_large_indirect_bar, "DISPLAY: 456", "bar can be read from role class by large indirect call";
	is $t->display_baz, "DISPLAY: 789", "baz can be read from role class";
	is $t->display_role_bar, "DISPLAY: 456", "bar can be read from role class";
}

subtest 'class and direct role' => sub {
	run_test('t::lib::myTestClass', 't::lib::myTestClassRole');
};

subtest 'class and indirect role' => sub {
	run_test('t::lib::myTestClass2', 't::lib::myTestClassRole3');

};

done_testing;