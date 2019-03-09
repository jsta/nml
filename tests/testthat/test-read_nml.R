context("read_nml")

test_that("read_nml works", {

  expect_is(read_nml("sample.nml"), "nml")

})

test_that("read_nml parses files with leading whitespace in block delimeters", {
  # https://github.com/jsta/nml/issues/2
  expect_is(read_nml("leading_whitespace.nml"), "nml")

})


test_that("read_nml works with arbitrary file extensions", {

  expect_warning(read_nml("sample.namelist"),
                 paste0("sample.namelist is not of file type .nml")
                 )

})
