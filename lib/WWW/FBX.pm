package WWW::FBX;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";


1;
__END__

=encoding utf-8

=head1 NAME

WWW::FBX - It's new $module

=head1 SYNOPSIS

    use WWW::FBX;
    my $fbx=WWW::FBX->new('MyAppId', 'MyAppName');
    $fbx->connect;
    eval {
      $fbx->api_foo(user=>'Bar');
    };
    if (my $err=$@) {
      die $@ unless blessed $err && err->isa('WWW::FBX::Error');
      warn "HTTP error $err->status\n" if $err->is_http_error;
      warn "API error $err->error\n" if $err->is_api_error;
    }

=head1 DESCRIPTION

WWW::FBX is a library for communicating with the REST API of the Freebox 6

=head1 LICENSE

Copyright (C) Laurent Kislaire.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Laurent Kislaire E<lt>teebeenator@gmail.comE<gt>

=cut

