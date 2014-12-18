#!/usr/bin/perl
use strict;
use warnings;
use Encode;
use HTML::Entities;


if (not @ARGV) {
    print STDERR "usage: $0 file ...\n";
    print STDERR "       process HTML entities in VTT files into UTF-8\n";
    exit;
}

foreach my $file (@ARGV) {

    if (not open FILE, "+<$file") {
        warn "Couldn't open $file: $!";
        next;
    }

    # set the encoding
    binmode FILE, ":encoding(UTF-8)";

    my $output = chr(65279); # UTF-8 BOM, required for proper rendering
    while (my $line = <FILE>) {
        $output .= encode_utf8(decode_entities($line));
    }

    seek(FILE, 0, 0) or die "Couldn't seek $file: $!";
    print(FILE $output) or die "Couldn't write $file: $!";
    truncate(FILE, tell(FILE)) or die "Couldn't truncate $file: $!";
    close(FILE) or die "Couldn't close $file: $!";

}

=head1 NAME

html2utf8.pl - convert HTML entities to UTF-8

=head1 SYNOPSIS

  perl html2utf8.pl file ...

=head1 USAGE

Provide a list of files, and it converts any HTML character
entities it finds (e.g. &#1104;) into their corresponding UTF-8
characters (e.g. ѐ). The original files are modified.

This is mainly useful for VTT files which often contain HTML
entities, but need to be in UTF-8 to display properly as video
subtitles.

=head1 AUTHOR

Jonathan Field - jfield@gmail.com
