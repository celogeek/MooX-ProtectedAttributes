#!perl
use strict;
use warnings;
use Test::More;

use t::lib::moo::myTestClass;
use t::lib::moo::myTestClass2;

use t::lib::moose::myTestClass;
use t::lib::moose::myTestClass2;

sub run_test {
	my ($subtest_name, $main_class, $role) = @_;

	subtest $subtest_name => sub {

		my $t = $main_class->new();
		
		$t->foo("123");
		$t->bar("456");
		
		$t->baz("789"); # moo keep the sub instead of replacing it like moose
		
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
}

run_test('moo class and direct role', 't::lib::moo::myTestClass', 't::lib::moo::myTestClassRole');
run_test('moo class and indirect role', 't::lib::moo::myTestClass2', 't::lib::moo::myTestClassRole3');

run_test('moose class and direct role', 't::lib::moose::myTestClass', 't::lib::moose::myTestClassRole');
run_test('moose class and indirect role', 't::lib::moose::myTestClass2', 't::lib::moose::myTestClassRole3');


done_testing;