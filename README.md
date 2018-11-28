# Facial_morphology

Using dlib library to detect facial landmarks. Then preprocessing the landmarks through standardization and predict the facial masculinity score through randomforest classification method.

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

phenotype file format need to be:   1>no quote 2>tab delimited 3>exact same column name
```
Sex	Age
F	21
F	20
M	24
M	16
M	14
M	26
F	21
F	20
M	24
M	16
M	14
M	26

```
Sample Output file format:  Masculinity score was adjusted by sex and age through linear model
```
ID	masc_cor
SCUT-FBP-12	0.0932385254543651
SCUT-FBP-2	-0.0499257344723552
SCUT-FBP-5	0.125742245447857
SCUT-FBP-4	0.0791807280867267
SCUT-FBP-3	0.187261122928649
SCUT-FBP-7	-0.0441583546325457
SCUT-FBP-9	-0.165854261457971
SCUT-FBP-10	0.122541470475961
SCUT-FBP-8	0.023661957988755
SCUT-FBP-6	-0.0243623641428185
SCUT-FBP-1	-0.263895104788309
SCUT-FBP-11	-0.0834302308883156
```
**Notice(sample images were provided under data folder for testing)**
