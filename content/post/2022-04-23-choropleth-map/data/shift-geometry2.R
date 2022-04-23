
# 修改函数 tigris::shift_geometry
shift_geometry2 <- function(input_sf, geoid_column = NULL, preserve_area = FALSE,
                            position = c("below", "outside")) {
  if (!any(grepl("sf", class(input_sf)))) {
    stop("The input dataset must be an sf object.", call = FALSE)
  }
  position <- match.arg(position)
  # 使用本地已经下载的地图数据
  minimal_states <- sf::read_sf('cb_2020_us_state_20m/cb_2020_us_state_20m.shp') %>% 
    sf::st_transform("ESRI:102003")
  # 网上下载地图数据
  # minimal_states <- tigris::states(cb = TRUE, resolution = "20m", progress_bar = FALSE, year = 2020) %>%
  # sf::st_transform("ESRI:102003")
  ak_bbox <- minimal_states %>%
    dplyr::filter(GEOID == "02") %>%
    sf::st_bbox() %>%
    sf::st_as_sfc()
  hi_bbox <- minimal_states %>%
    dplyr::filter(GEOID == "15") %>%
    sf::st_bbox() %>%
    sf::st_as_sfc()
  pr_bbox <- minimal_states %>%
    dplyr::filter(GEOID == "72") %>%
    sf::st_bbox() %>%
    sf::st_as_sfc()
  input_sf <- sf::st_transform(input_sf, sf::st_crs(minimal_states))
  ak_check <- suppressMessages(sf::st_intersects(input_sf,
    ak_bbox,
    sparse = FALSE
  )[, 1])
  hi_check <- suppressMessages(sf::st_intersects(input_sf,
    hi_bbox,
    sparse = FALSE
  )[, 1])
  pr_check <- suppressMessages(sf::st_intersects(input_sf,
    pr_bbox,
    sparse = FALSE
  )[, 1])
  if (!any(ak_check) && !any(hi_check) && !any(pr_check)) {
    warning("None of your features are in Alaska, Hawaii, or Puerto Rico, so no geometries will be shifted.\nTransforming your object's CRS to 'ESRI:102003'",
      call. = FALSE
    )
    transformed_output <- sf::st_transform(input_sf, "ESRI:102003")
    return(transformed_output)
  }
  if (!is.null(geoid_column)) {
    input_sf$state_fips <- stringr::str_sub(
      input_sf[[geoid_column]],
      1, 2
    )
  } else {
    input_sf <- input_sf %>%
      sf::st_transform(sf::st_crs(minimal_states)) %>%
      dplyr::mutate(state_fips = dplyr::case_when(
        suppressMessages(sf::st_intersects(input_sf,
          ak_bbox,
          sparse = FALSE
        )[, 1]) ~ "02",
        suppressMessages(sf::st_intersects(input_sf,
          hi_bbox,
          sparse = FALSE
        )[, 1]) ~ "15", suppressMessages(sf::st_intersects(input_sf,
          pr_bbox,
          sparse = FALSE
        )[, 1]) ~ "72", TRUE ~
          "00"
      ))
  }
  ak_crs <- 3338
  hi_crs <- "ESRI:102007"
  pr_crs <- 32161
  ak_centroid <- minimal_states %>%
    dplyr::filter(GEOID ==
      "02") %>%
    sf::st_transform(ak_crs) %>%
    sf::st_geometry() %>%
    sf::st_centroid()
  hi_centroid <- minimal_states %>%
    dplyr::filter(GEOID ==
      "15") %>%
    sf::st_transform(hi_crs) %>%
    sf::st_geometry() %>%
    sf::st_centroid()
  pr_centroid <- minimal_states %>%
    dplyr::filter(GEOID ==
      "72") %>%
    sf::st_transform(pr_crs) %>%
    sf::st_geometry() %>%
    sf::st_centroid()
  place_geometry_wilke <- function(geometry, position, scale = 1,
                                   centroid = sf::st_centroid(geometry)) {
    (geometry - centroid) * scale + sf::st_sfc(st_point(position))
  }
  cont_us <- dplyr::filter(minimal_states, !GEOID %in% c(
    "02",
    "15", "72"
  )) %>% sf::st_transform("ESRI:102003")
  us_lower48 <- dplyr::filter(input_sf, !state_fips %in% c(
    "02",
    "15", "72"
  )) %>% sf::st_transform("ESRI:102003")
  bb <- sf::st_bbox(cont_us)
  us_alaska <- dplyr::filter(input_sf, state_fips == "02")
  us_hawaii <- dplyr::filter(input_sf, state_fips == "15")
  us_puerto_rico <- dplyr::filter(input_sf, state_fips == "72")
  shapes_list <- list(us_lower48)
  if (!preserve_area) {
    if (any(ak_check)) {
      ak_rescaled <- sf::st_transform(us_alaska, ak_crs)
      if (position == "below") {
        st_geometry(ak_rescaled) <- place_geometry_wilke(sf::st_geometry(ak_rescaled),
          c(bb$xmin + 0.08 * (bb$xmax - bb$xmin), bb$ymin +
            0.07 * (bb$ymax - bb$ymin)),
          scale = 0.5,
          centroid = ak_centroid
        )
      } else if (position == "outside") {
        st_geometry(ak_rescaled) <- place_geometry_wilke(sf::st_geometry(ak_rescaled),
          c(bb$xmin - 0.08 * (bb$xmax - bb$xmin), bb$ymin +
            1.2 * (bb$ymax - bb$ymin)),
          scale = 0.5,
          centroid = ak_centroid
        )
      }
      sf::st_crs(ak_rescaled) <- "ESRI:102003"
      shapes_list <- c(shapes_list, list(ak_rescaled))
    }
    if (any(hi_check)) {
      hi_rescaled <- suppressWarnings(us_hawaii %>% sf::st_intersection(hi_bbox) %>%
        sf::st_transform(hi_crs))
      if (position == "below") {
        sf::st_geometry(hi_rescaled) <- place_geometry_wilke(sf::st_geometry(hi_rescaled),
          c(bb$xmin + 0.35 * (bb$xmax - bb$xmin), bb$ymin +
            0 * (bb$ymax - bb$ymin)),
          scale = 1.5, centroid = hi_centroid
        )
      } else if (position == "outside") {
        sf::st_geometry(hi_rescaled) <- place_geometry_wilke(sf::st_geometry(hi_rescaled),
          c(bb$xmin - 0 * (bb$xmax - bb$xmin), bb$ymin +
            0.2 * (bb$ymax - bb$ymin)),
          scale = 1.5,
          centroid = hi_centroid
        )
      }
      st_crs(hi_rescaled) <- "ESRI:102003"
      shapes_list <- c(shapes_list, list(hi_rescaled))
    }
    if (any(pr_check)) {
      pr_rescaled <- sf::st_transform(us_puerto_rico, pr_crs)
      if (position == "below") {
        sf::st_geometry(pr_rescaled) <- place_geometry_wilke(sf::st_geometry(pr_rescaled),
          c(bb$xmin + 0.65 * (bb$xmax - bb$xmin), bb$ymin +
            0 * (bb$ymax - bb$ymin)),
          scale = 2.5, centroid = pr_centroid
        )
      } else if (position == "outside") {
        sf::st_geometry(pr_rescaled) <- place_geometry_wilke(sf::st_geometry(pr_rescaled),
          c(bb$xmin + 0.95 * (bb$xmax - bb$xmin), bb$ymin -
            0.05 * (bb$ymax - bb$ymin)),
          scale = 2.5,
          centroid = pr_centroid
        )
      }
      st_crs(pr_rescaled) <- "ESRI:102003"
      shapes_list <- c(shapes_list, list(pr_rescaled))
    }
    output_data <- shapes_list %>%
      dplyr::bind_rows() %>%
      dplyr::select(-state_fips)
    return(output_data)
  } else {
    if (any(ak_check)) {
      ak_shifted <- sf::st_transform(us_alaska, ak_crs)
      if (position == "below") {
        st_geometry(ak_shifted) <- place_geometry_wilke(sf::st_geometry(ak_shifted),
          c(bb$xmin + 0.2 * (bb$xmax - bb$xmin), bb$ymin -
            0.13 * (bb$ymax - bb$ymin)),
          scale = 1, centroid = ak_centroid
        )
      } else if (position == "outside") {
        st_geometry(ak_shifted) <- place_geometry_wilke(sf::st_geometry(ak_shifted),
          c(bb$xmin - 0.25 * (bb$xmax - bb$xmin), bb$ymin +
            1.35 * (bb$ymax - bb$ymin)),
          scale = 1, centroid = ak_centroid
        )
      }
      sf::st_crs(ak_shifted) <- "ESRI:102003"
      shapes_list <- c(shapes_list, list(ak_shifted))
    }
    if (any(hi_check)) {
      hi_shifted <- sf::st_transform(us_hawaii, hi_crs)
      if (position == "below") {
        sf::st_geometry(hi_shifted) <- place_geometry_wilke(sf::st_geometry(hi_shifted),
          c(bb$xmin + 0.6 * (bb$xmax - bb$xmin), bb$ymin -
            0.1 * (bb$ymax - bb$ymin)),
          scale = 1, centroid = hi_centroid
        )
      } else if (position == "outside") {
        sf::st_geometry(hi_shifted) <- place_geometry_wilke(sf::st_geometry(hi_shifted),
          c(bb$xmin - 0 * (bb$xmax - bb$xmin), bb$ymin +
            0.2 * (bb$ymax - bb$ymin)),
          scale = 1, centroid = hi_centroid
        )
      }
      st_crs(hi_shifted) <- "ESRI:102003"
      shapes_list <- c(shapes_list, list(hi_shifted))
    }
    if (any(pr_check)) {
      pr_shifted <- sf::st_transform(us_puerto_rico, pr_crs)
      if (position == "below") {
        sf::st_geometry(pr_shifted) <- place_geometry_wilke(sf::st_geometry(pr_shifted),
          c(bb$xmin + 0.75 * (bb$xmax - bb$xmin), bb$ymin -
            0.1 * (bb$ymax - bb$ymin)),
          scale = 1, centroid = pr_centroid
        )
      } else if (position == "outside") {
        sf::st_geometry(pr_shifted) <- place_geometry_wilke(sf::st_geometry(pr_shifted),
          c(bb$xmin + 0.95 * (bb$xmax - bb$xmin), bb$ymin -
            0.05 * (bb$ymax - bb$ymin)),
          scale = 1, centroid = pr_centroid
        )
      }
      st_crs(pr_shifted) <- "ESRI:102003"
      shapes_list <- c(shapes_list, list(pr_shifted))
    }
    output_data <- shapes_list %>%
      dplyr::bind_rows() %>%
      dplyr::select(-state_fips)
    return(output_data)
  }
}
