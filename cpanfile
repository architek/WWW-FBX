requires 'perl', '5.014001';
requires 'Digest::HMAC_SHA1';
requires 'Moose';
requires 'Carp::Clan';
requires 'JSON::MaybeXS';
requires 'Scalar::Util';
requires 'URI::Escape';
requires 'HTTP::Request';
requires 'Encode';
requires 'Try::Tiny';
requires 'LWP::UserAgent';
requires 'URI';
requires 'Devel::StackTrace';
requires 'MIME::Base64';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

