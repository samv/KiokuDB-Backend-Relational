
package KiokuDB::Backend::Relational::DBI;

# in KiokuDB
sub default_typemap {

}

sub exists {  # returns a list?  @values?
	my $id = shift;
}

# ... see KiokuDB::simple_search
sub simple_search {
	# ... passing in live_objects
}
sub simple_search_filter {
}

# ... see KiokuDB::backend_search
sub search {
	# ... passing in live_objects
}

# ... see KiokuDB::root_set, ::all_objects
sub root_entries {
	# ... passing in live_objects
}
sub all_entires {
	# ... passing in live_objects
}

# ... see KiokuDB::Collapser::Buffer::insert_to_backend
method insert( @entries ) {
}

# ... see KiokuDB::delete
method delete( @ids_or_entries ) {
}

# ... see KiokuDB::txn_db
method txn_do( CodeRef $code, %args ) {
}

# ... see KiokuDB::Linker::load_entries
method get( @ids ) {
}



1;
