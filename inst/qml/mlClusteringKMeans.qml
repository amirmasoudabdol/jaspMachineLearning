//
// Copyright (C) 2013-2021 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//

import QtQuick									2.8
import QtQuick.Layouts							1.3
import JASP.Controls							1.0
import JASP.Widgets								1.0

import "./common" as ML

Form 
{

	VariablesForm
	{
		AvailableVariablesList
		{
			name:								"variables"
		}

		AssignedVariablesList
		{
			id:									predictors
			name:								"predictors"
			title:								qsTr("Variables")
			allowedColumns:						["scale"]
			allowAnalysisOwnComputedColumns:	false
		}
	}

	Group
	{
		title:									qsTr("Tables")

		CheckBox
		{
			text:								qsTr("Cluster means")
			name:								"tableClusterMeans"
		}

		CheckBox
		{
			id:									clusterInfo
			text:								qsTr("Cluster information")
			name:								"tableClusterInformation"
			checked:							true

			CheckBox
			{
				text:							qsTr("Within sum of squares")
				name:							"tableClusterInfoWSS"
				checked:						true
			}

			CheckBox
			{
				text:							qsTr("Silhouette score")
				name:							"tableClusterInfoSilhouette"
			}

			CheckBox
			{
				text:							qsTr("Centers")
				name:							"tableClusterInfoCentroids"
			}

			CheckBox
			{
				text:							qsTr("Between sum of squares")
				name:							"tableClusterInfoBetweenSumSquares"
			}

			CheckBox
			{
				text:							qsTr("Total sum of squares")
				name:							"tableClusterInfoTotalSumSquares"
			}
		}

		CheckBox
		{
			text:								qsTr("Evaluation metrics")
			name:								"clusterEvaluationMetrics"
		}
	}

	Group
	{
		title:									qsTr("Plots")

		CheckBox
		{
			text:								qsTr("Elbow method")
			name:								"withinssPlot"
			enabled:							!validationManual.checked
		}

		CheckBox
		{
			text:								qsTr("Cluster means")
			name:								"plotClusterMeans"

			CheckBox
			{
				text:							qsTr("Display barplot")
				name:							"showBars"
				checked:						true
			}

			CheckBox
			{
				text:							qsTr("Group into one figure")
				name:							"oneFigure"
				checked:						true
			}
		}

		CheckBox
		{
			text:								qsTr("Cluster densities")
			name:								"plotClusterDensities"

			CheckBox
			{
				text:							qsTr("Group into one figure")
				name:							"oneFigureDensity"
				checked:						true
			}
		}

		CheckBox
		{
			text:								qsTr("t-SNE cluster plot")
			name:								"plot2dCluster"

			Row
			{
				CheckBox
				{
					text:						qsTr("Legend")
					name:						"legend"
					checked:					true
				}

				CheckBox
				{
					text:						qsTr("Labels")
					name:						"labels"
				}
			}
		}
	}

	ML.ExportResults
	{
		enabled:								predictors.count > 1
		showSave:								false
	}

	Section
	{
		title:									qsTr("Training Parameters")

		Group
		{
			title:								qsTr("Algorithmic Settings")

			DropDown
			{
				id:								centers
				name:							"centers"
				indexDefaultValue:				0
				label:							qsTr("Center type")
				values:
					[
					{ label: "Means", 			value: "means"},
					{ label: "Medians", 		value: "medians"},
					{ label: "Medoids", 		value: "medoids"}
				]
			}

			DropDown
			{
				id:								algorithm
				name:							"algorithm"
				indexDefaultValue:				0
				label:							qsTr("Algorithm")
				enabled:						centers.value  != "medians"
				values: centers.value == "medoids" ? 
					[
						{ label: "PAM", 	value: "pam"},
						{ label: "CLaRA", 	value: "clara"}
					] : 
					[
						{ label: "Hartigan-Wong", 	value: "Hartigan-Wong"},
						{ label: "Lloyd-Forgy", 	value: "Lloyd"},
						{ label: "MacQueen", 		value: "MacQueen"}
					]
			}

			DropDown
			{
				name:							"distance"
				indexDefaultValue:				0
				label:							qsTr("Distance")
				enabled:						centers.value == "medoids"
				values:
					[
					{ label: qsTr("Euclidean"), value: "euclidean"},
					{ label: qsTr("Manhattan"), value: "manhattan"}
				]
			}

			IntegerField
			{
				name:							"noOfIterations"
				text:							qsTr("Max. iterations")
				defaultValue:					25
				min:							1
				max:							999999
				enabled:						!(centers.value == "medoids" & algorithm.value == "pam")
			}

			IntegerField
			{
				name:							"noOfRandomSets"
				text:							qsTr("Random sets")
				defaultValue:					25
				min:							1
				max:							999999
				enabled:						!(centers.value == "medoids" & algorithm.value == "clara")
			}

			CheckBox
			{
				text:							qsTr("Scale variables")
				name:							"scaleEqualSD"
				checked:						true
			}

			CheckBox
			{
				name:							"seedBox"
				text:							qsTr("Set seed")
				childrenOnSameRow:				true

				IntegerField
				{
					name:						"seed"
					defaultValue:				1
					min:						-999999
					max:						999999
					fieldWidth:					60
				}
			}
		}

		RadioButtonGroup
		{
			title:								qsTr("Cluster Determination")
			name:								"modelOpt"

			RadioButton
			{
				id:								validationManual
				text:							qsTr("Fixed")
				name:							"validationManual"

				IntegerField
				{
					name:						"noOfClusters"
					text:						qsTr("Clusters")
					defaultValue:				3
					min:						2
					max:						5000
					enabled:					validationManual.checked
					fieldWidth:					60
				}
			}

			RadioButton
			{
				text:							qsTr("Optimized according to")
				name:							"validationOptimized"
				childrenOnSameRow:				true
				checked:						true

				DropDown
				{
					name:						"optimizationCriterion"
					indexDefaultValue:			1

					values:
						[
						{ label: "AIC", 		value: "validationAIC"},
						{ label: "BIC", 		value: "validationBIC"},
						{ label: "Silhouette", 	value: "validationSilh"}
					]
				}
			}

			IntegerField
			{
				name:							"maxClusters"
				text:							qsTr("Max. clusters")
				defaultValue:					10
				min:							2
				max:							5000
				enabled:						!validationManual.checked
				Layout.leftMargin:				20
				fieldWidth:						60
			}
		}
	}
}
