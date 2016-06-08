#!/usr/bin/perl
use strict;
use warnings;
use Scalar::Util "blessed";
use Storable;
use WWW::FBX;

my $store = 'app_token';
my $res;
my $conn = {
    app_id => "APP ID",
    app_name => "APP NAME",
    app_version => "1.0",
    device_name => "debian",
};

eval {

  if (-f $store) {
    my $token = retrieve $store;
    %$conn = ( %$conn, %$token );
    print "Retrieved track_id and app_token from $store\n";
  } else {
    print "No stored token found\n";
  }
  my $fbx = WWW::FBX->new( $conn );
  unless ( -f $store ) {
    print "Storing token in current directory for further usage [ track_id = ", $fbx->track_id, " app_token = ", $fbx->app_token, " ]\n";
    print "You can add the remaining permissions by connecting on the web interface\n";
    store { track_id => $fbx->track_id, app_token => $fbx->app_token }, $store;
  }

  print "App permissions are:\n";
  while ( my( $key, $value ) = each %{ $fbx->uar->{result}{permissions} } ) {
    print "\t $key\n" if $value;
  }

  $res = $fbx->connection;
  print "Your ", $res->{media}, " internet connection state is ", $res->{state}, "\n";
};

if ( my $err = $@ ) {
    die $@ unless blessed $err && $err->isa('WWW::FBX::Error');
 
    warn "HTTP Response Code: ", $err->code, "\n",
         "HTTP Message......: ", $err->message, "\n",
         "API Error.........: ", $err->error, "\n",
         "Error Code........: ", $err->fbx_error_code, "\n",
}
