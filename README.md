[![R-CMD-check](https://github.com/Kan-E/Automate/workflows/R-CMD-check/badge.svg)](https://github.com/Kan-E/Automate/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/Kan-E/Automate/blob/master/LICENSE.md)
# automate

`automate` is an easy-to-use R package for automated data visualization from count matrix files.   
It has three simplyfied functions for creation of barplot, boxplot, and errorplot.
The condition number is automatically recognized from count matrix file and then the static analysis is performed.
In the case of pairwise comparison, Welch t-test is performed.
In the case of multiple comparison, TukeyHSD and dunnett test are performed.

# Input file format
Input file format must be excel file format (.xlsx) or CSV file format (.csv).
The cell at first column must be `Row.names`.
Replication number is represented by underbar. Do not use it for anything else.
<img width="890" alt="format example" src="https://user-images.githubusercontent.com/77435195/148402453-e87ce92e-fcf1-4d45-af72-e9d256366bfa.png">

# Output example
![example](https://user-images.githubusercontent.com/77435195/148407981-75873d95-eb04-458c-9a99-db769d7efa3f.png)
Plot example (TukeyHSD)
![example_TukeyHSD](https://user-images.githubusercontent.com/77435195/148402886-16a48e4c-8962-4066-95bc-a6d26e7fada9.png)
Statics example (TukeyHSD)
<img width="810" alt="result_TukeyHSD" src="https://user-images.githubusercontent.com/77435195/148403003-658bdf78-dcd9-4186-a392-8e6e5b2f7cc7.png">

# Installation
```
install.packages("devtools")
install.packages("ggpubr")
devtools::install_github("Kan-E/automate")
```

# Usage
```
library(automate)
library(ggpubr)

autobar(directory,          ## directory including count matrix files
        input = "excel")    ## One of excel or csv
autobox(directory,          ## directory including count matrix files
        input = "excel")    ## One of excel or csv
autoerror(directory,        ## directory including count matrix files
        input = "excel")    ## One of excel or csv
```

# Reference
ggplot2 and ggpubr (for barplot, boxplot, and errorplot)
- H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.
- Alboukadel Kassambara (2020). ggpubr: 'ggplot2' Based Publication Ready Plots. R package version 0.4.0. https://CRAN.R-project.org/package=ggpubr

dplyr and tidyr (for data manipulation)
- Hadley Wickham, Romain François, Lionel Henry and Kirill Müller (2021). dplyr: A Grammar of Data Manipulation. R package version 1.0.7. https://CRAN.R-project.org/package=dplyr
- Hadley Wickham (2021). tidyr: Tidy Messy Data. R package version 1.1.3. https://CRAN.R-project.org/package=tidyr

rstatix and multcomp (for statics)
- Alboukadel Kassambara (2021). rstatix: Pipe-Friendly Framework for Basic Statistical Tests. R package version 0.7.0. https://CRAN.R-project.org/package=rstatix
- Torsten Hothorn, Frank Bretz and Peter Westfall (2008). Simultaneous Inference in General Parametric Models. Biometrical Journal 50(3), 346--363.

# Author

Kan Etoh
<kaneto@kumamoto-u.ac.jp>
