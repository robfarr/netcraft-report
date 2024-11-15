#!/usr/bin/env perl
use v5.16;
use warnings;
use Const::Fast;
use Getopt::Long;
use IO::All;
use Mojo::UserAgent;

const my $API_ENDPOINT => 'https://report.netcraft.com/api/v3/report/urls';

my $stdin = io->stdin;
my $ua    = Mojo::UserAgent->new;

GetOptions(
    'e|email=s'   => \(my $email),
);

die 'Please provide an email address -e|--email' unless $email;

my @urls = split "\n", $stdin->slurp;

my $res = $ua->post($API_ENDPOINT, json => {
    email => $email,
    urls  => [ map { { url => $_ } } @urls ],
})->result;

say $res->body;
