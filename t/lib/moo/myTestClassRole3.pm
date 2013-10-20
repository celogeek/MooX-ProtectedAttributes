package t::lib::moo::myTestClassRole3;
use Moo::Role;
use MooX::ProtectedAttributes;

protected_has 'bar' => (is => 'rw');
protected_has 'baz' => (is => 'rw');

sub display_bar { "DISPLAY: " . shift->bar }
sub display_baz { "DISPLAY: " . shift->baz }

1;