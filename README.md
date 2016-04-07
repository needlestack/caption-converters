Caption Converters
==================

Command line scripts for converting common subtitle / caption formats.
Currently reads Youtube timed text (as delivered by their API)
and outputs either .srt or .vtt files.

## NAME

- **ytt2vtt.pl** - convert Youtube timed text XML to WebVTT format
- **ytt2srt.pl** - convert Youtube timed text XML to SRT format
- **srt2vtt.pl** - convert .srt subtitles to WebVTT format
- **vtt2srt.pl** - convert WebVTT format to .srt subtitles

## USAGE

     perl ytt2vtt.pl [-f] file ...
     perl ytt2srt.pl [-f] file ...
     perl srt2vtt.pl [-f] file ...
     perl vtt2srt.pl [-f] file ...

List one or more files to convert. New files will be created. Original files will be untouched.
The scripts will not overwrite existing files unless the -f (force) option is specified.

## AUTHOR

Jonathan Field - jfield@gmail.com

