# ============================================================
# Título: Rendimientos accionarios en R
# Subtítulo: Descarga y visualización
# Autor: Dr. Martin Lozano (https://mlozanoqf.github.io/)
# Fuente: rend.Rmd
# Nota: Script companion para copiar/pegar código sin numeración.
# ============================================================


# ---- Paquetes ----
library(tidyquant)
library(dplyr)
library(lubridate)
library(tidyr)
library(ggplot2)


# ---- Descargar precios y transformar a rendimientos ----
symbols <- c("GOOGL", "META", "WMT", "KO", "NKE")

annual_returns <- tq_get(symbols,
                         from = "2020-01-01",
                         to   = "2024-12-31") |>
  group_by(symbol) |>
  tq_transmute(select      = adjusted,
               mutate_fun  = periodReturn,
               period      = "yearly",
               type        = "arithmetic",
               col_rename  = "annual_return") |>
  mutate(year          = year(date),
         annual_return = round(annual_return, 4)) |>
  select(-date) |>
  arrange(symbol, year)

annual_returns


# ---- Visualizar en tabla ----
annual_returns_wide <- annual_returns |>
  mutate(year = as.character(year)) |>
  pivot_wider(names_from = year, values_from = annual_return)

annual_returns_wide


# ---- Datos en sección cruzada ----
annual_returns |>
  filter(year == 2024) |>
  mutate(direction = if_else(annual_return >= 0, "positive", "negative")) |>
  ggplot(aes(x = symbol, y = annual_return, fill = direction)) +
  geom_col(width = 0.7) +
  geom_hline(yintercept = 0) +
  scale_fill_manual(values = c(positive = "blue", negative = "red")) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(title = "Rendimiento anual por empresa en el 2024.",
       x = "Simbolo",
       y = "Rendimiento") +
  theme_minimal() +
  theme(legend.position = "none")


# ---- Datos en serie de tiempo ----
annual_returns |>
  ungroup() |>
  filter(symbol == "GOOGL") |>
  mutate(direction = if_else(annual_return >= 0, "positive", "negative")) |>
  ggplot(aes(x = factor(year), y = annual_return, fill = direction)) +
  geom_hline(yintercept = 0) +
  geom_col(width = 0.6) +
  scale_fill_manual(values = c(positive = "blue", negative = "red")) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                     expand = expansion(mult = c(0.05, 0.15))) +
  labs(title = "Rendimiento anual de GOOGL.",
       x = "Ano",
       y = "Rendimiento") +
  theme_minimal() +
  theme(legend.position = "none")


# ---- Datos de panel ----
legend_order <- annual_returns |>
  filter(year == 2024) |>
  arrange(desc(annual_return)) |>
  pull(symbol)

annual_returns |>
  ungroup() |>
  mutate(symbol = factor(symbol, levels = legend_order)) |>
  ggplot(aes(x = year, y = annual_return, color = symbol)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.2) +
  scale_color_brewer(palette = "Set1") +
  scale_x_continuous(breaks = seq(2020, 2024, by = 1)) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1),
                     expand = expansion(mult = c(0.05, 0.15))) +
  labs(title = "Evolucion del rendimiento anual por empresa.",
       x = "Ano",
       y = "Rendimiento",
       color = "Simbolo") +
  theme_minimal()


# ---- Datos de panel: visualización alternativa ----
annual_returns |>
  ggplot(aes(x = year, y = symbol, fill = annual_return)) +
  geom_tile(color = "white") +
  scale_fill_viridis_c(option = "C",
                       begin = 0.1, end = 0.9,
                       labels = scales::percent_format(accuracy = 1)) +
  labs(title = "Rendimiento anual por empresa",
       x = "Ano",
       y = "Empresa",
       fill = "Rendimiento") +
  theme_minimal()


# ---- Rendimientos acumulados ----
cumulative_returns <- annual_returns |>
  ungroup() |>
  arrange(symbol, year) |>
  group_by(symbol) |>
  mutate(cum_value = cumprod(1 + annual_return)) |>
  ungroup() |>
  mutate(symbol = factor(symbol, levels = legend_order))

legend_order_cum <- cumulative_returns |>
  filter(year == max(year)) |>
  arrange(desc(cum_value)) |>
  pull(symbol)

cumulative_with_start <- cumulative_returns |>
  mutate(symbol = factor(symbol, levels = legend_order_cum)) |>
  select(symbol, year, cum_value) |>
  bind_rows(
    annual_returns |>
      distinct(symbol) |>
      mutate(year = 2019, cum_value = 1,
             symbol = factor(symbol, levels = legend_order_cum))
  ) |>
  arrange(symbol, year)

cumulative_with_start


# ---- Gráfico de rendimientos acumulados ----
cumulative_with_start |>
  ggplot(aes(x = year, y = cum_value, color = symbol)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.2) +
  scale_color_brewer(palette = "Set1") +
  scale_x_continuous(breaks = c(2019, seq(2020, 2024)),
                     labels = c("t=0", 2020:2024)) +
  scale_y_continuous(labels = scales::dollar_format(accuracy = 1),
                     expand = expansion(mult = c(0.05, 0.15))) +
  labs(title = "Evolucion de una inversion de $1.",
       x = "Ano",
       y = "Valor acumulado",
       color = "Simbolo") +
  theme_minimal()


# ---- Rendimientos acumulados: visualización alternativa ----
initial_point <- annual_returns |>
  distinct(symbol) |>
  mutate(year = 2019,
         cum_value = 1,
         symbol = factor(symbol, levels = legend_order_cum))

cumulative_facets <- cumulative_returns |>
  mutate(symbol = factor(symbol, levels = legend_order_cum)) |>
  select(symbol, year, cum_value) |>
  bind_rows(initial_point) |>
  arrange(symbol, year) |>
  mutate(year = factor(year, levels = c(2019, 2020:2024),
                       labels = c("t=0", 2020:2024)))

cumulative_facets


# ---- Gráfico alternativo de rendimientos acumulados ----
cumulative_facets |>
  ggplot(aes(x = year, y = cum_value)) +
  geom_col(width = 0.65, fill = "blue", color = NA) +
  geom_text(aes(label = scales::dollar(cum_value, accuracy = 0.01)),
            vjust = -0.4, size = 3) +
  scale_y_continuous(labels = scales::dollar_format(accuracy = 1),
                     expand = expansion(mult = c(0.05, 0.20))) +
  facet_wrap(~ symbol, ncol = 3) +
  labs(title = "Valor acumulado de una inversion de $1.",
       x = NULL,
       y = "Valor acumulado") +
  theme_minimal(base_size = 11) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.border = element_rect(color = "gray", fill = NA, linewidth = 0.6),
        strip.text = element_text(face = "bold"),
        legend.position = "none")
