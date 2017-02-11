#!/usr/bin/env perl 
use strict;
use warnings;
use Config::YAML;
use Etherpad;
use Data::Dumper;
use Encode ();
use FindBin;

my $url = shift;
my $c = Config::YAML->new(config => "$FindBin::Bin/mirror_pad.yml");
my $ep = Etherpad->new(
  url      => $c->get_url,
  apikey   => $c->get_apikey,
  user     => $c->get_user,
  password => $c->get_password,
);

my $pad_base = quotemeta $c->get_url;
my $pad_id = $url;
$pad_id =~ s{$pad_base/?.+?/(g\..+?\$.+)(?:/export/.+)?}{$1};
my $pad_text = Encode::encode('UTF-8', $ep->get_text($pad_id) );
print $pad_text;

