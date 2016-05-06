use strict;
use Test::More 0.98;
use WWW::FBX;

plan skip_all => "FBX_APP_ID, FBX_APP_NAME, FBX_APP_VERSION, FBX_TRACK_ID, FBX_APP_TOKEN not all set"
    unless $ENV{FBX_APP_ID} and $ENV{FBX_APP_NAME} and $ENV{FBX_APP_VERSION} and $ENV{FBX_TRACK_ID} and $ENV{FBX_APP_TOKEN};

my $fbx;
my $res;

eval {
  $fbx = WWW::FBX->new (
    app_id => $ENV{FBX_APP_ID},
    app_name => $ENV{FBX_APP_NAME},
    app_version => $ENV{FBX_APP_VERSION},
    device_name => $ENV{FBX_TRACK_ID},
    track_id => $ENV{FBX_TRACK_ID},
    app_token => $ENV{FBX_APP_TOKEN},
  );
 
  isa_ok $fbx, "WWW::FBX", "download";
  ok($fbx->downloads, "downloads");

#  ok($fbx->get_download_task( 77 ), "download task");
#  ok($fbx->get_download_task( "77/log" ), "download task log");
#  ok($fbx->del_download_task( 77 ), "downloads task del");
#  ok($fbx->del_download_task( "77/erase" ), "downloads task del with file erase");
#  ok($fbx->upd_download_task( 0, { io_priority => "high" } ), "downloads update");
#  ok($res = $fbx->add_download_task( { download_url => "http://cdimage.debian.org/debian-cd/current/arm64/bt-cd/debian-8.4.0-arm64-CD-1.iso.torrent"} ), "download add");
#  ok($res=$fbx->add_download_task_file( {download_file => [ "debian-8.4.0-arm64-netinst.iso.torrent" ] }), "download add by local file");
#  ok($res=$fbx->change_prio_download_file( "76/files/76-0", { priority=>"high"} ), "update priority of download file");
#  ok($res = $fbx->get_download_task( "76/trackers"), "download tracker");
#  ok($res = $fbx->get_download_task( "76/peers"), "download peers");
  ok($fbx->downloads_stats, "downloads stats");
  ok($fbx->downloads_feeds, "download feeds");
#  ok($fbx->downloads_feeds( 1 ), "download feed");
#  ok($fbx->del_feed( 1 ), "del feed");
#  ok($fbx->upd_feed(1, {auto_download=> \1}), "update feed");
#  ok($fbx->refresh_feed("1/fetch"), "refresh feed");
#  ok($fbx->refresh_feeds, "refresh all feeds");
#  ok($fbx->downloads_feeds("1/items"), "download feed items");
#  ok($fbx->upd_feed("1/items/6"), "update a feed item");
#  ok($fbx->download_feed_item("1/items/6/download"), "download a feed item");
#  ok($fbx->mark_all_read( "1/items/mark_all_as_read" ), "mark all items as read");
#  ok($res = $fbx->add_feed("http://www.nzb-rss.com/rss/Debian-unstable.rss"), "add feed");
#  ok($res = $fbx->upd_downloads_config({max_downloading_tasks => 6, download_dir=>"/Disque dur/Téléchargements/"}), "update downloads config");
#  ok($res = $fbx->upd_downloads_throttle( "schedule" ), "update throttling");
#  ok($res = $fbx->download_file( "Disque dur/Photos/cyril/DSCF4322.JPG" ), "download file to disk");
#  ok($res = $fbx->upload_auth( {upload_name => "DSCF4322.JPG", dirname => "/Disque dur/"} ), "get upload id");
#  ok($res = $fbx->upload_file( {id=> $res->{result}{id}, filename=>"DSCF4322.JPG"}), "upload file by upload id");
#  ok($res = $fbx->upload_file( {filename => "DSCF4322.JPG", dirname => "/Disque dur/"} ), "upload file directly");

  ok($fbx->downloads_config, "downloads config");
};

if ( my $err = $@ ) {
    diag "HTTP Response Code: ", $err->code, "\n",
         "HTTP Message......: ", $err->message, "\n",
         "API Error.........: ", $err->error, "\n",
         "Error Code........: ", $err->fbx_error_code, "\n",
}


done_testing;

