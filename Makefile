.PHONY: clean

clean:
	rm -f output/*
	rm -f stipends_cleaned.csv
	rm -f Report.html

stipends_cleaned.csv: stipends.csv Project_Skeleton.R
	Rscript Project_Skeleton.R

output/Overall_Pay_by_Department.png output/Overall_Pay_across_Years.png\
 output/top_10_stipend_University.png output/bottom_10_stipend_University.png: stipends_cleaned.csv Project_figures.R
	Rscript Project_figures.R
	
Report.html: Report.Rmd output/Overall_Pay_by_Department.png output/Overall_Pay_across_Years.png\
 output/top_10_stipend_University.png output/bottom_10_stipend_University.png
	R -e "rmarkdown::render('Report.Rmd')"