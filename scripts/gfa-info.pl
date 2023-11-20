#!/usr/bin/env perl 

use warnings;
use strict;
use Data::Dumper;
use Getopt::Long;
use File::Basename qw/basename/;

use version 0.77;
our $VERSION = '0.1.1';

local $0 = basename $0;
sub logmsg{local $0=basename $0; print STDERR "$0: @_\n";}
exit(main());

sub main{
  my $settings={};
  GetOptions($settings,qw(help node=s@)) or die $!;
  $$settings{node} //= [];
  usage() if($$settings{help});
  
  if(! @{ $$settings{node} }){
    logmsg "WARNING: --node not given. No output expected.";
  }

  for my $gfa(@ARGV){
    my $info = parse_gfa($gfa, $settings);
    
    for my $node(@{ $$settings{node} }){
      while(my($key, $value) = each(%{ $$info{S}{$node}})){
        print join("\t", "S", $node, $key, $value)."\n";
      }
      while(my($key, $value) = each(%{ $$info{L}{$node}})){
        print join("\t", "L", $node, $key, $value)."\n";
      }
    }
  }
  return 0;
}

# https://github.com/tseemann/any2fasta/blob/master/any2fasta#L171
# https://github.com/GFA-spec/GFA-spec/blob/master/GFA1.md 
# https://github.com/GFA-spec/GFA-spec/blob/master/GFA2.md 

sub parse_gfa {
  my($gfa, $settings) = @_;

  my $count=0;
  my %unitig;
  my %link;
  my @segmentField = qw(code seqname seq cigar);
  my @linkField    = qw(recordType from fromOrient to toOrient overlap);

  open(my $fh, $gfa) or die "ERROR: could not read $gfa: $!";
  while(my $line = <$fh>){
    $line =~ s/^\s*|\s*$//g; # whitespace trim
    my(@x) = split m/\t/, $line;
    my ($code, $seqName) = @x;

    # this is NOT the original contigs, rather the unitigs
    # need to parse L (link) and P (path) to reconstruct the contigs
    if ($code eq 'S') {
      for(my $i=2;$i<@segmentField;$i++){
        $unitig{$seqName}{$segmentField[$i]} = $x[$i];
      }
      $count++;
    }
    # L is for link
    elsif ($code eq 'L'){
      for(my $i=2;$i<@linkField;$i++){
        $link{$seqName}{$linkField[$i]} = $x[$i];
      }
    }
  }
  close $fh;
  return {S=>\%unitig, L=>\%link};
}

sub usage{
  print "$0: gives stats on a Graphical Fragment Assembly (GFA) file
  Usage: $0 [options] assembly.gfa
  --node   Focus on one node
  --help   This useful help menu
  \n";
  exit 0;
}
