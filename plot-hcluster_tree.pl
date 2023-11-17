#!/usr/bin/perl -w

use strict;
use warnings;
my $VERSION = "v2.1-20210214";
use Getopt::Long;
my %opts;
GetOptions (\%opts,"i=s","m=s","o=s","d=s","w=i","h=i");

my $usage = <<"USAGE";
        Program : $0
        Version : $VERSION
        Contact : 
        Discription: plot tree from .tre file in newick format
        Usage:perl $0 [options]
                -i	*	distance  file 
		-m	hcluster method ,[average/single/complete].   default: average
		-o*	output dir
		-w	default:8
		-h	default:6	

        example:
USAGE
die $usage if ( !$opts{i} && !$opts{o});
$opts{m}=defined $opts{m}?$opts{m}:"average";
$opts{w}=defined $opts{w}?$opts{w}:8;
$opts{h}=defined $opts{h}?$opts{h}:6;
$opts{i}=~/([^\/]+)$/;
my $bn=$1;
if(! -e $opts{o}){
		`mkdir $opts{o}`;
}
open RCMD, ">hc.cmd.r";
print RCMD "
basename=paste(\"hcluster_tree\",\"$bn\",\"$opts{m}\",sep=\"_\")

# read otubased metics 
da <-read.table(\"$opts{i}\",sep=\"\\t\",head=T,check.names=F)
rownames(da) <-da[,1]
da <-da[,-1]

library(ape)

dist <-as.dist(da)
# hclust
hc <-hclust(dist,method=\"$opts{m}\") 
 
# tre1:
pdf=paste(\"$opts{o}/\",basename,\".pdf\",sep=\"\")
pdf(pdf,width=$opts{w},height=$opts{h})
par(mar=c(3,2,2,5))
tree <-as.dendrogram(hc)
plot(tree,type=\"rectangle\",horiz=TRUE)
dev.off()

# tre2
tr <-as.phylo.hclust(hc)
nwk <-paste(\"$opts{o}/\",basename,\".tre\",sep=\"\")
write.tree(tr,nwk)

";
`R --restore --no-save < hc.cmd.r`;

