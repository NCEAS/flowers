test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("flower plot displays", {
    library(flowers)
    library(dplyr)
    df <- data.frame(order = c(1, 4, 3, 2),
                        score = c(90, 80, 70, 60),
                        weight = c(1, 1, 1, 1),
                        goal = c("F", "A", "I", "R"),
                        name_flower = c("Findable", "Accessible", "Interoperable", "Reusable"),
                        name_supra = c(NA, NA, NA, NA),
                        stringsAsFactors = FALSE) %>% arrange(order)
    expect_equal(ncol(df), 6)
    plot_flower(df, title = "FAIR Metrics")
    d1_colors <- c( "#c70a61", "#ff582d", "#1a6379", "#60c5e4")
    plot_flower(df, title = "FAIR Metrics", fixed_colors=TRUE, colors = d1_colors)

    data(ohi)
    plot_flower(ohi, "OHI Example")
})
