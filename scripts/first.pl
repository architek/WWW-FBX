#!/usr/bin/perl
use strict;
use warnings;
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
