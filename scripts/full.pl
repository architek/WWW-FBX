#!/usr/bin/perl
use strict;
use warnings;
use WWW::FBX;
use Scalar::Util 'blessed';
use Data::Dumper;

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

  #LAN
#  $res = $fbx->get_lan_config;
#  $res = $fbx->browse_lan_interface;
  $res = $fbx->list_hosts({suff => "pub"});
#  $res = $fbx->list_hosts({suff => "pub/ether-f4:ca:e5:70:f2:4d"});
#  $res = $fbx->connection_config;
#  $res = $fbx->connection_config_ipv6;
#  $res = $fbx->connection_config_xdsl;
#  $res = $fbx->connection_config_ftth;
#  Dyndns Status
#  $res = $fbx->connection_dyndns({suff=>"noip/status/"});
#  Dyndns Config
#  $res = $fbx->connection_dyndns({suff=>"noip/"});
#  $res = $fbx->freeplugs_net;
#  $res = $fbx->freeplugs_net({suff=>"F4:CA:E5:30:16:79"});
#  $res = $fbx->reset_freeplug({suff=>"F4:CA:E5:30:16:79/reset/"});
#  $res = $fbx->wifi_config;
#  $res = $fbx->wifi_ap;
#  $res = $fbx->wifi_bss;
#  $res = $fbx->ftp_config;
#  $fbx->set_ftp_config({enabled=>\1, });
#  $res = $fbx->ftp_config;

  print Dumper $res;
};

if ( my $err = $@ ) {
    die $@ unless blessed $err && $err->isa('WWW::FBX::Error');
 
    warn "HTTP Response Code: ", $err->code, "\n",
         "HTTP Message......: ", $err->message, "\n",
         "API Error.........: ", $err->error, "\n",
         "Error Code........: ", $err->fbx_error_code, "\n",
}
