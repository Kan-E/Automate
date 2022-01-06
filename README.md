# automate

`automate` is an easy-to-use R package for automated data visualization. 

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
