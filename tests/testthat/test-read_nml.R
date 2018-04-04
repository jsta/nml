context("read_nml")

test_that("read_nml works", {

  expect_is(read_nml("sample.nml"), "nml")

})
