# NAME

WWW::FBX - It's new $module

# SYNOPSIS

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

# DESCRIPTION

WWW::FBX is a library for communicating with the REST API of the Freebox 6

# LICENSE

Copyright (C) Laurent Kislaire.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Laurent Kislaire <teebeenator@gmail.com>
