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

Current methods available:
get_lan_config, upload, connection, connection_config, connection_config_ipv6, netshare_samba, fw_incoming, airmedia_receivers,  downloads_stats, wifi_config, wifi_mac_filter, fs_tasks, vpn_client_status, switch_sts, ftp_config, dhcp_config, parental_filter, fw_redir, fw_dmz, vpn_client_config, upnpav, connection_config_xdsl, vpn_client_log, connection_dyndns, parental_config, wifi_ap, vpn_ip_pool, upnpigd_redir, freeplugs_net, downloads, set_upnpav, api_version, storage_disk, contact, wifi_planning, wifi_bss, login, dhcp_dynamic_lease, system, list_hosts, airmedia_config, browse_lan_interface, set_ftp_config, vpn_user, auth_progress, storage_partition, reboot, downloads_config, open_session, reset_freeplug, vpn, share_link, set_lcd, call_log, dhcp_static_lease, lcd, upnpigd_config, netshare_afp, downloads_feeds, connection_config_ftth

=head1 LICENSE

Copyright (C) Laurent Kislaire.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Laurent Kislaire E<lt>teebeenator@gmail.comE<gt>

=cut

