package XML::IODEF;

use 5.008008;
use strict;
use warnings;

our $VERSION = '0.11_3';

use XML::Compile::Schema;
use XML::Compile::Util qw/pack_type/;
use XML::LibXML;
use Data::Dumper;

XML::Compile->addSchemaDirs(__FILE__);

sub new {
    my $class = shift;
    my $args = shift; 
    my $self = {};
    bless($self,$class);

    my $type    = pack_type 'urn:ietf:params:xml:ns:iodef-1.0', 'IODEF-Document';
    my $s       = XML::Compile::Schema->new('iodef.xsd');
    my $doc     = XML::LibXML::Document->new('1.0', 'UTF-8');
    my $writer  = $s->compile(WRITER => $type, prefixes => [ iodef => 'urn:ietf:params:xml:ns:iodef-1.0' ]);
    $self->writer($writer);

    return($self);
}

sub out {
    my $self 	= shift;
    my $hash    = shift;
    my $pretty  = shift || 0; 
    my $doc     = XML::LibXML::Document->new('1.0', 'UTF-8');
    my $xml     = $self->writer->($doc, $hash);
    return $xml->toString($pretty);
}

sub writer {
    my ($self,$v) = @_;
    $self->{'_writer'} = $v if(defined($v));
    return $self->{'_writer'};
}

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

XML::IODEF - Perl extension for blah blah blah

=head1 SYNOPSIS

  use XML::IODEF;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for XML::IODEF, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

wes, E<lt>wes@apple.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by wes

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
