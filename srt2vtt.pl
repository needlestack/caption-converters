#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
#use HTML::Entities;

my $force = "";
if ($ARGV[0]||"" eq "-f") {
    $force = 1;
    shift @ARGV;
}

if (not @ARGV) {
    $0 =~ /([^\/]+)$/; # remove path from script name
    my $script = $1;
    print STDERR "usage: $script [-f] file ...\n";
    print STDERR "       creates WebVTT from an .srt subtitle file\n";
    print STDERR "       -f overwrites existing files\n";
    exit;
}

foreach my $file (@ARGV) {

    if (not open INFILE, $file) {
        warn "$!: $file\n";
        next;
    }

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

    # set the encoding
    #binmode FILE, ":encoding(UTF-8)";

    # print the header
    #print FILE chr(65279); # UTF-8 BOM, required for proper rendering
    print FILE "WEBVTT\n\n";

    foreach my $line (<INFILE>) {

        # remove any funky newline stuff
        $line =~ s/\s+$//;

        # skip the line numbers
        next if $line =~ /^\d+$/;

        if ($line =~ /\d\d:\d\d:\d\d,\d\d\d --> \d\d:\d\d:\d\d,\d\d\d/) {
            $line =~ s/,/./g;
        } else {
#            $line = decode_entities($line);
        }

        print FILE $line . "\n";

    }

    # flush
    close FILE;

}

=head1 NAME

srt2vtt.pl - convert .srt subtitle file to WebVTT format

=head1 SYNOPSIS

  perl srt2vtt.pl [-f] file ...

=head1 USAGE

Provide a list of .srt subtitle files, and .vtt files are created.

If the -f option is specified, the script will overwrite any existing
.vtt files.

=head1 AUTHOR

Jonathan Field - jfield@gmail.com
