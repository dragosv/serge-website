#!/usr/bin/perl

use strict;

BEGIN {
    unshift(@INC, "$ENV{L10N_HOME}/serge/lib");
}

use Encode qw(encode_utf8);
use File::Basename;
use File::Find qw(find);
use File::Path;
use File::Spec::Functions qw(abs2rel catfile);
use Pod::Simple::XHTML;
use Pod::Text;
use Serge::Pod;

my $pod = Serge::Pod->new();
my $pod_root = $pod->{pod_root};

my $help_root = catfile(dirname(__FILE__), 'webroot/docs/help');
my $inc_root = catfile(dirname(__FILE__), 'inc');

my @podfiles;

print "Scanning .pod files in '$pod_root'...";
find(sub {
    push @podfiles, catfile($File::Find::name) if (-f $_ && /\.pod$/);
}, $pod_root);

my $n = scalar(@podfiles);
print " $n files found\n";

my @commands;

foreach my $podfile (@podfiles) {
    my $command = abs2rel($podfile, $pod_root);
    $command =~ s/\.pod$//;

    push @commands, $command;

    my $outfilename = save_php($command, $podfile);
    print "Saved $outfilename\n";
}

my $outfilename = save_index();
print "Saved $outfilename\n";

sub save_php {
    my ($command, $podfile) = @_;

    my $outfile = catfile($help_root, $command, 'index.php');
    my $version_dir = catfile($help_root, $command, 'v');

    my $out;

    my $localtime = localtime;

    my $parser = Pod::Simple::XHTML->new();
    $parser->perldoc_url_prefix('../');
    $parser->perldoc_url_postfix('/');

    my $include_version_selector = '';
    if (-d $version_dir) {
        $include_version_selector =
            qq|
    include(\$_SERVER['DOCUMENT_ROOT'] . '/../inc/version-selector.php');
|;
    }

    $parser->html_header(
qq|<?php
    \$command = '$command';
    include(\$_SERVER['DOCUMENT_ROOT'] . '/../inc/help-header.php');
$include_version_selector?>
|);
    $parser->html_footer(
qq|
<?php include(\$_SERVER['DOCUMENT_ROOT'] . '/../inc/help-footer.php') ?>|);
    $parser->output_string(\$out);
    $parser->parse_file($podfile);

    my $dir = dirname($outfile);
    mkpath($dir) unless -d $dir;

    open OUT, ">$outfile" or die "Can't open file '$outfile': $!\n";
    binmode(OUT);
    print OUT encode_utf8($out); # encode manually to avoid 'Wide character in print' warnings and force Unix-style endings
    close OUT;

    return $outfile;
}

sub save_index {
    my $outfile = catfile($inc_root, 'help-topics.php');

    my $dir = dirname($outfile);
    mkpath($dir) unless -d $dir;

    my $out = '<?php $help_topics = array("'.join('","', sort @commands).'"); ?>';

    open OUT, ">$outfile" or die "Can't open file '$outfile': $!\n";
    binmode(OUT);
    print OUT encode_utf8($out); # encode manually to avoid 'Wide character in print' warnings and force Unix-style endings
    close OUT;

    return $outfile;
}
