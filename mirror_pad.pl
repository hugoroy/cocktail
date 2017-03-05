#!/usr/bin/env perl 
use strict;
use warnings;
use Config::YAML;
use Etherpad;
use Data::Dumper;
use Encode ();
use FindBin;
use URI::Encode ();

my $pad_url = URI::Encode::uri_decode(shift);
warn "PAD_URL=$pad_url";

my $config_file = "$FindBin::Bin/mirror_pad.yml";
die "'$config_file' introuvable\n" unless -r $config_file;

my $c = Config::YAML->new(config => $config_file);
my $ep = Etherpad->new(
  apiurl => $c->get_apiurl,
  apikey => $c->get_apikey,
);

my $pad_base = quotemeta $c->get_apiurl;
warn "PAD_BASE=$pad_base";
# Extraction de l'id du pad à partir de l'url du pad
my $pad_id;
($pad_id) = $pad_url =~ m{^$pad_base/.+?/(g\.[^/]+)}o;
warn "PADID=$pad_id\n";
if(my($pad_text) = $ep->get_text($pad_id)) {
    $pad_text = Encode::encode('UTF-8', $pad_text);
    print $pad_text;
}
else {
    exit 1;
}

