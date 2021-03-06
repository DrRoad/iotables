library (testthat)
library (iotables)
context ("Creating an IO Table")
#iotable_get ( source = "naio_10_cp1620", geo = "CZ", 
#              stk_flow = "TOTAL", year = 2010, 
#              unit = "MIO_NAC", data_directory = 'data-raw')

#test <- iotable_get ( source = "naio_10_pyp1620", geo = "CZ", 
#              stk_flow = "TOTAL", year = 2010, 
#              unit = "MIO_NAC", data_directory = 'data-raw')



test_that("get_iotable errors ", {
  expect_error(iotable_get(source = "germany_1990", 
                              geo = 'DE', year = 1990, unit = "MIO_NAC")) #currency not found
  expect_error(iotable_get(source = "germany_1990", 
                              geo = 'DE', year = 1787, unit = "MIO_EUR")) #no data for this year
  expect_error(iotable_get(source = "germany_1990", 
                              geo = 'BE', year = 1990, unit = "MIO_EUR")) # no data for geographical unit
  expect_warning(iotable_get(source = "germany_1990", 
                             geo = 'de', year = 1990, unit = "MIO_EUR", 
                             labelling = "short")) #warn for upper case
  expect_error(iotable_get(source = "germany_1990", 
                           geo = 'DE', year = 1990, 
                           unit = "MIO_EUR", labelling = "biotables") ) # no such labelling
})

test_that("correct data is returned", {
  expect_equal(iotable_get(source = "germany_1990", 
                           geo = 'DE', year = 1990, 
                           unit = "MIO_EUR", labelling = "iotables")[1,2], 1131)
  expect_equal(as.character(iotable_get(source = "germany_1990", 
                           geo = 'DE', year = 1990, 
                           unit = "MIO_EUR", labelling = "short")[4,1]), "cpa_g_i")
  expect_equal(as.numeric(iotable_get ( source = "croatia_2010_1800", geo = "HR",
                                        year = 2010, unit = "T_NAC")[1,3]), 
               expected = 164159,  tolerance = 0.6)
  expect_equal(as.numeric(iotable_get ( source = "croatia_2010_1900", geo = "HR",
                                        year = 2010, unit = "T_NAC")[2,5]), 
               expected = 1,  tolerance = 0.5)
  expect_equal(as.character(iotable_get ( source = "croatia_2010_1900", geo = "HR",
                                          year = 2010, unit = "T_NAC", 
                                          labelling = "short")[[1]][2]), 
               expected = "CPA_A02")
  expect_equal(as.character(iotable_get ( source = "croatia_2010_1900", geo = "HR",
                                          year = 2010, unit = "T_NAC", 
                                          labelling = "iotables")[[1]][2]), 
               expected = "forestry")
  })

#Slovakia A01, A01 shoud be 497.37

#test <- iotable_get ( source = "naio_10_cp1750", stk_flow = "TOTAL",
#                      geo = "CZ", unit = "MIO_NAC", year = 2010, 
#                      data_directory = "data-raw", force_download = FALSE)
# A01, A01 should yield 10,161

