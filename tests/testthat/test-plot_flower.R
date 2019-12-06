test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

# [1] "goal"            "dimension"       "region_id"       "score"           "year"            "order_color"     "order_hierarchy"
# [8] "weight"          "name_supra"      "name_flower"     "pos"             "pos_end"         "pos_supra"       "plot_NA"

test_that("flower plot displays", {
    library(flowers)
    library(dplyr)
    df <- data.frame(order = c(1, 4, 3, 2),
                        score = c(90, 80, 70, 60),
                        weight = c(1, 1, 1, 1),
                        goal = c("F", "A", "I", "R"),
                        name_flower = c("Findable", "Accessible", "Interoperable", "Reusable"),
                        name_supra = c(NA, NA, "Meta", "Meta"),
                        stringsAsFactors = FALSE) %>% arrange(order)
    expect_equal(ncol(df), 6)
    plot_flower(df, title = "FAIR Metrics")

    data(ohi)
    plot_flower(ohi, "OHI Example")
})
