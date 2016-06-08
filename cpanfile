requires 'perl', '5.014001';
requires 'Carp::Clan';
requires 'Devel::StackTrace';
requires 'Digest::HMAC_SHA1';
requires 'Encode';
requires 'HTTP::Request';
requires 'JSON::MaybeXS';
requires 'LWP::UserAgent';
requires 'MIME::Base64';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Scalar::Util';
requires 'Try::Tiny';
requires 'URI::Escape';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

