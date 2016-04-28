#!/usr/bin/perl
use strict;
use warnings;
use WWW::FBX;

my $fbx = WWW::FBX->new(
  appid => "APP ID", 
  appname => "APP NAME",
  traits => [qw/API::APIv3/],
);

my $res=$fbx->api_version();

use Data::Dumper;
warn Dumper $res;

