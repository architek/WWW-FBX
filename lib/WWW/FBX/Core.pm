package WWW::FBX::Core;
use 5.008001;
use Moose;
use Carp::Clan qw/^(?:Net::Twitter|Moose|Class::MOP)/;
use JSON::MaybeXS;
use URI::Escape;
use HTTP::Request::Common;
use WWW::FBX::Error;
use Encode qw/encode_utf8/;
use Data::Visitor::Callback;
use Try::Tiny;
use LWP::UserAgent;

with 'WWW::FBX::Role::API::APIv3';
 
use namespace::autoclean;

my $fixed_version="1.0";

has lwp_args  => ( isa => 'HashRef', is => 'ro', default => sub { {} } );
has username        => ( isa => 'Str', is => 'rw', predicate => 'has_username' );
has password        => ( isa => 'Str', is => 'rw', predicate => 'has_password' );
has ua              => ( isa => 'Object', is => 'rw', lazy => 1, builder => '_build_ua' );
has clientname      => ( isa => 'Str', is => 'ro', default => 'Perl WWW::FBX' );
has clientver       => ( isa => 'Str', is => 'ro', default => $fixed_version );
has _base_url       => ( is => 'rw' ); ### keeps role composition from bitching ??
has _json_handler   => (
    is      => 'rw',
    default => sub { JSON->new->allow_nonref->utf8 },
    handles => { from_json => 'decode' },
);
 
sub _natural_args {
    my ( $self, $args ) = @_;
 
    map { $_ => $args->{$_} } grep !/^-/, keys %$args;
}
 
around BUILDARGS => sub {
    my $next    = shift;
    my $class   = shift;
 
    my %options = @_ == 1 ? %{$_[0]} : @_;
 
    return $next->($class, \%options);
};
 
sub _build_ua {
    my $self = shift;
 
    my $ua = LWP::UserAgent->new(%{$self->lwp_args});
 
    return $ua;
}
 
sub _encode_args {
    my ($self, $args) = @_;
 
    # Values need to be utf-8 encoded.  Because of a perl bug, exposed when
    # client code does "use utf8", keys must also be encoded.
    # see: http://www.perlmonks.org/?node_id=668987
    # and: http://perl5.git.perl.org/perl.git/commit/eaf7a4d2
    return { map { utf8::upgrade($_) unless ref($_); $_ } %$args };
}
 
sub _json_request {
    my ($self, $http_method, $uri, $args, $content_type ) = @_;
 
    my $msg = $self->_prepare_request($http_method, $uri, $args, $content_type);
    my $res = $self->_send_request($msg);
 
    return $self->_parse_result($res, $args);
}
 
sub _prepare_request {
    my ($self, $http_method, $uri, $args, $content_type ) = @_;
 
    my $msg;
 
    my %natural_args = $self->_natural_args($args);
 
    $self->_encode_args(\%natural_args);
    if( $http_method eq 'PUT' ) {
        $msg = PUT(
            $uri,
            'Content-Type' => 'application/x-www-form-urlencoded',
            Content        => $self->_query_string_for( \%natural_args ) );
    }
    elsif ( $http_method =~ /^(?:GET|DELETE)$/ ) {
        $uri->query($self->_query_string_for(\%natural_args));
        $msg = HTTP::Request->new($http_method, $uri);
    }
    elsif ( $http_method eq 'POST' ) {
        if( $content_type && $content_type eq 'application/json' ) {
            $msg = POST( $uri,  Content_Type => 'application/json', Content =>  encode_json \%natural_args );
        }
        else {
            die;
        }
    }
    else {
        croak "unexpected HTTP method: $http_method";
    }
 
    return $msg;
}
 
# Make sure we encode arguments *exactly* the same way Net::OAuth does
# ...by letting Net::OAuth encode them.
sub _query_string_for {
    my ( $self, $args ) = @_;

    my @pairs;
    while ( my ($k, $v) = each %$args ) {
        push @pairs, join '=', map URI::Escape::uri_escape_utf8($_,'^\w.~-'), $k, $v;
    }

    return join '&', @pairs;
}

sub _send_request { shift->ua->request(shift) }
 
sub _parse_result {
    my ($self, $res, $args) = @_;
 
    my $content = $res->content;
 
    my $obj = length $content ? try { $self->from_json($content) } : {};
 
    return $obj if $res->is_success && defined $obj;
 
    my $error = WWW::FBX::Error->new(http_response => $res);
#    $error->twitter_error($obj) if ref $obj;
 
    die $error;
}
 
1;
__END__

=encoding utf-8

=head1 NAME

WWW::FBX::Core - It's new $module

=head1 SYNOPSIS

    use WWW::FBX::Core;

=head1 DESCRIPTION

WWW::FBX::Core is FBX core

=head1 LICENSE

Copyright (C) Laurent Kislaire.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Laurent Kislaire E<lt>teebeenator@gmail.comE<gt>

=cut

