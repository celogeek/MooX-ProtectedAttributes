package MooX::ProtectedAttributes;

# ABSTRACT: Create attribute only usable inside your package

=head1 DESCRIPTION

It happen that you may want to be able to create a class with private attribute that cannot be used outside this package.

For exemple, you want to create in lazy, a DB connection, but you want to handle it in your class in a certain way (with possible handle of errors ....).
You really want even with the "_" before your attribute, to allow any other package to use this directly.

The goal of this package is to allow the init of the private attribute, but forbid reading from outside the package.

With a protected attribute named "foo" for example, you cannot do this outside the current package :

  my $foo = $myObj->foo;

or

  $myObj->foo->stuff();

But this method is allowed inside the package where it has been declared.

= SYNOPSIS

You can use it in a role (Moo, Moose, Mo with a trick)

  package myRole;
  use Moo::Role;
  use MooX::ProtectedAttributes;

  protected_has 'foo' => (is => 'ro');

  sub display_foo { print shift->foo, "\n" }

  1;

Or also directly in you class

  package myApp;
  use Moo;
  use MooX::ProtectedAttributes;

  protected_has 'bar' => (is => 'ro');

  sub display_bar { print shift->bar, "\n" }

  1;

Then

  myApp->bar("123");
  myApp->bar         # croak
  myApp->display_bar # 123

=cut

use strict;
use warnings;
# VERSION
use Carp;

sub import {
    my $target = caller;

    my $around = $target->can('around');
    my $has    = $target->can('has');

    my @target_isa;
    { no strict 'refs'; @target_isa = @{"${target}::ISA"} };

    my $minimum_caller_level = @target_isa ? 1 : 2;

    my $ensure_call_in_target = sub {
    	my ($name) = @_;
    	return sub {
	    	my $orig = shift;
	    	my $self = shift;
	    	my @params = @_;
	
	    	return $self->$orig(@params) if @params; #write is permitted
	
	    	my $caller_level = $minimum_caller_level;
	    	while(my $secure_caller = caller($caller_level++)) {
	    		carp "$secure_caller vs $target";
	    		return $self->$orig if $secure_caller eq $target;
	    	}
	
	    	croak "You can't use the attribute $name outside the package $target !";
	    }
    };

    my $protected_has = sub {
    	my ($name,  %attributes) = @_;

    	$has->($name, %attributes);
    	$around->($name, $ensure_call_in_target->($name));
    };

    { no strict 'refs'; *{"${target}::protected_has"} = $protected_has }

	return;
}

1;
