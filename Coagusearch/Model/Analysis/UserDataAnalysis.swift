//
//  UserDataAnalysis.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 30.04.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

struct UserDataAnalysisList : Codable {
    var userTestList: [AnalysisDateInfo]
}

struct AnalysisDateInfo : Codable {
    var id: Int
    var testDate: DayYearInfo
}

struct DataAnalysis : Codable {
    var bloodTestId: Int
    var userBloodData: [TestResult]
    var ordersOfData: [GeneralOrder]
}

struct TestResult : Codable {
    var testName: TestName
    var categoryList: [SingleTestResult]
}

enum TestName: String, Codable {
    case Fibtem = "fibtem"
    case Extem = "extem"
    case Intem = "intem"
}

struct SingleTestResult : Codable {
    var categoryName: String
    var maximumValue: Double
    var minimumValue: Double
    var optimalMaximumValue: Double
    var optimalMinimumValue: Double
    var value: Double
}


