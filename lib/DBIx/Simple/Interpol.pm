use 5.006;
use strict;
no warnings;

package DBIx::Simple::Interpol;

# ABSTRACT: monkey-patch DBIx::Simple to use SQL::Interpol

BEGIN {
	require SQL::Interpol;
	require DBIx::Simple;
	die 'Cannot find method to patch' if not DBIx::Simple->can( 'iquery' );
	*DBIx::Simple::iquery = sub {
		use warnings; # limited scope to avoid "Subroutine redefined"
		my $self = shift;
		my $p = SQL::Interpol::Parser->new;
		my $sql = $p->parse( @_ );
		return $self->query( $sql, @{ $p->bind } );
	};
}

sub import {
	shift;
	my $prelude = sprintf qq'package %s;\n#line %d "%s"\n', ( caller )[0,2,1];
	my $sub = eval qq{ sub { $prelude SQL::Interpol->import(\@_) } };
	&$sub;
}

1;

__END__

=head1 SYNOPSIS

  use DBIx::Simple::Interpol;
  # ...
  my $rows = $db->iquery( '
      SELECT title
      FROM threads
      WHERE date >', \$x, '
      AND subject IN', \@subjects, '
  ' )->arrays;

=head1 DESCRIPTION

The recommended way to use L<SQL::Interpol> is via its L<DBIx::Simple>
integration, which provides an excellent alternative to plain DBI access.

Ordinarily, the C<iquery> method in L<DBIx::Simple> integrates L<SQL::Interp>.
But by loading this module instead (or after) L<DBIx::Simple>, the C<iquery>
method will be patched to use L<SQL::Interpol> instead.

This is all there is to this module.
