package WWW::FBX::Role::API::APIv3;
use 5.008001;
use Moose::Role;
use WWW::FBX::API;

sub BUILD {
  shift->api_version;
}

fbx_api_method api_version => (
  description => <<'',
Get API version.

  path => 'api_version',
  method => 'GET',
  params => [],
  required => [],
);

after api_version => sub {
  my $uar = shift->uar;
  my ($maj) = $uar->{api_version} =~ /(\d*)\./;
  api_url( "$uar->{api_base_url}v$maj" );
};

fbx_api_method auth_progress => (
  description => <<'',
Monitor token status.

  path => 'login/authorize/42',
  method => 'GET',
  params => [],
  required => [],
);

fbx_api_method login => (
  description => <<'',
Get login challenge.

  path => 'login/',
  method => 'GET',
  params => [],
  required => [],
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

