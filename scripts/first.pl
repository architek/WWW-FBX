#!/usr/bin/perl
use strict;
use warnings;
use WWW::FBX;
use Scalar::Util 'blessed';
my $res;

use Data::Dumper;

my $fbx = WWW::FBX->new(
  appid => "APP ID", 
  appname => "APP NAME",
  traits => [qw/API::APIv3/],
);

#$res=$fbx->api_version;
#warn Dumper $res;

#$res=$fbx->auth_progress;
#warn Dumper $res;

#$res=$fbx->login;
#warn Dumper $res;

eval {
  $res=$fbx->connection;
};

if ( my $err = $@ ) {
    die $@ unless blessed $err && $err->isa('WWW::FBX::Error');
 
    warn "HTTP Response Code: ", $err->code, "\n",
         "HTTP Message......: ", $err->message, "\n",
         "API Error.........: ", $err->error, "\n",
}
