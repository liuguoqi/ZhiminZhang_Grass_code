# ZhiminZhang_Grass_code

        Program : plot-hcluster_tree.pl
        Version : v2.1-20210214
        Contact : 
        Discription: plot tree from .tre file in newick format
        Usage:perl plot-hcluster_tree.pl [options]
                -i	*	distance  file 
		-m	hcluster method ,[average/single/complete].   default: average
		-o*	output dir
		-w	default:8
		-h	default:6	



       Program : plot-pcoa.pl   
       Discription:   
       Version : v2.1-20210214
       Contact : 
       Usage :perl plot-pcoa.pl [options]		
			-i	 * input distance matrix 
			-o * output dir
			-m	input mapping file if you want set points's color and pch by groups. default:none
			-g	group name in mapping file . default:none
			-e	draw ecclipse number,default :0
			-w      default:6
			-h      default:6
			-pc	pc to be draw ,default: 1-2
			-lp     legend place;default:topright
                        -l      T/F; display samplename or not when -m setted;default:T


       Program : plot-lefse.pl   
       Discription:   
       Version : v2.20211024
       Contact : 
       Usage :perl plot-lefse.pl [options]		
			-i	* input tax_summary directory with otu_taxa_table_L?.txt from summarize_taxa.py of qiime. 
			-o	* output dir
			-m	* input mapping file to set samples groups
			-g	* group name in mapping file . class or class-subclss.
			-l			max levels .default:6



