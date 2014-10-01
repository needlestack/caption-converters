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
        warn "Opening $file $!";
        next;
    }

    my $output = "";
    while (my $line = <FILE>) {
        $output .= encode_utf8(decode_entities($line));
    }

    seek(FILE, 0, 0) or die "Seeking $file: $!";
    print(FILE $output) or die "Writing $file: $!";
    truncate(FILE, tell(FILE)) or die "Truncating $file: $!";
    close(FILE) or die "Closing $file: $!";

}

=head1 NAME

html2utf8.pl - convert HTML entities to UTF-8

=head1 SYNOPSIS

  perl html2utf8.pl file ...

=head1 USAGE

Provide a list of HTML files, and it converts any HTML character
entities it finds (e.g. &#1104;) into their corresponding UTF-8
characters (e.g. ѐ). The original files are modified.

=head1 AUTHOR

Jonathan Field - jfield@gmail.com
