# rnv-log-overview
convert several "log" rnv files into a csv file
##Instruction##
1. save the output error of rnv into a file or several files (this file must be contains in a folder)
2. execute main.rb the first arg is mandatory and it is the path to the folder who contains log
3. the second argument correspond to the xmllint output error it is optional but this output error must be contains to a distinct file and folder to rnv logs
4. the output is a .csv with the different error and the set of files with this error

##Example##

`ruby main.rb test xmllint.log`
