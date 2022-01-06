#' Automated boxplot
#'
#' @importFrom rstatix group_by
#' @importFrom rstatix add_xy_position
#' @importFrom rstatix get_y_position
#' @importFrom rstatix tukey_hsd
#' @importFrom rstatix add_significance
#' @importFrom rstatix t_test
#' @importFrom gdata read.xls
#' @importFrom ggpubr ggboxplot
#' @importFrom ggpubr stat_pvalue_manual
#' @importFrom ggpubr facet
#' @importFrom ggplot2 element_rect
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 scale_y_continuous
#' @importFrom ggplot2 element_text
#' @importFrom ggplot2 scale_fill_grey
#' @importFrom tidyr gather
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#' @importFrom dplyr arrange
#' @importFrom multcomp glht
#' @importFrom multcomp mcp
#' @importFrom utils read.csv
#' @importFrom utils read.table
#' @importFrom utils write.table
#' @importFrom grDevices dev.off
#' @importFrom grDevices pdf
#' @import RColorBrewer
#' @param directory Directory including count matrix files
#' @param input excel or csv
#' @export
#'
autobox <- function(directory, input = "excel"){
  setwd(directory)
  if(input == "excel") files <- list.files(pattern = "*.xlsx")
  if(input == "csv") files <- list.files(pattern = "*.csv")
  files <- gsub("\\..+$", "", files)

  for (name in files) {
    dir.create(name,showWarnings = F)
    if(input == "excel") data.file <- paste(name, '.xlsx', sep = '')
    if(input == "csv") data.file <- paste(name, '.csv', sep = '')
    print(data.file)
    if(input == "excel") data <- read.xls(data.file)
    if(input == "csv") data <- read.csv(data.file,header = T, sep=",")
    collist <- gsub("\\_.+$", "", colnames(data))
    collist <- unique(collist[-1])
    rowlist <- gsub("\\_.+$", "", data[,1])
    rowlist <- unique(rowlist)
    data <- data %>% tidyr::gather(key=sample, value=value,-Row.names)
    data$sample<-gsub("\\_.+$", "", data$sample)
    data$Row.names <- as.factor(data$Row.names)
    data$sample <- as.factor(data$sample)
    data$value <- as.numeric(data$value)
    data$sample <- factor(data$sample,levels=collist,ordered=TRUE)

    if ((length(rowlist) > 81) && (length(rowlist) <= 100)) pdf_size <- 15
    if ((length(rowlist) > 64) && (length(rowlist) <= 81)) pdf_size <- 13.5
    if ((length(rowlist) > 49) && (length(rowlist) <= 64)) pdf_size <- 12
    if ((length(rowlist) > 36) && (length(rowlist) <= 49)) pdf_size <- 10.5
    if ((length(rowlist) > 25) && (length(rowlist) <= 36)) pdf_size <- 9
    if ((length(rowlist) > 16) && (length(rowlist) <= 25)) pdf_size <- 7.5
    if ((length(rowlist) > 12) && (length(rowlist) <= 16)) pdf_size <- 6
    if ((length(rowlist) > 9) && (length(rowlist) <= 12)) pdf_size <- 6
    if ((length(rowlist) > 6) && (length(rowlist) <= 9)) pdf_size <- 5
    if ((length(rowlist) > 1) && (length(rowlist) <= 6)) pdf_size <- 4
    if (length(rowlist) == 1) pdf_size <- 3
    if (length(rowlist) > 100) pdf_size <- 16.5

    df <- data.frame(matrix(rep(NA, 11), nrow=1))[numeric(0), ]
    colnames(df) <- c("Row.names", "group1", "group2", "term", "null.value","Std.Error","coefficients","t.value","p.adj","xmin", "xmax")
    if (length(collist) >= 3){
      stat.test <- data %>% group_by(Row.names)
      stat.test <- stat.test %>% tukey_hsd(value ~ sample)
      stat.test <- stat.test %>% add_significance("p.adj")
      stat.test <- stat.test %>% add_xy_position(scales = "free", step.increase = 0.2)
      for (name2 in rowlist){
        data2 <- dplyr::filter(data, Row.names == name2)
        dun <- aov(value~sample, data2)
        dunnette <- glht(model = dun, linfct=mcp(sample="Dunnett"))
        dunnette2 <- summary(dunnette)
        p.adj <- c()
        coefficients <- c()
        Std.Error <- c()
        t.value <- c()
        group1 <- c()
        group2 <- c()
        term <- c()
        null.value <- c()
        xmin <- c()
        xmax <- c()
        for (i in 1:(length(collist)-1)){
          p.adj <- c(p.adj, dunnette2[["test"]][["pvalues"]][i])
          coefficients <- c(coefficients, dunnette2[["test"]][["coefficients"]][i])
          Std.Error <- c(Std.Error, dunnette2[["test"]][["sigma"]][i])
          t.value <- c(t.value, dunnette2[["test"]][["tstat"]][i])
          group1 <- c(group1, c(collist[1]))
          group2 <- c(group2, c(collist[i+1]))
          term <- c(term, c("sample"))
          null.value <- c(null.value, 0)
          xmin <- c(xmin, c(1))
          xmax <- c(xmax, c(i+1))
        }
        df2 <- data.frame(Row.names = name2, group1 = group1, group2 = group2, term = term,
                          null.value = null.value, Std.Error = Std.Error, coefficients = coefficients,
                          t.value = t.value, p.adj = p.adj, xmin = xmin, xmax = xmax)
        df <- rbind(df, df2)
      }

      df <- df %>% arrange(Row.names)
      df <- df %>% group_by(Row.names)
      stat.test2 <- data %>% group_by(Row.names)
      stat.test2 <- stat.test2 %>% get_y_position(value ~ sample, scales = "free", step.increase = 0.15, fun = "mean_se")
      stat.test2 <- stat.test2 %>% dplyr::filter(group1 == collist[1])
      stat.test3 <- cbind(stat.test2,df[,-1:-3])
      stat.test3$Row.names <- as.factor(stat.test3$Row.names)
      stat.test3 <- stat.test3 %>% add_significance("p.adj")

      image.file <- paste0(paste0(name, "/"), paste0(name, '_TukeyHSD.pdf'))
      pdf(image.file, height = pdf_size, width = pdf_size)
      p <- ggboxplot(data,x = "sample", y = "value",fill = "sample",
                             scales = "free", add = "jitter",
                             add.params = list(size=0.5),
                             xlab = FALSE, legend = "none", ylim = c(0, NA))
      plot(facet(p, facet.by = "Row.names",
                 panel.labs.background = list(fill = "transparent", color = "transparent"),
                 scales = "free", short.panel.labs = T)+
             stat_pvalue_manual(stat.test,hide.ns = T, size = 3) +
             theme(axis.text.x= element_text(size = 5),
                   axis.text.y= element_text(size = 7),
                   panel.background = element_rect(fill = "transparent", size = 0.5),
                   title = element_text(size = 7),text = element_text(size = 10)))
      dev.off()
      image.file2 <- paste0(paste0(name, "/"), paste0(name, '_dunnett.pdf'))
      pdf(image.file2, height = pdf_size, width = pdf_size)
      p <- ggboxplot(data,x = "sample", y = "value",fill = "sample",scales = "free",
                     add = "jitter", add.params = list(size=0.5), xlab = FALSE,
                     legend = "none", ylim = c(0, NA))
      plot(facet(p, facet.by = "Row.names",
                 panel.labs.background = list(fill = "transparent", color = "transparent"),
                 scales = "free", short.panel.labs = T)+
             stat_pvalue_manual(stat.test3,hide.ns = T, size = 3) +
             theme(axis.text.x= element_text(size = 5),
                   axis.text.y= element_text(size = 7),
                   panel.background = element_rect(fill = "transparent", size = 0.5),
                   title = element_text(size = 7), text = element_text(size = 10)))
      dev.off()
      test.file <- paste0(name, "/result_TukeyHSD.txt")
      write.table(stat.test[,1:10], file = test.file, row.names = F, col.names = T, quote = F, sep = "\t")
      dunnett_file <- paste0(name, "/result_dunnett.txt")
      write.table(stat.test3[,-4:-5], file = dunnett_file, row.names = F, col.names = T, quote = F, sep = "\t")
    }else{
      stat.test <- data %>% group_by(Row.names)
      stat.test <- stat.test %>% t_test(value ~ sample)
      stat.test <- stat.test %>% add_significance()
      stat.test <- stat.test %>% add_xy_position(scales = "free", step.increase = 0.2)
      image.file <- paste0(paste0(name, "/"), paste0(name, '_Welch_t-test.pdf'))
      pdf(image.file, height = pdf_size, width = pdf_size)
      p <- ggboxplot(data,x = "sample", y = "value",fill = "sample",
                     scales = "free", add = "jitter",
                     add.params = list(size=0.5),
                     xlab = FALSE, legend = "none", ylim = c(0, NA))
      plot(facet(p, facet.by = "Row.names",
                 panel.labs.background = list(fill = "transparent", color = "transparent"),
                 scales = "free", short.panel.labs = T)+
             stat_pvalue_manual(stat.test,hide.ns = T, size = 3) +
             theme(axis.text.x= element_text(size = 5),
                   axis.text.y= element_text(size = 7),
                   panel.background = element_rect(fill = "transparent", size = 0.5),
                   title = element_text(size = 7),text = element_text(size = 10)))
      dev.off()
      test.file <- paste0(name, "/result_Welch_t-test.txt")
      write.table(stat.test[,1:10], file = test.file, row.names = F, col.names = T, quote = F, sep = "\t")
    }
    file.copy(data.file, to = paste0(name,"/"))
    file.remove(data.file)
  }
}
