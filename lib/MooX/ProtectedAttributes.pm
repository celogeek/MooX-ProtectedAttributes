package MooX::ProtectedAttributes;

# ABSTRACT: Create attribute only usable inside your package

use strict;
use warnings;
# VERSION

sub import {
	my $caller = caller;

	return;
}

1;
