#!/usr/bin/perl

use strict;
use warnings;

use Benchmark qw(cmpthese);
use Method::WeakCallback qw(weak_method_callback weak_method_callback_cached);

sub new {
    bless { foo => 1 };
}

sub foo { shift->{foo} }

for my $n (1, 2, 5, 10, 100, 1000, 10000) {

    cmpthese -1, { "cache$n" => sub {
                       my $o = main->new;
                       weak_method_callback_cached($o, 'foo') for 1..$n;
                   },
                   "nocache$n" => sub {
                       my $o = main->new;
                       weak_method_callback($o, 'foo') for 1..$n;
                   }
                 }
}
