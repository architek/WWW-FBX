package WWW::FBX::Role::API::APIv3;
use 5.008001;
use Moose::Role;
use WWW::FBX::API;

#sub BUILD {
#  shift->api_version;
#}

fbx_api_method api_version => (
  description => <<'',
Get API version.

  path => 'api_version',
  method => 'GET',
  params => [],
  required => [],
);

around api_version => sub {
  my $orig = shift;
  my $self = shift;
  
  api_url( "" );
  $self->$orig;
  my $uar = $self->uar;
  my ($maj) = $uar->{api_version} =~ /(\d*)\./;
  api_url( "$uar->{api_base_url}v$maj" );
};

fbx_api_method req_auth => (
  description => <<'',
Ask for an App token.

  path => 'login/authorize',
  method => 'POST',
  params => [qw/ app_id app_name app_version device_name /],
  required => [qw/ app_id app_name app_version device_name /],

);

fbx_api_method auth_progress => (
  description => <<'',
Monitor token status.

  path => 'login/authorize/',
  method => 'GET',
  params => [qw/suff/],
  required => [qw/suff/],
);

fbx_api_method login => (
  description => <<'',
Get login challenge.

  path => 'login/',
  method => 'GET',
  params => [],
  required => [],
);

fbx_api_method open_session => (
  description => <<'',
Open a session.

  path => 'login/session/',
  method => 'POST',
  params => [ qw/ app_id app_version password / ],
  required => [ qw/ app_id password / ],
);

fbx_api_method connection => (
  description => <<'',
Connection settings.

  path => 'connection/',
  method => 'GET',
  params => [],
  required => [],
);

1;
__END__

=encoding utf-8

=head1 NAME

WWW::FBX::Role::API::APIv3 - Freebox API v3

=head1 SYNOPSIS

    with 'WWW::FBX::Role::API::APIv3';

=head1 DESCRIPTION

WWW::FBX::Role::API::APIv3 is the freebox6 API version 3 as a Moose Role

=head1 LICENSE

Copyright (C) Laurent Kislaire.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Laurent Kislaire E<lt>teebeenator@gmail.comE<gt>

=cut

