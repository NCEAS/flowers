test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

# [1] "goal"            "dimension"       "region_id"       "score"           "year"            "order_color"     "order_hierarchy"
# [8] "weight"          "name_supra"      "name_flower"     "pos"             "pos_end"         "pos_supra"       "plot_NA"

test_that("flower plot displays", {
    df <- data.frame(order = c(1, 4, 3, 2),
                        score = c(90, 80, 70, 60),
                        weight = c(1, 1, 1, 1),
                        goal = c("F", "A", "I", "R"),
                        name_flower = c("Findable", "Accessible", "Interoperable", "Reusable"),
                        name_supra = c(NA, NA, "Meta", "Meta")
                        )
    expect_equal(ncol(df), 6)
    plot_flower(df, title = "FAIR Metrics")
    df_sorted <- df %>% arrange(name_flower)
    plot_flower(df_sorted, title = "FAIR Metrics")
    df_sorted2 <- df %>% arrange(order)
    plot_flower(df_sorted2, title = "FAIR Metrics")

    ohi2 <- read.csv("ohi.csv", stringsAsFactors = FALSE)
    plot_flower(ohi2, "OHI Example")
})
