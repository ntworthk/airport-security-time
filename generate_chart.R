library(tidyverse)

offset <- 0.02

g <- read_rds("data/sydney-wait-time.rds") |> 
  as_tibble() |> 
  mutate(time = with_tz(time, tzone = "Australia/Sydney")) |> 
  group_by(dow = wday(date, label = TRUE, week_start = 1), hour = hour(time), terminal) |> 
  summarise(value = mean(value), .groups = "drop") |> 
  mutate(value = case_when(
    terminal == "Terminal 1" ~ value + offset,
    terminal == "Terminal 2" ~ value + 0.00,
    terminal == "Terminal 3" ~ value - offset
  )) |> 
  ggplot(aes(x = hour, y = value, colour = terminal)) +
  geom_step(linewidth = 0.7) +
  facet_wrap(~dow) +
  scale_x_continuous(breaks = seq.int(0, 23, 6)) +
  scale_y_continuous(expand = expansion(mult = c(0.001, 0.05)), labels = NULL, breaks = NULL) +
  scale_colour_manual(values = c("#6A5ACD", "#20B2AA", "#FFD700")) +
  labs(y = "Security wait time (mins)", colour = NULL, x = NULL) +
  theme_minimal(base_size = 16) +
  theme(
    panel.background = element_rect(fill = "#FFE5B4", colour = NA),
    plot.background = element_rect(fill = "#FFE5B4", colour = NA),
    panel.grid.major = element_line(color = "#B0A8B9", size = 0.1),
    panel.grid.minor = element_blank(),
    legend.background = element_blank(),
    legend.position = "bottom",
    legend.margin = margin(-10, 0, 0, 0)
  )

ggsave(filename = "g.png",
       plot = g,
       width = 17.00,
       height = 17,
       units = "cm",
       bg = "transparent"
)
