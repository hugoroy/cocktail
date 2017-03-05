#!/usr/bin/env perl 
use strict;
use warnings;
use Config::YAML;
use Data::Dumper;
use Encode ();
use FindBin;
use URI::Encode ();


my $config_file = "$FindBin::Bin/mirror_pad.yml";
die "'$config_file' introuvable\n" unless -r $config_file;
my $config = Config::YAML->new(config => $config_file);

my $pad_base = $config->get_apiurl or die "apiurl is missing in config file ?";

my $pad_url = URI::Encode::uri_decode(shift);
warn "PAD_URL=$pad_url";

my $pad_content;
if($pad_url =~ m{\Q$pad_base/group.html}) {
    my $api_key = $config->get_apikey or die "apikey is missing in config file ?";
    $pad_content = get_private_pad($pad_url, $pad_base, $api_key);
    exit 1 if not defined $pad_content;
}
else {
    $pad_content = get_public_pad($pad_url);
}
print $pad_content;

sub get_private_pad {
    require Etherpad;
    my ($pad_url, $api_url, $api_key) = @_;
    my $ep = Etherpad->new(
      url    => $api_url,
      apikey => $api_key,
    );

    my $pad_base = quotemeta $api_url;
    warn "PAD_BASE=$pad_base";
    # Extraction de l'id du pad à partir de l'url du pad
    my $pad_id;
    ($pad_id) = $pad_url =~ m{^$pad_base/.+?/(g\.[^/]+)}o;
    warn "PADID=$pad_id\n";
    if(my($pad_text) = $ep->get_text($pad_id)) {
        $pad_text = Encode::encode('UTF-8', $pad_text);
        return $pad_text;
    }
    else {
        return;
    }
}


sub get_public_pad {
    require LWP::UserAgent;
    my ($pad_url) = @_;
    my $ua = LWP::UserAgent->new;
    my $resp = $ua->get($pad_url);
    if($resp->is_success) {
        return $resp->decoded_content;
    }
    else {
        warn $resp->status_line;
        return
    }
}

