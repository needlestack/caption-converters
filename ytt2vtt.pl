#!/usr/bin/perl
use strict;
use warnings;
use XML::Simple;
use Data::Dumper;

my $force = shift @ARGV if $ARGV[0] eq "-f";

if (not @ARGV) {
    print STDERR "usage: $0 [-f] file ...\n";
    print STDERR "       creates WebVTT from Youtube timed text XML\n";
    print STDERR "       -f overwrites existing files\n";
    exit;
}

foreach my $file (@ARGV) {

    # XMLin would figure this out, but it would
    # stop all processing, so we test here so we
    # can skip some files without dying
    if (not open INFILE, $file) {
        warn "$!: $file\n";
        next;
    }

    # we slurp the file ourselves so we
    # can strip leading whitespace, which
    # causes problems for XMLin
    my $filedata = join("", <INFILE>);
    $filedata =~ s/^\s+//;

    # read the file into a hash
    my $data = XMLin( $filedata );

    # remove an existing extension and add .vtt
    $file =~ s/\.\w{2,4}$//;
    $file .= ".vtt";

    # skip over problems with the destination file
    if (-e $file and not $force) {
        warn "Destination file exists: $file\n";
        next;
    }
    if (not open FILE, ">$file") {
        warn "$!: $file\n";
        next;
    }

    # print the header
    print FILE "WEBVTT\n\n";

    # convert the contents line-by-line
    foreach my $cap (@{ $data->{text} }) {

        my $start  = converttime($cap->{start});
        my $finish = converttime($cap->{start}+$cap->{dur});
        $cap->{content} = "" if not defined $cap->{content};

        print FILE "$start --> $finish\n";
        print FILE "$cap->{content}\n\n";

    }

    # flush
    close FILE;

}

sub converttime {

    my ($total, $partial) = split(/\./, shift);
    
    my $hours = int($total/3600); 
    $total -= ($hours*3600); 
    my $minutes = int($total/60); 
    my $seconds = $total % 60; 

    # gotta be three digits between 0 and 999, inclusive
    $partial = substr(($partial||0), 0, 3);
    $partial .= "0" x (3 - length($partial));

    return sprintf("%.2d:%.2d:%.2d.%.3d", $hours, $minutes, $seconds, $partial);

}

=head1 NAME

ytt2vtt.pl - convert Youtube timed text XML to WebVTT format

=head1 SYNOPSIS

  perl ytt2vtt.pl [-f] file ...

=head1 USAGE

Provide a list of Youtube timed text files, and .vtt files are created.

If the -f option is specified, the script will overwrite any existing
.vtt files.

=head1 AUTHOR

Jonathan Field - jfield@gmail.com
