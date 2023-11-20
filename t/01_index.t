#!/usr/bin/env perl

use strict;
use warnings;
use lib './lib';
use File::Basename qw/dirname/;
use FindBin qw/$RealBin/;
use Data::Dumper;

use Test::More tests => 1;

$ENV{PATH} = "$RealBin/../scripts:".$ENV{PATH};

subtest 'node info' => sub{
    my(%seq, %link);

    my @line = `gfa-info.pl t/data/test.gfa --node 37958 --node 2254218`;

    for my $l (@line){
      chomp($l);
      my($code, $seqName, $key, $value) = split(/\t/, $l);
      if($code eq 'S'){
        $seq{$seqName}{$key} = $value;
      }
      elsif($code eq 'L'){
        $link{$seqName}{$key} = $value;
      }
    }

    subtest '37958' => sub{
      is($seq{37958}{cigar}, 'KC:i:284', "attributes");
      is($link{37958}{to}, '2255152', "link to");
    };
    subtest '2254218' => sub{
      is($seq{2254218}{cigar}, 'KC:i:645456', "attributes");
      is($link{2254218}{to}, '2235416', "link to");
    };
};

