package WWW::FBX::Role::Auth;
use 5.008001;
use Moose::Role;

sub BUILD {
  my $self=shift;
  shift->api_version;

}

1;
__END__

=encoding utf-8

=head1 NAME

WWW::FBX::Auth - It's new $module

=head1 SYNOPSIS

    use WWW::FBX::Role::Auth;

=head1 DESCRIPTION

WWW::FBX::Role::Auth is FBX Authenticator role

=head1 LICENSE

Copyright (C) Laurent Kislaire.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Laurent Kislaire E<lt>teebeenator@gmail.comE<gt>

=cut

