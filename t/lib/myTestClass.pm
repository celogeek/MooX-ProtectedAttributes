package t::lib::myTestClass;
use Moo;
use MooX::ProtectedAttributes;
with 't::lib::myTestClassRole';

protected_has 'foo' => (is => 'rw');

sub display_foo { print shift->foo, "\n" }
sub display_role_bar { shift->display_bar }
sub display_role_bar_direct { print shift->bar, "\n" }
1;