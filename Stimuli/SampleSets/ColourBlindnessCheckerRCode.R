#written by Tess Barich to check colour contrasts 
library(colorBlindness)

cols=c("#219DFF" , "#FF0000", "#20EF49","#FFFF00","#8000FF","#FF0080")
 
RedVsGreen=c("#FF0000" , "#20EF49")
GreenVsBlue=c("#20EF49" , "#219DFF")
YellowVsBlue=c("#FFFF00" , "#219DFF")
RedVsBlue=c("#FF0000" , "#219DFF")
PurpleVsMagenta=c("#8000FF","#FF0080")

displayAllColors(cols,types = c("deuteranope", "protanope", "desaturate"),color="white")
displayAllColors(RedVsGreen,types = c("deuteranope", "protanope", "desaturate"),color="white")
displayAllColors(GreenVsBlue,types = c("deuteranope", "protanope", "desaturate"),color="white")
displayAllColors(YellowVsBlue,types = c("deuteranope", "protanope", "desaturate"),color="white")
displayAllColors(RedVsBlue,types = c("deuteranope", "protanope", "desaturate"),color="white")
displayAllColors(PurpleVsMagenta,types = c("deuteranope", "protanope", "desaturate"),color="white")
