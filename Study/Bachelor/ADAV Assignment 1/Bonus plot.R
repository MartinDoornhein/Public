library(tidyverse)
# y = exp(b0 + b1*x)
lm_eqn <- function(diamonds){
  m <- glm(price ~ carat, diamonds, family = Gamma(link = "log"));
  eq <- substitute(italic(price) == italic(e)^(a + b %.% italic(carat)), 
                   list(a = format(unname(coef(m)[1]), digits = 2),
                        b = format(unname(coef(m)[2]), digits = 2)))
  as.character(as.expression(eq));
}

# Plot with formula annotated
ggplot(diamonds, aes(carat, price)) + 
  geom_point(aes(color=clarity), alpha = .5) +
  theme_classic() +
  labs(color = "Clarity scale", y = "Price in $", x = "Carat") +
  scale_x_continuous(trans='log10') +
  geom_smooth(method="glm",
              method.args=list(family=Gamma(link="log")), formula = y ~ x, colour = "white") +
  annotate(x = 0.3, y = 15000, geom = "text", label = lm_eqn(diamonds), parse = TRUE, size = 4) +
  ylim(0, max(diamonds$price))
