
package KiokuDB::Backend::Relational;
use Moose::Role;

use Moose::Util::TypeConstraints;

use namespace::clean -except => 'meta';

requires qw(get_exporter deserialize);

my %types = (
    dbi => "KiokuDB::Normalizer::DBI",
    dbic => "KiokuDB::Normalizer::DBIC",
    gitdb => "KiokuDB::Serializer::Git::DB",
);

coerce( __PACKAGE__,
    from Str => via {
        my $class = $types{lc($_)};
        Class::MOP::load_class($class);
        $class->new;
    },
    from HashRef => via {
        my %args = %$_;
        my $class = $types{lc(delete $args{format})};
        Class::MOP::load_class($class);
        $class->new(%args);
    },
);

__PACKAGE__

__END__

=pod

=head1 NAME

KiokuDB::Backend::Relational - Relational role for backends

=head1 SYNOPSIS

    package KiokuDB::Backend::Relational::Foo;
    use Moose::Role;

    use Foo;

    use namespace::clean -except => 'meta';

    with qw(KiokuDB::Backend::Relational);

    sub normalize {
        my ( $self, $entry ) = @_;

        Foo::serialize($entry)
    }

    sub deserialize {
        my ( $self, $blob ) = @_;

        Foo::deserialize($blob);
    }

=head1 DESCRIPTION

This role provides provides a consistent way to use serialization modules to
handle backend serialization.

See L<KiokuDB::Backend::Serialize::Storable>,
L<KiokuDB::Backend::Serialize::YAML> and L<KiokuDB::Backend::Serialize::JSON>
for examples.

=head1 REQUIRED METHODS

=over 4

=item serializate $entry

Takes a L<KiokuDB::Entry> as an argument. Should return a value suitable for
storage by the backend.

=item deserialize $blob

Takes whatever C<serializate> returned and should inflate and return a
L<KiokuDB::Entry>.

=back
