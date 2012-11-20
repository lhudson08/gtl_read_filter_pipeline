#!/opt/local/bin/perl 

eval 'exec /opt/local/bin/perl  -S $0 ${1+"$@"}'
    if 0; # not running under some shell
my $mod = "10/30/12 9:58 PM";
my $version = "0.3";
my $author = "Nick Youngblut";
#--------------------- version log ---------------------#
# v0.3 -> bug fix: if 1st read is from 2nd pair
#
#-------------------------------------------------------#

### packages/perl_flags
use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
use File::Spec;

### global variables
my ($error);

### I/O
my ($verbose);
GetOptions(
	   "verbose" => \$verbose,
	   "help|?" => \&usage # Help
	   );

### Input error check


### Routing main subroutines
illuminaPairChecker();

#----------------------Subroutines----------------------#
sub illuminaPairChecker{
	### Clean up broken pairs ###

	#open(SINGLE, ">illuminaPairChecker_singles.fq") or die $!;
	my %check;
	while(<>){
		my @tmp;
		if($_ =~ /^\s*@/){@tmp = split(/\s+|#/)};
		if(exists($check{$tmp[0]})){	# writing pairs
			my @lines;
			for(1..3){
				my $line = <>;
				push(@lines, $line);
				}
			my $pair_num = splice( @{$check{$tmp[0]}},0,1);
			print join("", $tmp[0], " ", $pair_num, "\n", @{$check{$tmp[0]}});
			print $_, @lines;			
			delete $check{$tmp[0]};
			}
		else{			# if single
			my @lines;
			for(1..3){
				my $line = <>;
				push(@lines, $line);
				}
			$check{$tmp[0]} = [$tmp[1], @lines];
			}
		}
	#print Dumper %check; exit;
	#foreach (keys %check){	#writing singles
	#	print SINGLE join("", $_, " ", ${$check{$_}}[0], "\n", @{$check{$_}});
	#	}
	#close SINGLE;
	}

sub error_routine{
	my $error = $_[0];
	my $exitcode = $_[1];
	print STDERR "ERROR: $error\nSee help: [-h]\n";
	exit($exitcode);
	}

sub usage {
 my $usage = <<HERE;
Usage:
 illuminaPairChecker.pl < file.fq > file.fq
Description:
 Input must be a shuffled fastq file.
 Paired reads output to STDOUT.

Notes:
 Version: $version
 Last Modified: $mod
 Author: $author
Categories:
 Genome assembly
 
HERE
	print $usage;
    exit(1);
}
