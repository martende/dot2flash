#!/usr/bin/perl
use XML::Simple;
use strict;
use Data::Dumper;

our $INPUT_FILE = $ARGV[0];
our $OUTPUT_FILE = $ARGV[1];
our $OUT;
my @INPUT; 
my $INPUT;
open(FH,"<$INPUT_FILE") || die "file not found $! ";

my @INPUT=<FH>;$INPUT= join "",@INPUT;
$INPUT=~s/\\\n//sg;
close(FH);
#print Dumper(&get_params('pos="31,93", width="0.78", height="0.51"'));

&parse($INPUT);

my $xml = XMLout($OUT,RootName =>undef);
$xml=
print $xml;
=pod
digraph G {
	node [label="\N"];
	graph [bb="0,0,62,112"];
	Hello [pos="31,93", width="0.78", height="0.51"];
	World [pos="31,19", width="0.86", height="0.51"];
	Hello -> World [pos="e,31,38 31,74 31,66 31,57 31,48"];
}
=cut
sub parse {
	my $INPUT = shift;
	##  
	if ($INPUT=~/^digraph (\w+) {/) {
		$OUT->{digraph}->{name}=$1;
	} else {
		die "no digraph $INPUT";
	}
	my $skip_node = 1;
	my $skip_graph = 1;
	#([\w]+)|(([\w]+) \-\> ([\w]+))
	while ($INPUT=~/\n[\s\t]*((?:\w+)|(?:[\w]+ \-\> [\w]+))\s\[(.*?)\]\;/gs) {
		my $node = $1 ;
		my $vals = $2;
		if ($node =~/^([\w]+) \-\> ([\w]+)$/) {
			#edge
			my $from = $1;
			my $to = $2;
			
			my $params = &get_params($vals);
			push @{$OUT->{digraph}->{connector}} ,
				{
					%$params,
					from => $from,
					to => $to
				}
		} else {
			# node
			if ($node eq 'node' && $skip_node) {
				$skip_node = 0;next;
			} elsif ($node eq 'graph' && $skip_graph) {
				$skip_graph = 0;
				my $params = &get_params($vals);
				if ($params->{"bb"}) {
					my @t = split (/,/,$params->{bb});
					(undef,undef,$OUT->{digraph}->{width},$OUT->{digraph}->{height}) = @_;
				}
				next;
			} else {
				my $params = &get_params($vals);
				push @{$OUT->{digraph}->{node}} ,
				{
					%$params,
					id => $node,
				}
			}
			
		}
		#print "$node : $vals\n";
		
	}
}

sub get_params {
	my $string = shift;
	my $k_level = 0;
	my $iskey = 1; # key / val switcher
	my $cur = "";
	my $cur_key = "";
	my %ret ;
	for (my $i=0;$i<length $string;$i++) {
		my $c  = substr($string,$i,1);
		if ($k_level==0) {
			if ($c eq "\"") {
				$k_level = 1;next;
			} elsif ($c eq '=') {
				if ($cur ) {
					$cur_key = $cur;
					$iskey = 0;
					$cur ='';next;
				} else {
					die "PARSE ERROR 1";
				}
			} elsif ($c eq ',') {
				if ($cur_key ) {
					$ret{$cur_key}=$cur;
					$iskey = 1;
					$cur ='';next;
				} else {
					die "PARSE ERROR 2";
				}
			} elsif ($c eq ' ') {
				next;
			}
		} else {
			if ($c eq "\"") {
				$k_level = 0;next;
			}
		}
		$cur .= $c;
		#print "$i. KEY:$cur_key CUR - $cur  : \n";
	}
	if ($cur_key) {
		$ret{$cur_key}=$cur; 
	}
	return \%ret;
}
