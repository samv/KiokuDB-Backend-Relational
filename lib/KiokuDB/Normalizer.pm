#!/usr/bin/perl

package KiokuDB::Normalizer;
use Moose::Role;

use Carp qw(croak);

use Moose::Util::TypeConstraints;
use KiokuDB::Relational::Mapping;

use namespace::clean -except => 'meta';

with qw(KiokuDB::Backend::Relational);

has 'mapping' =>
	is => "ro",
	isa => "KiokuDB::Backend::Relational::Mapping",
	coerce => 1,
        default => sub { $_[0]->_default_mapping },
	;

sub _default_mapping {
	my $self = shift;
	KiokuDB::Backend::Relational::Mapping->new(
		classes => $self->classes,
		@_,
	       );
}

has 'classes' =>
	is => "ro",
	isa => "ArrayRef[Class::MOP::Class]",
	required => 1,
	;

requires qw(get_exporter get_importer);

my %types = (
	dbi => "KiokuDB::Normalizer::DBI",
	dbic => "KiokuDB::Normalizer::DBIC",
	gitdb => "KiokuDB::Normalizer::Git::DB",
);

coerce( __PACKAGE__,
	from ArrayRef => via {
		KiokuDB::Normalizer::DBI->new(
			classes => $_,
		},
	},
	from HashRef => via {
		my %args = %$_;
		my $class = $types{lc(delete $args{type})}
			or croak "unknown format: $args{type}";

		Class::MOP::load_class($class);
		$class->new(%args);
	},
);

__PACKAGE__

__END__

=pod

=head1 NAME

KiokuDB::Normalizer - Standalone normalizer object

=head1 SYNOPSIS

 # automatic mapping of classes to tables
 my $normalizer = KiokuDB::Normalizer::Foo->new(
       classes => [ @meta_classes ],
       );

 # get the 'exporter' for a particular schema style
 my $exporter = $normalizer->get_exporter( $object->meta );

 # 'ctx' provides: storage object, dbh, object id, SAVING set?
 my @columns = $exporter->($ctx, $object);

 # for loading, the 'importer'
 my $importer = $normalizer->get_importer( $object->meta );
 my @init_args = $importer->($ctx, @columns);

=head1 DESCRIPTION

This role is for objects which perform the normalization roles (e.g.
L<KiokuDB::Backend::Normalizer::DBIC>) but can be used independently.

This is used by L<KiokuDB::Backend::Relational::Delegate>
