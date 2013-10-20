package t::lib::myTestClassRole;
use Moo::Role;
use MooX::ProtectedAttributes;

protected_has 'bar' => (is => 'rw');

sub display_bar { print shift->bar, "\n" }

1;