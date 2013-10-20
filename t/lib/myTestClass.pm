package t::lib::myTestClass;
use Moo;
use MooX::ProtectedAttributes;
with 't::lib::myTestClassRole';

protected_has 'foo' => (is => 'rw');

sub baz { 789 }

sub display_foo { "DISPLAY: " . shift->foo }
sub display_role_bar { shift->display_bar }
sub display_role_bar_direct { "DISPLAY: " . shift->bar }
1;