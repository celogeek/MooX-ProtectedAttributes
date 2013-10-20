package t::lib::mooseWithDeprecated::myTestClassRole3;
use Moose::Role;
use MooX::ProtectedAttributes;

protected_with_deprecated_has 'bar' => (is => 'rw');
protected_with_deprecated_has 'baz' => (is => 'rw');

sub display_bar { "DISPLAY: " . shift->bar }
sub display_baz { "DISPLAY: " . shift->baz }

1;
