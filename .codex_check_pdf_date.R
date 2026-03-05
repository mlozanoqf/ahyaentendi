.libPaths(c(normalizePath('.r_libs'), .libPaths()))
if(!requireNamespace('pdftools', quietly=TRUE)) install.packages('pdftools', repos='https://cloud.r-project.org')
txt <- pdftools::pdf_text('capm_ini.pdf')
cat(paste(strsplit(txt[1], '\n')[[1]][1:14], collapse='\n'))
