#' Create a World Pollution Map Based on Thermal Reaction Values
#'
#' @name enthalpy_pollution
#' @import dplyr
#' @import ggplot2
#' @import maps
#' @importFrom ggplot2 ggplot map_data geom_polygon scale_fill_manual labs theme_minimal theme
#' @importFrom dplyr mutate left_join
# Suppress global variable notes
utils::globalVariables(c("enthalpy", "pollution", "long", "lat", "group", "region"))

#'
#' This function generates a world map to visualize the impact of thermal reactions
#' in terms of pollution, based on user-defined enthalpy values.
#'
#' @param reaction_data A data frame with columns 'region' and 'enthalpy' indicating thermal reaction values.
#' @param pollution_threshold A numeric value indicating the threshold for pollution classification.
#' @return A ggplot object showing the world pollution map.
#' @examples
#' # Define user input data
#' user_data <- data.frame(
#'   region = c("USA", "Canada", "Brazil", "France", "Germany",
#'              "China", "India", "Australia", "Russia", "Japan",
#'              "Argentina", "Mexico", "UK", "Italy", "South Africa",
#'              "Nigeria", "Saudi Arabia", "Indonesia", "Turkey",
#'              "Iran", "Thailand", "Vietnam", "Spain", "Poland",
#'              "Netherlands"),
#'   enthalpy = runif(25, 100, 500)  # Random values between 100 and 500
#' )
#' enthalpy_pollution(user_data, pollution_threshold = 300)
#' @export
enthalpy_pollution <- function(reaction_data, pollution_threshold) {
  # Load world map data using ggplot2
  world_map_data <- ggplot2::map_data("world")

  # Classify pollution based on the threshold
  reaction_data <- dplyr::mutate(reaction_data, pollution = ifelse(enthalpy > pollution_threshold, "polluted", "good"))

  # Merge the user-defined reaction data with the world map data
  world_map <- dplyr::left_join(world_map_data, reaction_data, by = "region")

  # Define colors for different pollution levels
  color_palette <- c("good" = "green", "polluted" = "red")

  # Create the map
  ggplot2::ggplot(data = world_map, aes(x = long, y = lat, group = group, fill = pollution)) +
    ggplot2::geom_polygon(color = "black") +
    ggplot2::scale_fill_manual(values = color_palette, na.value = "grey") +  # Grey for regions without data
    ggplot2::labs(title = "Impact of Thermal Reactions on Pollution",
                  fill = "Pollution Level") +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.title = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank()
    )
}
