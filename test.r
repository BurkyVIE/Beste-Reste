# Tracking Thomas' COVID19 test

library(tidyverse)
library(lubridate)

tests <- tribble(~Zeit, ~Art,
                 "5/12/2020 15.40", "Ag", 
                 "23/12/2020 16.31", "Ag", 
                 "9/1/2021 10.33", "Ag", 
                 "17/1/2021 9.18", "Ag", 
                 "23/1/2021 9.20", "Ag",
                 "30/1/2021 9.25", "Ag",
                 "7/2/2021 15.59", "Ag",
                 "13/2/2021 9.48", "Ag",
                 "20/2/2021 9.55", "Ag",
                 "25/2/2021 18.04", "Ag",
                 "27/2/2021 9.57", "Ag",
                 "6/3/2021 9.44", "Ag",
                 "12/3/2021 16.26", "Ag",
                 "18/3/2021 4.46", "PCR",
                 "20/3/2021 9.48", "Ag",
                 "21/3/2021 18.08", "Ag",
                 "23/3/2021 4.58", "PCR",
                 "25/3/2021 5.01", "PCR",
                 "28/3/2021 9.20", "Ag",
                 "29/3/2021 7.42", "PCR",
                 "1/4/2021 6.21", "PCR") %>%
  mutate(Zeit = dmy_hm(Zeit, tz = "Europe/Vienna"),
         Dauer = case_when(Art == "Ag" ~ 48,
                           TRUE ~ 72),
         Bis = Zeit + lubridate::hours(Dauer)) %>%
  rownames_to_column(., var = "He") %>%
  mutate(He = ((as.numeric(He) - 1) %% 3 + 1) * .05)

ggplot(data = tests) +
  geom_rect(mapping = aes(xmin = Zeit, xmax = Bis, ymin = 0, ymax = 1, fill = Art), alpha = .85) +
  geom_errorbarh(mapping = aes(y = He, xmin = Zeit, xmax = Bis), height = .02, color = "navy") +
  geom_vline(xintercept = now(), linetype = "dotted", size = 1, color = "orangered") +
  geom_label(x = now(), y = .85, label = str_replace(string = now(), pattern = " ", replacement = "\n"), size = 3, color = "orangered") +
  scale_x_datetime(name = "Zeit [-90d ... jetzt ... +5d]", limits = c(now() - days(90), now() + days(5)), expand = c(.01, .01)) + 
  scale_y_continuous(name = "'Schutz'", breaks = c(0, 1), minor_breaks = NULL, expand = c(.015, .015)) +
  scale_fill_manual(name = "Testart", values = set_names(x = RColorBrewer::brewer.pal(3, "YlGn")[-1],
                                                         nm = c("Ag", "PCR"))) +
  labs(title = "COVID-19 Tests", subtitle = "Thomas") +
  theme_minimal()-> p

windows(16, 5)
plot(p)

rm(p)
