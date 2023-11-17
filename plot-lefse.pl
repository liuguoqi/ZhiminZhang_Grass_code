#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
my %opts;
my $VERSION = "v2.20211024"; 

GetOptions( \%opts,"i=s","o=s","m=s","g=s","l=i");
my $usage = <<"USAGE";
       Program : $0   
       Discription:   
       Version : $VERSION
       Contact : 
       Usage :perl $0 [options]		
			-i	* input tax_summary directory with otu_taxa_table_L?.txt from summarize_taxa.py of qiime. 
			-o	* output dir
			-m	* input mapping file to set samples groups
			-g	* group name in mapping file . class or class-subclss.
			-l			max levels .default:6
	   Example:$0 

USAGE

die $usage if(!($opts{i}&&$opts{o}&&$opts{m}&&$opts{g}));
$opts{l}=defined $opts{l}?$opts{l}:6;

`mkdir $opts{o}` if(!-e $opts{o});

my %map;
open MAP,"<$opts{m}";

my $head=<MAP>;chomp $head;
my @heads=split(/\t/,$head);
while(<MAP>){
		chomp;
		my @line=split(/\t/,$_);
		for(my $n=1;$n<@line;$n++){
				$map{$line[0]}->{$heads[$n]}=$line[$n];			
		}
}
close MAP;

my @class=split(/-/,"$opts{g}");

my $hh=0;
open OUT,">$opts{o}/lefse_input.txt";
`perl    /mnt/sdb/lgq/bin/tools/lefse/lefse.tax_summary_a.fullname_head.pl   $opts{i} `; 
foreach my $l(1..$opts{l}){
		if(-e "$opts{i}/otu_taxa_table_L$l.txt.2"){
				open IN,"<$opts{i}/otu_taxa_table_L$l.txt.2" ;
				<IN>;
				my $hd=<IN>;chomp $hd;
				my @hds=split(/\t/,$hd);
				while($hh<scalar(@class)){
						print OUT "$class[$hh]"; shift @hds;
						foreach my $h(@hds){
							print OUT "\t$map{$h}->{$class[$hh]}";
						}
						print OUT "\n";
						$hh++;
				}
				print OUT "SampleID\t".join("\t",@hds)."\n" if($hh==scalar(@class));
				while(<IN>){chomp;
						my @line=split(/\t/,$_);
						$line[0]=~s/.__//g;
						$line[0]=~tr/;/|/;
						$line[0] =~ s/ /_/g;
						my $line=join("\t",@line);
						print OUT $line,"\n";
				}
				close IN;
				$hh++;
		}else{ next;}
}
close OUT;

my $subclass=-1;
my $subject=2;
 if(scalar(@class)>1){
		$subclass=2;
		$subject=3;
		my $n=2;
		while($n<scalar(@class)){
				$n++;
				$subclass++;
				$subject++;
		}
 }
 `rm $opts{i}/otu_taxa_table_L*.txt.2` ;
my $cmd="
cd $opts{o}
format_input.py  lefse_input.txt  lefse_format.txt  -f r -c 1 -s $subclass -u $subject -o 1000000
run_lefse.py lefse_format.txt lefse_LDA.xls 
plot_res.py lefse_LDA.xls lefse_LDA.pdf --dpi 300 --format pdf --width 8
plot_cladogram.py lefse_LDA.xls lefse_LDA.cladogram.pdf --format pdf 
";
`$cmd`;
