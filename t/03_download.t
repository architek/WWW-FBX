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
  ok($fbx->downloads_config, "downloads config");
  ok($fbx->downloads_stats, "downloads stats");
  ok($fbx->downloads_feeds, "download feeds");

  if ($ENV{FBX_FULL_TESTS}) { 
    my $id;
    my $id_file;
    my $max_dl_tasks;

    ok( $res = $fbx->downloads_config, "downloads config"); #diag explain $res;
    $max_dl_tasks = $res->{result}{max_downloading_tasks}; #diag("Max dl is $max_dl_tasks");
    ok( $res = $fbx->get_download_task, "download tasks"); diag explain $res;
    ok( $res = $fbx->add_download_task( { download_url => "http://cdimage.debian.org/debian-cd/current/arm64/bt-cd/debian-8.4.0-arm64-CD-1.iso.torrent"} ), "download add"); diag explain $res;
    ok($res = $fbx->upd_downloads_config({max_downloading_tasks => $max_dl_tasks}), "update downloads config"); #diag explain $res;
    ok($res = $fbx->upd_downloads_throttle( "schedule" ), "update throttling"); diag "Upd throttle";
    sleep 7;
    ok( $res = $fbx->get_download_task, "download tasks"); diag explain $res;
    $id = $res->{result}->[0]->{id}; diag("id is $id");
    ok($res = $fbx->get_download_task( $id ), "download task"); diag "download task";
    ok($res = $fbx->get_download_task( "$id/log" ), "download task log");  diag "download task log";
    ok($fbx->upd_download_task( $id, { io_priority => "high" } ), "downloads update"); diag "upd task";
    ok($res = $fbx->get_download_task("$id/files") , "get download task files");
    $id_file = $res->{result}->[0]->{id};
    ok($res = $fbx->change_prio_download_file( "$id/files/$id_file", { priority=>"high"} ), "update priority of download file"); diag "Prio";
    ok($res = $fbx->del_download_task( $id ), "downloads task del"); diag explain $res;
    ok($res = $fbx->add_download_task_file( {download_file => [ "debian-8.4.0-arm64-netinst.iso.torrent" ] }), "download add by local file");
    $id = $res->{result}{id}; #diag("id is $id");
    ok($res = $fbx->get_download_task( "$id/trackers"), "download tracker");
    ok($res = $fbx->get_download_task( "$id/peers"), "download peers");
    ok($fbx->del_download_task( "$id/erase" ), "downloads task del with file erase");

    ok($res = $fbx->downloads_feeds, "download feed"); diag explain $res;
    ok($res = $fbx->add_feed( "http://www.esa.int/rssfeed/Our_Activities/Space_News" ), "add feed");
    $id = $res->{result}{id}; 
    ok($fbx->upd_feed( $id , {auto_download=> \1} ), "update feed");
    sleep 1;
    ok($res = $fbx->downloads_feeds("$id/items"), "download feed"); diag explain $res;
    $id_file = $res->{result}->[0]->{id}; diag "id file is $id_file";
#    ok($fbx->refresh_feed( "$id/fetch" ), "refresh feed");
    ok($fbx->refresh_feeds, "refresh all feeds");
    ok($fbx->downloads_feeds("$id/items"), "download feed items");
    ok($fbx->upd_feed("$id/items/$id_file"), "update a feed item");
    ok($fbx->download_feed_item("$id/items/$id_file/download"), "download a feed item");
    ok($fbx->mark_all_read( "$id/items/mark_all_as_read" ), "mark all items as read");
    ok($fbx->del_feed( $id ), "del feed");
    ok($res = $fbx->download_file( "Disque dur/Photos/cyril/DSCF4322.JPG" ), "download file to disk");
    ok($res = $fbx->download_file( "Disque dur/Photos/cyril/DSCF4321.JPG" ), "download file to disk");
    ok($res = $fbx->upload_auth( {upload_name => "DSCF4322.JPG", dirname => "/Disque dur/"} ), "get upload id");
    ok($res = $fbx->upload_file( {id=> $res->{result}{id}, filename=>"DSCF4322.JPG"}), "upload file by upload id");
    ok($res = $fbx->upload_file( {filename => "DSCF4321.JPG", dirname => "/Disque dur/"} ), "upload file directly");
  }

};

if ( my $err = $@ ) {
    diag "HTTP Response Code: ", $err->code, "\n",
         "HTTP Message......: ", $err->message, "\n",
         "API Error.........: ", $err->error, "\n",
         "Error Code........: ", $err->fbx_error_code, "\n",
}


done_testing;

