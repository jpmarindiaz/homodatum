
new_Cat <- function(x = character(), categories = NULL,
                    skip_stats = FALSE){
  vctrs::vec_assert(x, character())
  categories <- categories %||% unique(x[!is.na(x)])
  nms <- names(x)
  stats <- NULL
  if(!skip_stats){
    stats <- table(x,useNA = "always") %>%
      tibble::as_tibble() %>%
      dplyr::mutate(dist = n/sum(n), names = c(nms, NA)) %>%
      dplyr::rename(category = x)
  }
  vctrs::new_vctr(x, categories = categories,
           n_categories = length(categories),
           stats = stats, class = "hd_Cat")
}


#' @export
Cat <- function(x = character(), categories = NULL, skip_stats = FALSE) {
  # x <- vctrs::vec_cast(x, character())
  x <- as.character(x)
  new_Cat(x, categories = categories, skip_stats = skip_stats)
}

#' @export
is_Cat <- function(x) {
  inherits(x, "hd_Cat")
}

# Methods

## Format method

#' @export
format.hd_Cat <- function(x, ...) {
  sprintf(fmt = "%s", x)
}

#' @export
vec_ptype_abbr.hd_Cat <- function(x, ...) {
  "Cat"
}

# Coercion

#' @rdname vctrs-compat
#' @method vec_ptype2 hd_Cat
#' @export
#' @export vec_ptype2.hd_Cat
vec_ptype2.hd_Cat <- function(x, y, ...) UseMethod("vec_ptype2.hd_Cat", y)

#' @method vec_ptype2.hd_Cat default
#' @export
vec_ptype2.hd_Cat.default <- function(x, y, ..., x_arg = "x", y_arg = "y") {
  vec_default_ptype2(x, y, x_arg = x_arg, y_arg = y_arg)
}


# A Cat combined with a Cat returns a Cat

#' @method vec_ptype2.hd_Cat hd_Cat
#' @export
vec_ptype2.hd_Cat.hd_Cat <- function(x, y, ...) new_Cat()

# Cat and character return double

#' @method vec_ptype2.hd_Cat character
#' @export
vec_ptype2.hd_Cat.character <- function(x, y, ...) character()

#' @method vec_ptype2.character hd_Cat
#' @export
vec_ptype2.character.hd_Cat <- function(x, y, ...) character()

# Casting

#' @rdname vctrs-compat
#' @method vec_cast hd_Cat
#' @export
#' @export vec_cast.hd_Cat
vec_cast.hd_Cat <- function(x, to, ...) UseMethod("vec_cast.hd_Cat")

#' @method vec_cast.hd_Cat default
#' @export
vec_cast.hd_Cat.default <- function(x, to, ...) vec_default_cast(x, to)

# Coerce Cat to Cat

#' @method vec_cast.hd_Cat hd_Cat
#' @export
vec_cast.hd_Cat.hd_Cat <- function(x, to, ...) x

#' @method vec_cast.hd_Cat character
#' @export
vec_cast.hd_Cat.character <- function(x, to, ...) Cat(x)

#' @method vec_cast.character hd_Cat
#' @export
vec_cast.character.hd_Cat <- function(x, to, ...) vctrs::vec_data(x)

#' @export
as_Cat <- function(x) {
  vctrs::vec_cast(as.character(x), new_Cat())
}


#' @export
Cat_get_categories <- function(x){
  if(!is_Cat(x)) stop("x must be a Cat")
  attr(x, "categories")
}

#' @export
Cat_get_n_categories <- function(x){
  if(!is_Cat(x)) stop("x must be a Cat")
  attr(x, "n_categories")
}

#' @export
Cat_get_stats <-  function(x){
  if(!is_Cat(x)) stop("x must be a Cat")
  attr(x, "stats")
}

