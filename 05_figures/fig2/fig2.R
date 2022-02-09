#' Code to create figure 2.

source("05_figures/fig2/necrosis-manhattan-plot.R")
source("05_figures/fig2/relative_risk/relative_risk.R")

p1 <- ggarrange(plotlist = manh, labels = LETTERS[1:4])
p2 <- ggarrange(plotlist = relrisk, legend = "none" , labels = LETTERS[5:6], ncol=2)

png(
  filename = "05_figures/fig2/fig2.png",
  width = 18, height = 15, units = 'cm', res = 300
  )
  ggarrange( p1, p2, nrow = 2 , heights = c(3,2) )
  # ggarrange( p1, p2, ncol = 2 , widths = c(2,1) )
dev.off()
