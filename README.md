<div>
    <a href="https://travis-ci.org/architek/WWW-FBX"><img src="https://travis-ci.org/architek/WWW-FBX.svg?branch=master"></a>
</div>

# NAME

WWW::FBX - Freebox v6 OS Perl Interface

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
            device_name => "MY DEVICE",
            track_id => "48",
            app_token => "2/g43EZYD8AO7tbnwwhmMxMuELtTCyQrV1goMgaepHWGrqWlloWmMRszCuiN2ftp",
            base_url => "http://12.34.56.78:3333",
            debug => 1,
        );
        print "You are now authenticated with track_id ", $fbx->track_id, " and app_token ", $fbx->app_token, "\n";
        print "App permissions are:\n";
        while ( my( $key, $value ) = each %{ $fbx->uar->{result}{permissions} } ) {
            print "\t $key\n" if $value;
        }

        $res = $fbx->connection;
        print "Your ", $res->{media}, " internet connection state is ", $res->{state}, "\n";
        $fbx->set_ftp_config( {enabled => \1} );
        $fbx->reset_freeplug( "F4:CA:E5:DE:AD:BE/reset" );
    };

    if ( my $err = $@ ) {
        die $@ unless blessed $err && $err->isa('WWW::FBX::Error');

        warn "HTTP Response Code: ", $err->code, "\n",
             "HTTP Message......: ", $err->message, "\n",
             "API Error.........: ", $err->error, "\n",
             "Error Code........: ", $err->fbx_error_code, "\n",
    }

# DESCRIPTION

This module provides a perl interface to the [Freebox](https://en.wikipedia.org/wiki/Freebox#V6_generation.2C_Freebox_Revolution) v6 APIs. 

See [http://dev.freebox.fr/sdk/os/](http://dev.freebox.fr/sdk/os/) for a full description of the APIs.

# METHODS AND ARGUMENTS

    my $fbx = WWW::FBX->new( app_id => "APP ID", app_name => "APP NAME",
                             app_version => "1.0", device_name => "device" );

    my $fbx = WWW::FBX->new( app_id => "APP ID", app_name => "APP NAME",
                             app_version => "1.0", device_name => "device", 
                             track_id => "48", app_token => "2/g43EZYD8AO7tbnwwhmMxMuELtTCyQrV1goMgaepHWGrqWlloWmMRszCuiN2ftp",
                             base_url => "http://12.34.56.78:3333" ,
                             debug => 1 );

Mandatory constructor parameters are app\_id, app\_name, app\_version, device\_name. 
When track\_id and app\_token are also provided, they will be used to authenticate.
Otherwise, new track\_id and app\_token will be given by the freebox. These can be then used for later access.
base\_url defaults to http://mafreebox.free.fr which is the base uri when accessing the freebox from the LAN side.

Note that adding the _settings_ or _parental_ permissions is only possible through the web interface (Paramètres de la Freebox -> Gestion des accès -> Applications)

The constructor takes care of detecting the API version and authentication.

The return value of all api methods is the [result](http://dev.freebox.fr/sdk/os/#APIResponse.result) structure of APIResponse, or undef if no result is returned.

The full json response of the last request is available through the uar method (usefull when using the _new_ method) and the complete HTTP::Response is available through the uarh method.

Api methods will _die_ if the APIResponse is an error. It is up to the caller to handle this exception.

# QUICK START

The list of currently available services implemented in this module is given in [WWW::FBX::Role::API::APIv3](https://metacpan.org/pod/WWW::FBX::Role::API::APIv3).

A script called fbx\_test.pl is provided in script to show how to send commands and handle exceptions. 

It can also be used standalone to get tokens and send a command.

On first call, you will be requested to physically authenticate on the freebox itself. Once done, the token is stored in the current directory in a file called app\_token. You can then grant all permissions on the freebox web interface to allow all commands.

When suffix parameter is required, pass it as a normal parameter.

When more parameters are required, it is possible to send a json structure, see EXAMPLES. You need to escape the accolades though.

# EXAMPLES

    fbx-test.pl --help
    fbx-test.pl connection
    fbx-test.pl system
    fbx-test.pl call_log
    fbx-test.pl call_log 2053
    fbx-test.pl reboot
    fbx-test.pl reset_freeplug F4:CA:42:22:53:EF/reset
    fbx-test.pl cp '{"files":["Disque dur/ds.txt"], "dst":"Disque dur/Temp", "mode":"both"}'

# LICENSE

Copyright (C) Laurent Kislaire.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Laurent Kislaire <teebeenator@gmail.com>
