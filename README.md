# Facial_morphology

Using dlib library to detect facial landmarks. Then preprocessing the landmarks through standardization and predict the facial masculinity score through a pre-trained randomforest model from devgene conhort with 577 individuals.

## Set up enviroment for dlib in ubuntu

Recommanded installation steps (assume you already install the python):

Install anaconda:
```
conda install -c anaconda anaconda-navigator
```
Install dlib library:
```
conda install -c menpo dlib
```

## Landmarks detection and Masculinity score analyzation
Traverse to the 'src' folder and compile the Rscript through console command:
```
Rscript Masc_measure.R   ../Masc_measure/data       pheno.txt           output.txt
```
	
	   (Script)          (image folder path)    (phenotype file path)   (output file name)


In specifically, for now, only processing images in "jpg" format.

phenotype file format need to be:   1>no quote 2>tab delimited 3>exact same column name 4> only read sex label 'F' or 'M'
```
Sex	Age
F	21
F	20
F	24
F	16
F	14
F	26
F	21
F	20
F	24
F	16
F	14
F	26

```
Sample Output file format:  Masculinity score was adjusted by sex and age through linear model
```
ID	masc_cor
SCUT-FBP-12	-0.0454181267282728
SCUT-FBP-2	-0.0212517195265082
SCUT-FBP-5	-0.0316231558517763
SCUT-FBP-4	-0.0437128130023185
SCUT-FBP-3	-0.0608679230382388
SCUT-FBP-7	-0.0186755851611953
SCUT-FBP-9	0.0649818732717272
SCUT-FBP-10	0.0141482804734918
SCUT-FBP-8	-0.0226231558517763
SCUT-FBP-6	0.00628718699768155
SCUT-FBP-1	0.0889320769617612
SCUT-FBP-11	0.0455244148388048
```
**Notice(sample images were provided under data folder for testing)**
