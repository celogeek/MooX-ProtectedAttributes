package t::lib::mooWithDeprecated::myTestClass;
use Moo;
use MooX::ProtectedAttributes;
with 't::lib::mooWithDeprecated::myTestClassRole';

protected_with_deprecated_has 'foo' => (is => 'rw');

sub baz { 789 }

sub display_foo { "DISPLAY: " . shift->foo }
sub display_role_bar { shift->display_bar }
sub display_role_bar_direct { "DISPLAY: " . shift->bar }

sub display_indirect_bar { shift->display_role_bar }
sub display_large_indirect_bar { shift->display_indirect_bar }

1;
