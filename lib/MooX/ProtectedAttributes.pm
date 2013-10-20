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

=head1 SYNOPSIS

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

=method import

The method provide 2 methods :

=over

=item protected_has

Like a "has", disable read access outside the current class.

=item protected_with_deprecated_has

Instead of dying, it will display a DEPRECATED message and run as usual.
This allow you to alert user of the protected method to fix their program before you forbid the access to the attribute.

=back

=cut

sub import {
    my $target = caller;

    return if $target->can('protected_has') && $target->can('protected_with_deprecated_has');	

    my $around = $target->can('around');
    my $has    = $target->can('has');

    my $minimum_caller_level = 2;

    my $ensure_call_in_target = sub {
    	my ($name, $deprecated_mode) = @_;
    	return sub {
	    	my $orig = shift;
	    	my $self = shift;
	    	my @params = @_;
	
	    	return $self->$orig(@params) if @params; #write is permitted
	
	    	my $caller_level = $minimum_caller_level;
	    	while(my $secure_caller = caller($caller_level++)) {
	    		return $self->$orig if $secure_caller eq $target;
	    	}
			if ($deprecated_mode) {
	    		carp "DEPRECATED: You can't use the attribute <$name> outside the package <$target> !";
	    		return $self->$orig;
			} else {
	    		croak "You can't use the attribute <$name> outside the package <$target> !";
	    	}
	    }
    };

    my $protected_has = sub {
    	my ($name,  %attributes) = @_;

    	$has->($name, %attributes);
    	$around->($name, $ensure_call_in_target->($name));
    };

    my $protected_with_deprecated_has = sub {
    	my ($name,  %attributes) = @_;

    	$has->($name, %attributes);
    	$around->($name, $ensure_call_in_target->($name, 1));
    };

    { no strict 'refs'; *{"${target}::protected_has"} = $protected_has }
    { no strict 'refs'; *{"${target}::protected_with_deprecated_has"} = $protected_with_deprecated_has }

	return;
}

1;
