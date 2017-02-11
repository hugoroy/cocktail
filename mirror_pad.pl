#!/usr/bin/env perl 
use strict;
use warnings;
use Config::YAML;
use Etherpad;
use Data::Dumper;
use Encode ();
use FindBin;
use URI::Encode ();

my $url = URI::Encode::uri_decode(shift);
my $c = Config::YAML->new(config => "$FindBin::Bin/mirror_pad.yml");
my $ep = Etherpad->new(
  url      => $c->get_url,
  apikey   => $c->get_apikey,
  user     => $c->get_user,
  password => $c->get_password,
);

my $pad_base = quotemeta $c->get_url;
my $pad_id = $url;
$pad_id =~ s{$pad_base/.+?/(g\.[^/]+).*$}{$1};
warn "PADID=$pad_id\n";
if(my($pad_text) = $ep->get_text($pad_id)) {
    $pad_text = Encode::encode('UTF-8', $pad_text);
    print $pad_text;
}
else {
    exit 1;
}

