#' Flower plot
#'
#' @param .Data data frame containing scores to be plotted. Column names should include
#' "score", "weight", "name_supra", and "name_flower"
#' @param title optional title for the plot
#' @param legend_include logical, whether to include a plot legend, defaults to TRUE
#' @param colors an optional color palette to be used for the petal colors
#' @param fixed_colors if TRUE, then use a discrete fixed color palette for coloring petals
#' based on petal categories; defaults to FALSE,
#' @param filename if not NA, save the figure using this filename (relative or absolute)
#'
#' @return ggplot object of the flowerplot
#'
#' @import dplyr
#' @import ggplot2
#' @export
#'
#' @examples
#'
#' data(ohi)
#' plot_flower(ohi, "OHI Example")
#'
plot_flower <- function(.Data,
                        title           = NA,
                        legend_include  = TRUE,
                        colors          = NA,
                        fixed_colors    = FALSE,
                        filename        = NA) {

    # Sanity checking on our data frame
    stopifnot(
        all(c("score", "weight", "name_flower", "name_supra") %in% colnames(.Data)),
        all(!is.na(.Data$name_flower)),
        is.numeric(.Data$score),
        is.numeric(.Data$weight)
    )

    blank_circle_rad <- 42
    light_line <- 'grey90'
    white_fill <- 'white'
    light_fill <- 'grey80'
    med_line   <- 'grey50'
    med_fill   <- 'grey52'
    dark_line  <- 'grey20'
    dark_fill  <- 'grey22'

    ## Default color palette ----
    if (missing(colors)) {
        reds <-  grDevices::colorRampPalette(
            c("#A50026", "#D73027", "#F46D43", "#FDAE61", "#FEE090"), space="Lab")(65)
        blues <-  grDevices::colorRampPalette(
            c("#E0F3F8", "#ABD9E9", "#74ADD1", "#4575B4", "#313695"))(35)
        colors <- c(reds, blues)
    }

    ## set up positions for the bar centers:
    ## cumulative sum of weights (incl current) minus half the current weight
    .Data <- .Data %>%
        dplyr::mutate(pos   = sum(weight) - (cumsum(weight) - 0.5 * weight)) %>%
        dplyr::mutate(pos_end = sum(weight)) %>%
        dplyr::group_by(name_supra) %>%
        ## calculate position of supra goals before any unequal weighting (ie for FP)
        dplyr::mutate(pos_supra  = ifelse(!is.na(name_supra), mean(pos), NA)) %>%
        dplyr::ungroup() %>%
        dplyr::filter(weight != 0) %>%
        ## set up for displaying NAs
        dplyr::mutate(plot_NA = ifelse(is.na(score), 100, NA))

    p_limits <- c(0, .Data$pos_end[1])

    ## create supra goal dataframe for position and labeling ----
    supra <- .Data %>%
        dplyr::mutate(name_supra = ifelse(is.na(name_supra), name_flower, name_supra)) %>%
        dplyr::mutate(name_supra = paste0(name_supra, "\n")) %>%
        dplyr::select(name_supra, pos_supra) %>%
        unique() %>%
        as.data.frame()

    ## calculate arc: stackoverflow.com/questions/38207390/making-curved-text-on-coord-polar ----
    supra_df <- supra %>%
        dplyr::mutate(myAng = seq(-70, 250, length.out = dim(supra)[1])) %>%
        dplyr::filter(!is.na(pos_supra))

    # Get list of goal labels
    goal_labels <- .Data %>%
        dplyr::select(goal, name_flower)

    ## set up basic plot parameters ----
    ifelse(fixed_colors,
        fill_var <- 'name_flower',
        fill_var <- 'score'
    )
    plot_obj <- ggplot2::ggplot(data = .Data,
                                ggplot2::aes_(x = as.name('pos'),
                                              y = as.name('score'),
                                              fill = as.name(fill_var),
                                              width = as.name('weight')))

    ## sets up the background/borders to the external boundary (100%) of plot
    plot_obj <- plot_obj +
        ggplot2::geom_bar(ggplot2::aes(y = 100),
                          stat = 'identity', color = light_line, fill = white_fill, size = .2) +
        ggplot2::geom_errorbar(ggplot2::aes(x = pos, ymin = 100, ymax = 100, width = weight),
                               size = 0.5, color = light_line, show.legend = NA)

    ## lays any NA bars on top of background, with darker grey:
    if(any(!is.na(.Data$plot_NA))) {
        plot_obj <- plot_obj +
            ggplot2::geom_bar(ggplot2::aes(x = pos, y = plot_NA),
                              stat = 'identity', color = light_line, fill = light_fill, size = .2)
    }

    ## establish the basics of the flower plot
    plot_obj <- plot_obj +
        ## plot the actual scores on top of background/borders:
        ggplot2::geom_bar(stat = 'identity', color = dark_line, size = .2) +
        ## emphasize edge of petal
        ggplot2::geom_errorbar(ggplot2::aes(x = pos, ymin = score, ymax = score),
                               size = 0.5, color = dark_line, show.legend = NA) +
        ## plot zero as a baseline:
        ggplot2::geom_errorbar(ggplot2::aes(x = pos, ymin = 0, ymax = 0),
                               size = 0.5, color = dark_line, show.legend = NA) +
        ## turn linear bar chart into polar coordinates start at 90 degrees (pi*.5)
        ggplot2::coord_polar(start = pi * 0.5) +
        ## use weights to assign widths to petals:
        ggplot2::scale_x_continuous(labels = .Data$goal, breaks = .Data$pos, limits = p_limits) +
        ggplot2::scale_y_continuous(limits = c(-blank_circle_rad, ifelse(first(goal_labels == TRUE) | is.data.frame(goal_labels), 150, 100)))

    ## set petal colors, use a discrete scale if fixed_colors=TRUE, otherwise continuous gradient
    ifelse(fixed_colors,
        plot_obj <- plot_obj + ggplot2::scale_fill_manual(values = colors),
        plot_obj <- plot_obj + ggplot2::scale_fill_gradientn(colours=colors, na.value="black", limits = c(0, 100))
    )

    ## If not provided, use the mean score
    mean_score <- round(mean(.Data$score, na.rm = TRUE))

    ## add center number
    plot_obj <- plot_obj +
        ggplot2::geom_text(data = .Data,
                           inherit.aes = FALSE,
                           ggplot2::aes(label = mean_score),
                           x = 0, y = -blank_circle_rad,
                           hjust = .5, vjust = .5,
                           size = 12,
                           color = dark_line)
    if(!is.na(title)) {
        plot_obj <- plot_obj +
            ggplot2::labs(title = title)
    }


    ### clean up the theme
    plot_obj <- plot_obj +
        flower_theme() +
        ggplot2::theme(panel.grid.major = ggplot2::element_blank(),
                       axis.line  = ggplot2::element_blank(),
                       axis.text  = ggplot2::element_blank(),
                       axis.title = ggplot2::element_blank())

    ## add goal names
    plot_obj <- plot_obj +
        ggplot2::geom_text(ggplot2::aes(label = name_flower, x = pos, y = 120),
                           hjust = .5, vjust = .5,
                           size = 3,
                           color = dark_line)


    ## position supra arc and names. x is angle, y is distance from center
    supra_rad  <- 145  ## supra goal radius from center

    if(nrow(supra_df) > 0) {
        plot_obj <- plot_obj +
            ## add supragoal arcs
            ggplot2::geom_errorbar(data = supra_df, inherit.aes = FALSE,
                                   ggplot2::aes(x = pos_supra, ymin = supra_rad, ymax = supra_rad),
                                   size = 0.25, show.legend = NA) +
            ggplot2::geom_text(data = supra_df, inherit.aes = FALSE,
                               ggplot2::aes(label = name_supra, x = pos_supra, y = supra_rad, angle = myAng),
                               hjust = .5, vjust = .5,
                               size = 3,
                               color = dark_line)
    }

    # exclude legend if argument is legend=FALSE
    if(!legend_include | fixed_colors){
        plot_obj <- plot_obj +
            ggplot2::theme(legend.position="none")
    }

    ### display/save options: print to graphics, save to file
    print(plot_obj)

    ## save plot if a filename is provided
    if(!is.na(filename)) {
        suppressWarnings(
            ggplot2::ggsave(filename = filename,
                            plot = plot_obj,
                            device = "png",
                            height = 6, width = 8, units = 'in', dpi = 300)
        )
    }

    # ...then return the plot object for further use
    return(invisible(plot_obj))
}


flower_theme <- function(base_size = 9) {
    ggplot2::theme(axis.ticks = ggplot2::element_blank(),
                   text             = ggplot2::element_text(family = 'Helvetica', color = 'gray30', size = base_size),
                   plot.title       = ggplot2::element_text(size = ggplot2::rel(1.25), hjust = 0.5, face = 'bold'),
                   panel.background = ggplot2::element_blank(),
                   legend.position  = 'right',
                   panel.border     = ggplot2::element_blank(),
                   panel.grid.minor = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_line(colour = 'grey90', size = .25),
                   # panel.grid.major = element_blank(),
                   legend.key       = ggplot2::element_rect(colour = NA, fill = NA),
                   axis.line        = ggplot2::element_blank()
                  )
}
