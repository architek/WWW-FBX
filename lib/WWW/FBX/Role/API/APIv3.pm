package WWW::FBX::Role::API::APIv3;
use 5.008001;
use Moose::Role;
use WWW::FBX::API;
use MIME::Base64 qw/encode_base64 decode_base64/;

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

fbx_api_method del_feed => (
  description => <<'',
Delete download feed.

  path => "downloads/feeds/",
  method => 'DELETE',
  params => [ qw/suff/ ],
  required => [ qw/suff/ ],
);

fbx_api_method upd_feed => (
  description => <<'',
Update download feed.

  path => 'downloads/feeds/',
  method => 'PUT',
  params => [ qw/suff/ ],
  required => [ qw/suff/ ],
);

fbx_api_method $_ => (
  description => <<'',
Global feed POST.

  path => 'downloads/feeds/',
  method => 'POST',
  params => [ qw/suff/ ],
  required => [ qw/suff/ ],
) for qw/refresh_feed download_feed_item mark_all_read/;

fbx_api_method refresh_feeds => (
  description => <<'',
Refresh all feeds.

  path => 'downloads/feeds/fetch',
  method => 'POST',
  params => [ ],
  required => [ ],
);

#Download config
fbx_api_method downloads_config => (
  description => <<'',
Get Downloads config.

  path => "downloads/config",
  method => 'GET',
  params => [ ],
  required => [ ],
);

fbx_api_method upd_downloads_config => (
  description => <<'',
Update downloads config.

  path => "downloads/config",
  method => 'PUT',
  params => [ qw/throttling max_downloading_tasks download_dir use_watch_dir watch_dir news bt feed/],
  required => [ ],
) for qw(downloads/config/);

around downloads_config => sub {
  my $orig = shift;
  my $self = shift;

  my $params = $self->$orig(@_);

  for (qw/download_dir watch_dir/) {
    $params->{result}{$_} = decode_base64( $params->{result}{$_} ) if exists $params->{result}{$_} and $params->{result}{$_};
  }

  $params;
};

around upd_downloads_config => sub {
  my $orig = shift;
  my $self = shift;

  if (@_) {
    my $params = $_[0];
    for my $par (qw/download_dir watch_dir/) {
      $params->{$par} = encode_base64( $params->{$par}, "") if exists $params->{$par} and $params->{$par};
    }
  }

  $self->$orig(@_);
};

fbx_api_method upd_downloads_throttle => (
  description => <<'',
Update download throttling.

  path => "downloads/throttling",
  method => 'PUT',
  params => [ qw/throttling/],
  required => [ qw/throttling/ ],
);

#FS
fbx_api_method s'/'_'gr => (
  description => <<'',
Get task(s).

  path => $_,
  method => 'GET',
  params => [ qw/suff/ ],
  required => [ ],
) for qw(fs/tasks/);

fbx_api_method del_task => (
  description => <<'',
Delete task.

  path => "fs/tasks/",
  method => 'DELETE',
  params => [ qw/suff/ ],
  required => [ ],
);

fbx_api_method upd_task => (
  description => <<'',
Update task.

  path => "fs/tasks/",
  method => 'PUT',
  params => [ qw/suff state/ ],
  required => [ qw/suff state/ ],
);

fbx_api_method list_files => (
  description => <<'',
List files.

  path => "fs/ls/",
  method => 'GET',
  params => [ qw/suff / ],
  required => [ qw/suff/ ],
);

around list_files => sub {
  my $orig = shift;
  my $self = shift;

  if (@_) {
    my $params = $_[0];
    $params->{suff} = encode_base64( $params->{suff}, "") if exists $params->{suff} and $params->{suff};
  }

  my $res = $self->$orig(@_);
  for my $i ( 0.. $#{$res->{result}} ) {
    $res->{result}->[$i]{path} = decode_base64( $res->{result}[$i]{path} );
  }

  $res;
};

fbx_api_method file_info => (
  description => <<'',
Get file information.

  path => "fs/info/",
  method => 'GET',
  params => [ qw/suff/ ],
  required => [ qw/suff/ ],
);

around file_info => sub {
  my $orig = shift;
  my $self = shift;

  if (@_) {
    my $params = $_[0];
    $params->{suff} = encode_base64( $params->{suff}, "") if exists $params->{suff} and $params->{suff};
  }

  my $params = $self->$orig(@_);

  for (qw/parent target path/) {
    $params->{result}{$_} = decode_base64( $params->{result}{$_} ) if exists $params->{result}{$_} and $params->{result}{$_};
  }

  $params;
};

#TODO mv, cp, rm, cat, archive, extract, repair, hash, mkdir, rename

fbx_api_method download_file => (
  description => <<'',
Download a file.

  path => "dl/",
  method => 'GET',
  params => [ qw/suff/ ],
  required => [ qw/suff/ ],
);

around download_file => sub {
  my $orig = shift;
  my $self = shift;

  if (@_) {
    my $params = $_[0];
    $params->{suff} = encode_base64( $params->{suff}, "") if exists $params->{suff} and $params->{suff};
  }

  my $res = $self->$orig(@_);
  if ($res->{filename} and $res->{content}) {
    open my $f, ">", $res->{filename} or die "Can't create file $res->{filename} : $!";
    print $f $res->{content};
    close $f;
  }

  $res;
};

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

fbx_api_method upload_auth => (
  description => <<'',
Upload auth.

  path => "upload/",
  method => 'POST',
  params => [ qw/dirname upload_name/ ],
  required => [ qw/dirname upload_name/],
);

around upload_auth => sub {
  my $orig = shift;
  my $self = shift;

  if (@_) {
    my $params = $_[0];
    $params->{dirname} = encode_base64( $params->{dirname}, "") if exists $params->{dirname} and $params->{dirname};
  }

  $self->$orig(@_);
};

fbx_api_method upload_file => (
  description => <<'',
Upload file.

  path => "upload/",
  method => 'POST',
  params => [ qw/id suff dirname name/ ],
  required => [ qw/name/],
  content_type => 'form-data',
);

#if user provided an id, use this one otherwise request one (in that case dirname and upload_name have to be provided)
around upload_file => sub {
  my $orig = shift;
  my $self = shift;
  my $params = $_[0];
  my $id;

  if ($params and exists $params->{filename} and $params->{filename}) {
    my $filename = delete $params->{filename};
    $params->{name} = [ $filename ];
    if (exists $params->{id}) {
      $id = delete $params->{id};
    } else {
      $params->{upload_name} = $filename unless exists $params->{upload_name};
      my $res = $self->upload_auth(@_);
      delete $params->{dirname};
      delete $params->{upload_name};
      $id = $res->{result}{id};
    }
    $params->{suff} = "$id/send";
  };
  $self->$orig(@_);
};

fbx_api_method s'/'_'gr => (
  description => <<'',
Delete downloads.

  path => $_,
  method => 'DELETE',
  params => [ ],
  required => [ ],
) for qw(upload/clean);

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

API documentation is given here: L<http://dev.freebox.fr/sdk/os/>
The following methods are currently implemented in this library:

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

=head3 download feeds

my $res = $fbx->downloads_feeds;

=head3 download feed

my $res = $fbx->downloads_feeds( { suff => "1"};

=head3 del feed

my $res = $fbx->del_feed({suff => "1"});

=head3 update feed

my $res = $fbx->upd_feed({suff=>"1", auto_download=> \1});

=head3 refresh feed

my $res = $fbx->refresh_feed({suff=>"1/fetch"});

=head3 refresh all feeds

my $res = $fbx->refresh_feeds;

=head3 download feed items

my $res = $fbx->downloads_feeds({suff=>"1/items"};

=head3 update a feed item

my $res = $fbx->upd_feed({suff=>"1/items/6"};

=head3 download a feed item

my $res = $fbx->download_feed_item({suff=>"1/items/6/download"};

=head3 mark all items as read

my $res = $fbx->mark_all_read({suff=>"1/items/mark_all_as_read"};

=head3 add feed

my $res = $res = $fbx->add_feed({url=>"http://www.nzb-rss.com/rss/Debian-unstable.rss"});

=head3 download file to disk

my $res = $res = $fbx->download_file({suff=>"Disque dur/Photos/cyril/DSCF4322.JPG"});

=head3 update downloads config

my $res = $res = $fbx->upd_downloads_config({max_downloading_tasks => 6, download_dir=>"/Disque dur/Téléchargements/"});

=head3 update throttling

my $res = $res = $fbx->upd_downloads_throttle({throttling => "schedule"});

=head3 downloads config

my $res = $fbx->downloads_config;

=head2 freeplugs

=head3 freeplugs_net

my $res = $fbx->freeplugs_net;

=head2 fs

=head3 fs tasks

my $res = $fbx->fs_tasks;

=head3 fs task

my $res = $fbx->fs_tasks({suff=>"12"});

=head3 update fs task

my $res = $fbx->upd_task({suff=>"12", state=>"paused"});

=head3 list files

my $res = $fbx->list_files({suff=>"/Disque dur/Photos/"});

=head3 file info

my $res = $res = $fbx->file_info({suff=>"Disque dur/Photos/Sydney/DSCF4323.JPG"});

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

