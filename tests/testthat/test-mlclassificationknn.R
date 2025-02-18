context("Machine Learning KNN Classification")

options <- jaspTools::analysisOptions("mlClassificationKnn")
options$addPredictions <- FALSE
options$addIndicator <- FALSE
options$andrewsCurve <- TRUE
options$predictionsColumn <- ""
options$classProportionsTable <- TRUE
options$savePath <- ""
options$saveModel <- FALSE
options$holdoutData <- "holdoutManual"
options$modelOpt <- "optimizationError"
options$modelValid <- "validationManual"
options$noOfFolds <- 5
options$plotErrorVsK <- TRUE
options$plotWeights <- TRUE
options$predictors <- list("Alcohol", "Malic", "Ash", "Alcalinity", "Magnesium", "Phenols", 
                           "Flavanoids", "Nonflavanoids", "Proanthocyanins", "Color", 
                           "Hue", "Dilution", "Proline")
options$rocCurve <- TRUE
options$seedBox <- TRUE
options$target <- "Type"
options$testDataManual <- 0.2
options$testIndicatorColumn <- ""
options$testSetIndicatorVariable <- ""
options$validationDataManual <- 0.2
options$validationMeasures <- TRUE
set.seed(1)
results <- jaspTools::runAnalysis("mlClassificationKnn", "wine.csv", options)


test_that("Andrews Curves Plot matches", {
  plotName <- results[["results"]][["andrewsCurve"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "andrews-curves-plot")
})

test_that("Class Proportions table results match", {
  table <- results[["results"]][["classProportionsTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(0.331460674157303, 1, 0.371428571428571, 0.324561403508772, 0.310344827586207,
                           0.398876404494382, 2, 0.4, 0.368421052631579, 0.517241379310345,
                           0.269662921348315, 3, 0.228571428571429, 0.307017543859649,
                           0.172413793103448))
})

test_that("K-Nearest Neighbors Classification table results match", {
  table <- results[["results"]][["classificationTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("Euclidean", 1, 35, 114, 29, 0.942857142857143, 0.896551724137931,
                           "rectangular"))
})

test_that("Confusion Matrix table results match", {
  table <- results[["results"]][["confusionTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("Observed", 1, 13, 0, 0, "", 2, 1, 12, 1, "", 3, 0, 0, 8))
})

test_that("Data Split plot matches", {
  plotName <- results[["results"]][["plotDataSplit"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "data-split")
})

test_that("Classification Accuracy Plot matches", {
  plotName <- results[["results"]][["plotErrorVsK"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "classification-accuracy-plot")
})

test_that("Rectangular Weight Function plot matches", {
	plotName <- results[["results"]][["plotWeights"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "rectangular-weight-function")
})

test_that("ROC Curves Plot matches", {
  plotName <- results[["results"]][["rocCurve"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "roc-curves-plot")
})

test_that("Evaluation Metrics table results match", {
	table <- results[["results"]][["validationMeasures"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.971428571428571, 0.977272727272727, 0.962962962962963, 0.0714285714285714,
			 0, 0, 0.0454545454545455, 1, 1, 0.928571428571429, 1, 0.4, 13,
			 0.954545454545455, 6.5, 0.942857142857143, 0.928571428571429,
			 0.923076923076923, 0, 0.142857142857143, 0.0869565217391304,
			 0, 2, 0.91304347826087, 1, 0.857142857142857, 0.342857142857143,
			 14, 1, 6, 0.971428571428571, 0.981481481481482, 0.941176470588235,
			 0.111111111111111, 0, 0, 0.037037037037037, 3, 1, 0.888888888888889,
			 1, 0.257142857142857, 8, 0.962962962962963, 4, 0.961904761904762,
			 0.962441879108546, 0.942028777322895, 0.0608465608465608, 0.0476190476190476,
			 0.0289855072463768, 0.0274971941638608, "Average / Total", 0.971014492753623,
			 0.948072562358277, 0.942857142857143, 1, 35, 0.972502805836139,
			 5.5))
})