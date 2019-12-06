test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

# [1] "goal"            "dimension"       "region_id"       "score"           "year"            "order_color"     "order_hierarchy"
# [8] "weight"          "name_supra"      "name_flower"     "pos"             "pos_end"         "pos_supra"       "plot_NA"

test_that("flower plot displays", {
    df <- data.frame(pos = 1:5,
                        group_var = c(1,1,1,1,1),
                        score = c(90, 80, 70, 60, 20),
                        weight = c(1, 1, 1, 1, 0.5),
                        goal = c("F", "A", "I", "R", "E"),
                        name_flower = c("Findable", "Accessible", "Interoperable", "Reusable", "Extra"),
                        name_supra = c(NA, NA, "Meta", "Meta", NA)
                        )
    expect_equal(ncol(df), 7)
    plot_flower(df, title = "Ha!")
})
