# NAME

WWW::FBX - A perl interface to the Freebox v6 Rest API

# FREEBOX SDK API 3.0

This version provides the API 3.0 support through the APIv3 role but other version can be provided by creating a new role.

# AUTHENTICATION

Authentication is provided through the Auth role but other authentication mechanism can be provided by creating a new role.

# SYNOPSIS

       use WWW::FBX;
       use Scalar::Util 'blessed';

       my $res;
       eval { 
           my $fbx = WWW::FBX->new( 
               app_id => "APP ID", 
               app_name => "APP NAME", 
               app_version => "1.0", 
               device_name => "debian", 
               track_id => "48", 
               app_token => "2/g43EZYD8AO7tbnwwhmMxMuELtTCyQrV1goMgaepHWGrqWlloWmMRszCuiN2ftp",
           );
           print "You are now authenticated with track_id ", $fbx->track_id, " and app_token ", $fbx->app_token, "\n"; 
           print "App permissions are:\n";
           while ( my( $key, $value ) = each %{ $fbx->uar->{result}{permissions} } ) {
               print "\t $key\n" if $value;
           }

           $res = $fbx->connection;
           print "Your ", $res->{result}{media}, " internet connection state is ", $res->{result}{state}, "\n";
       };

       if ( my $err = $@ ) {
           die $@ unless blessed $err && $err->isa('WWW::FBX::Error');
    
           warn "HTTP Response Code: ", $err->code, "\n",
                "HTTP Message......: ", $err->message, "\n",
                "API Error.........: ", $err->error, "\n",
                "Error Code........: ", $err->fbx_error_code, "\n",
       }

# DESCRIPTION

This module provides a perl interface to the freebox v6 APIs. See [http://dev.freebox.fr/sdk/os/](http://dev.freebox.fr/sdk/os/) for a full description of the APIs.

# METHODS AND ARGUMENTS

Mandatory constructor parameters are app\_id, app\_name, app\_version, device\_name.

When track\_id and app\_token are also provided, they will be used to authenticate.
Otherwise, new track\_id and app\_token will be given by the freebox. These can be then used for later access.
Note that adding the settings permission is only possible through the web interface (Param�tres de la Freebox -> Gestion des acc�s -> Applications)

The constructor takes care of detecting the API version and authentication.

Return values are perl hashes.

The same response is also available through the uar method.

# LICENSE

Copyright (C) Laurent Kislaire.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Laurent Kislaire <teebeenator@gmail.com>
