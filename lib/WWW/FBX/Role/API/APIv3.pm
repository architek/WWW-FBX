package WWW::FBX::Role::API::APIv3;
use 5.008001;
use Moose::Role;
use WWW::FBX::API;

#sub BUILD {
#  shift->api_version;
#}

fbx_api_method api_version => (
  description => <<'',
Get API version.

  path => 'api_version',
  method => 'GET',
  params => [],
  required => [],
);

around api_version => sub {
  my $orig = shift;
  my $self = shift;
  
  api_url( "" );
  $self->$orig;
  my $uar = $self->uar;
  my ($maj) = $uar->{api_version} =~ /(\d*)\./;
  api_url( "$uar->{api_base_url}v$maj" );
};

fbx_api_method req_auth => (
  description => <<'',
Ask for an App token.

  path => 'login/authorize',
  method => 'POST',
  params => [qw/ app_id app_name app_version device_name /],
  required => [qw/ app_id app_name app_version device_name /],

);

fbx_api_method auth_progress => (
  description => <<'',
Monitor token status.

  path => 'login/authorize/',
  method => 'GET',
  params => [qw/suff/],
  required => [qw/suff/],
);

fbx_api_method login => (
  description => <<'',
Get login challenge.

  path => 'login/',
  method => 'GET',
  params => [],
  required => [],
);

fbx_api_method open_session => (
  description => <<'',
Open a session.

  path => 'login/session/',
  method => 'POST',
  params => [ qw/ app_id app_version password / ],
  required => [ qw/ app_id password / ],
);

#Download
fbx_api_method s'/'_'gr => (
  description => <<'',
Global download getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(downloads/ downloads/stats);

fbx_api_method get_download_task => (
  description => <<'',
Get the download task.

  path => 'downloads/',
  method => 'GET',
  params => [ qw/suff/ ],
  required => [ qw/suff/ ],
);

fbx_api_method del_download_task => (
  description => <<'',
Get the download task.

  path => 'downloads/',
  method => 'DELETE',
  params => [ qw/suff/ ],
  required => [ qw/suff/ ],
);

fbx_api_method upd_download_task => (
  description => <<'',
Update the download task.

  path => 'downloads/',
  method => 'PUT',
  params => [ qw/suff io_prority status/ ],
  required => [ qw/suff/ ],
);

fbx_api_method add_download_task => (
  description => <<'',
Add a download task.

  path => 'downloads/add',
  method => 'POST',
  content_type => 'application/x-www-form-urlencoded',
  params => [ qw/download_url download_url_list download_dir recursive username password archive_password cookies/],
  required => [ qw//],
);

fbx_api_method add_download_task_file => (
  description => <<'',
Add a download task by file.

  path => 'downloads/add',
  method => 'POST',
  content_type => 'form-data',
  params => [ qw/download_file download_dir archive_password/],
  required => [ qw/download_file/],
);

fbx_api_method change_prio_download_file => (
  description => <<'',
Change the priority of a Download File.

  path => 'downloads/',
  method => 'PUT',
  params => [ qw/suff prority/ ],
  required => [ qw/suff prority/ ],
);

#TODO: tracker, blacklist

#Download feeds
fbx_api_method s'/'_'gr => (
  description => <<'',
Get feed(s).

  path => $_,
  method => 'GET',
  params => [ qw/suff/ ],
  required => [ ],
) for qw(downloads/feeds/);

fbx_api_method add_feed => (
  description => <<'',
Add a feed.

  path => 'downloads/feeds/',
  method => 'POST',
  params => [ qw/url/ ],
  required => [ qw/url/ ],
);
#TODO the rest..

#Download config
fbx_api_method s'/'_'gr => (
  description => <<'',
Global download config getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(downloads/config/);

#FS
fbx_api_method s'/'_'gr => (
  description => <<'',
Global fs getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(fs/tasks/);

#Share
fbx_api_method s'/'_'gr => (
  description => <<'',
Global share getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(share_link/);

#Upload
fbx_api_method s'/'_'gr => (
  description => <<'',
Global upload getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(upload/);

#AirMedia
fbx_api_method s'/'_'gr => (
  description => <<'',
Global airmedia getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(airmedia/config airmedia/receivers/);

#RRD

#CALL
fbx_api_method s'/'_'gr => (
  description => <<'',
Global call getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(call/log/);

#CONTACTS
fbx_api_method s'/'_'gr => (
  description => <<'',
Global contacts getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(contact/);

#CONNECTION
fbx_api_method s'/'_'gr => (
  description => <<'',
Global Connection getters.

  path => $_,
  method => 'GET',
  params => [],
  required => [],
) for qw(connection connection/config connection/ipv6/config connection/xdsl/ connection/ftth);

fbx_api_method connection_dyndns => (
  description => <<'',
Get status or config of dyndns provider.

  path => 'connection/ddns/',
  method => 'GET',
  params => [qw/suff/],
  required => [qw/suff/],
);

#LAN
fbx_api_method s'/'_'gr => (
  description => <<'',
Global Lan getters.

  path => $_,
  method => 'GET',
  params => [],
  required => [],
) for qw(lan/config lan/browser/interfaces);

fbx_api_method list_hosts => (
  description => <<'',
Get the list of hosts on a given interface.

  path => 'lan/browser/',
  method => 'GET',
  params => [ qw/suff/ ],
  required => [ qw/suff/ ],
);

#Freeplugs
fbx_api_method freeplugs_net => (
  description => <<'',
Get freeplugs networks and information.

  path => 'freeplug/',
  method => 'GET',
  params => [ qw/suff/ ],
  required => [ ],
);

fbx_api_method reset_freeplug => (
  description => <<'',
Reset a freeplug.

  path => 'freeplug/',
  method => 'POST',
  params => [ qw/suff/ ],
  required => [ qw/suff/ ],
);

#DHCP
fbx_api_method s'/'_'gr => (
  description => <<'',
Global DHCP getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(dhcp/config dhcp/static_lease dhcp/dynamic_lease);

#FTP

fbx_api_method ftp_config => (
  description => <<'',
Get the FTP config.

  path => 'ftp/config/',
  method => 'GET',
  params => [ ],
  required => [ ],
);

fbx_api_method set_ftp_config => (
  description => <<'',
Set the FTP config.

  path => 'ftp/config',
  method => 'PUT',
  params => [ qw/enabled allow_anonymous allow_anonymous_write password/ ],
  required => [ ],
);

#NAT
fbx_api_method s'/'_'gr => (
  description => <<'',
Global NAT getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(fw/dmz fw/redir/ fw/incoming/);

#UPNP
fbx_api_method s'/'_'gr => (
  description => <<'',
Global UPNP getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(upnpigd/config upnpigd/redir/);

#LCD
fbx_api_method lcd => (
  description => <<'',
Get the LCD config.

  path => 'lcd/config/',
  method => 'GET',
  params => [ ],
  required => [ ],
);
fbx_api_method set_lcd => (
  description => <<'',
Set the LCD config.

  path => 'lcd/config/',
  method => 'PUT',
  params => [ qw/brightness orientation orientation_forced/ ],
  required => [ ],
);

#SHARES
fbx_api_method s'/'_'gr => (
  description => <<'',
Global Network Shares getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(netshare/samba netshare/afp);

#UPNPAV
fbx_api_method upnpav => (
  description => <<'',
Get the UPNPAV config.

  path => 'upnpav/config',
  method => 'GET',
  params => [ ],
  required => [ ],
);
fbx_api_method set_upnpav => (
  description => <<'',
Set the UPNPAV config.

  path => 'upnpav/config',
  method => 'PUT',
  params => [ qw/enabled/],
  required => [ qw/enabled/],
);

#SWITCH
fbx_api_method switch_sts => (
  description => <<'',
Get the switch status.

  path => 'switch/status/',
  method => 'GET',
  params => [ ],
  required => [ ],
);

#wifi
fbx_api_method s'/'_'gr => (
  description => <<'',
Global Wifi getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(wifi/config wifi/ap wifi/bss wifi/planning wifi/mac_filter);

#System
fbx_api_method system => (
  description => <<'',
Get the system info.

  path => 'system',
  method => 'GET',
  params => [ ],
  required => [ ],
);

fbx_api_method reboot => (
  description => <<'',
Reboot the system.

  path => 'system/reboot',
  method => 'POST',
  params => [ ],
  required => [ ],
);

#VPN server
fbx_api_method s'/'_'gr => (
  description => <<'',
Global VPN server getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(vpn/ vpn/user/ vpn/ip_pool/);

#VPN client
fbx_api_method s'/'_'gr => (
  description => <<'',
Global VPN client getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(vpn_client/config/ vpn_client/status vpn_client/log); 

#Storage
fbx_api_method s'/'_'gr => (
  description => <<'',
Global storage getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(storage/disk/ storage/partition/);

#Parental
fbx_api_method s'/'_'gr => (
  description => <<'',
Global parental getters.

  path => $_,
  method => 'GET',
  params => [ ],
  required => [ ],
) for qw(parental/config/ parental/filter/);


1;
__END__

=encoding utf-8

=head1 NAME

WWW::FBX::Role::API::APIv3 - Freebox API v3

=head1 SYNOPSIS

    with 'WWW::FBX::Role::API::APIv3';

=head1 DESCRIPTION

WWW::FBX::Role::API::APIv3 is the freebox6 API version 3 as a Moose Role

=head1 API

=head2 call

=head3 call log

my $res = $fbx->call_log;

=head3 contact

my $res = $fbx->contact;

=head2 connection

=head3 connection

my $res = $fbx->connection;

=head3 connection config

my $res = $fbx->connection_config;

=head3 connection ipv6 config

my $res = $fbx->connection_ipv6_config;

=head3 connection xdsl

my $res = $fbx->connection_xdsl;

=head3 connection ftth

my $res = $fbx->connection_ftth;

=head3 connection dyndns noip

my $res = $fbx->connection_dyndns({suff=>"noip/status"});

=head2 dhcp

=head3 dhcp config

my $res = $fbx->dhcp_config;

=head3 dhcp static lease

my $res = $fbx->dhcp_static_lease;

=head3 dhcp dynamic lease

my $res = $fbx->dhcp_dynamic_lease;

=head2 download

=head3 downloads

my $res = $fbx->downloads;

=head3 download task

my $res = $fbx->get_download_task( { suff => "0" } );

=head3 download task log

my $res = $fbx->get_download_task( { suff => "0/log" } );

=head3 downloads task del

my $res = $fbx->del_download_task( { suff => "0" } );

=head3 downloads task del with file erase

my $res = $fbx->del_download_task( { suff => "0/erase" } );

=head3 downloads update

my $res = $fbx->upd_download_task( { suff => "0", io_priority => "high" } );

=head3 download add

my $res = $res = $fbx->add_download_task( { download_url => "http://cdimage.debian.org/debian-cd/current/arm64/bt-cd/debian-8.4.0-arm64-CD-1.iso.torrent"} );

=head3 download add by local file

my $res = $res=$fbx->add_download_task_file( {download_file => [ "debian-8.4.0-arm64-netinst.iso.torrent" ] });

=head3 update priority of download file

my $res = $res=$fbx->change_prio_download_file( {suff=>"76/files/76-0", priority=>"high"} );

=head3 download tracker

my $res = $res = $fbx->get_download_task( {suff => "76/trackers"});

=head3 download peers

my $res = $res = $fbx->get_download_task( {suff => "76/peers"});

=head3 downloads stats

my $res = $fbx->downloads_stats;

=head3 downloads feeds

my $res = $fbx->downloads_feeds;

=head3 add feed

my $res = $res = $fbx->add_feed({url=>"http://www.nzb-rss.com/rss/Debian-unstable.rss"});

=head3 downloads config

my $res = $fbx->downloads_config;

=head2 freeplugs

=head3 freeplugs_net

my $res = $fbx->freeplugs_net;

=head2 fs

=head3 fs tasks

my $res = $fbx->fs_tasks;

=head2 ftp

=head3 ftp config

my $res = $fbx->ftp_config;

=head2 lan

=head3 lan config

my $res = $fbx->lan_config;

=head3 lan browser interfaces

my $res = $res = $fbx->lan_browser_interfaces;

=head3 lan browser interfaces pub

my $res = $fbx->list_hosts({ suff => $res->{result}->[0]->{name} });

=head2 lcd

=head3 lcd

my $res = $res = $fbx->lcd;

=head3 lcd brightness back

my $res = $fbx->set_lcd({ brightness => $res->{result}{brightness} });

=head2 nat

=head3 fw dmz

my $res = $fbx->fw_dmz;

=head3 fw redir

my $res = $fbx->fw_redir;

=head3 fw incoming

my $res = $fbx->fw_incoming;

=head2 parental

=head3 parental config

my $res = $fbx->parental_config;

=head3 parental filter

my $res = $fbx->parental_filter;

=head2 share

=head3 share link

my $res = $fbx->share_link;

=head3 upload

my $res = $fbx->upload;

=head3 airmedia config

my $res = $fbx->airmedia_config;

=head3 airmedia receivers

my $res = $fbx->airmedia_receivers;

=head2 shares

=head3 netshare samba

my $res = $fbx->netshare_samba;

=head3 netshare afp

my $res = $fbx->netshare_afp;

=head2 storage

=head3 storage disk

my $res = $fbx->storage_disk;

=head3 storage partition

my $res = $fbx->storage_partition;

=head2 switch

=head3 switch status

my $res = $fbx->switch_sts;

=head2 system

=head3 system

my $res = $fbx->system;

=head2 upnp

=head3 upnpigd config

my $res = $fbx->upnpigd_config;

=head3 upnpigd redir

my $res = $fbx->upnpigd_redir;

=head2 upnpav

=head3 upnpav

my $res = $fbx->upnpav;

=head2 vpn

=head3 vpn

my $res = $fbx->vpn;

=head3 vpn user

my $res = $fbx->vpn_user;

=head3 vpn ip_pool

my $res = $fbx->vpn_ip_pool;

=head3 vpn client config

my $res = $fbx->vpn_client_config;

=head3 vpn client status

my $res = $fbx->vpn_client_status;

=head3 vpn client log

my $res = $fbx->vpn_client_log;

=head2 wifi

=head3 wifi config

my $res = $fbx->wifi_config;

=head3 wifi ap

my $res = $fbx->wifi_ap;

=head3 wifi bss

my $res = $fbx->wifi_bss;

=head3 wifi planning

my $res = $fbx->wifi_planning;

=head3 wifi mac filter

my $res = $fbx->wifi_mac_filter;

=head1 LICENSE

Copyright (C) Laurent Kislaire.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Laurent Kislaire E<lt>teebeenator@gmail.comE<gt>

=cut

