test_that('data_functions',{
  Sys.setenv(R_CONFIG_ACTIVE = 'development')
  expect_equal(config::get('head_data'), 5)

  expect_true(identical(getRawData(), mtcars))

  expect_equal(nrow(getSummaryData(mtcars)), 5)
})
