//
//  Constants.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 10.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation
import UIKit

// MARK: Image Names
let IMAGE_NAME_NORMAL = "normal"
let IMAGE_NAME_LOW = "low"
let IMAGE_NAME_HIGH = "high"

// MARK: Animation File
let LOADING_VIEW_JSON_FILE_NAME = "blood-wave-tube"//"loader"

// MARK: Storyboards
let STORYBOARD_NAME_MAIN = "Main"
let STORYBOARD_NAME_PATIENT = "Patient"
let STORYBOARD_NAME_DOCTOR = "Doctor"

// MARK: Storyboard Identifiers
let STORYBOARD_ID_LOADING = "LoadingVC"
let STORYBOARD_ID_LOGIN = "loginVC"

// MARK: Tabbar
let STORYBOARD_ID_PATIENT_TAB_BAR = "PatientVC"
let STORYBOARD_ID_DOCTOR_TAB_BAR = "DoctorVC"

// MARK: Segue Identifiers
let SEGUE_SHOW_PATIENT_HOME = "showPatientHomeVC"
let SEGUE_SHOW_PATIENT_MEDICINE_UPDATE = "showPatientMedicineUpdateVC"
let SEGUE_SHOW_PATIENT_INFO = "showPatientInfoVC"
let SEGUE_SHOW_DOCTOR_PATIENT_INFO = "showDoctorPatientInfoVC"
let SEGUE_SHOW_DOCTOR_PATIENT_SPECIFIC_BLOOD_ORDER = "showDoctorPatientSpecificBloodOrderVC"

let SEGUE_SHOW_DOCTOR_HOME = "showDoctorHomeVC"
let SEGUE_SHOW_DOCTOR_PATIENT_PAST_APPOINTMENTS_HOME = "showDoctorPatientPastAppointmentsVC"

// MARK: Cell Identifiers
let CELL_IDENTIFIER_SELECTION_CELL = "SelectionTableViewCell"
let CELL_IDENTIFIER_DOCTOR_CELL = "DoctorTableViewCell"
let CELL_IDENTIFIER_LABEL_CELL = "LabelTableViewCell"
let CELL_IDENTIFIER_MEDICINE_CELL = "MedicineTableViewCell"
let CELL_IDENTIFIER_SEARCH_MEDICINE_CELL = "SearchMedicineTableViewCell"
let CELL_IDENTIFIER_NEXT_APPOINTMENT_CELL = "NextAppointmentTableViewCell"
let CELL_IDENTIFIER_PAST_APPOINTMENT_CELL = "PastAppointmentTableViewCell"
let CELL_IDENTIFIER_MISSING_INFO_CELL = "MissingInfoTableViewCell"
let CELL_IDENTIFIER_TODAYS_APPOINTMENT_CELL = "TodaysAppointmentTableViewCell"
let CELL_IDENTIFIER_EMERGENCY_CELL = "EmergencyTableViewCell"
let CELL_IDENTIFIER_COMPLETED_ANALYSIS_CELL = "CompletedAnalysisTableViewCell"
let CELL_IDENTIFIER_MEDICAL_NOTIFICATION_CELL = "MedicalNotificationTableViewCell"
let CELL_IDENTIFIER_PATIENT_CELL = "PatientTableViewCell"
let CELL_IDENTIFIER_BLOOD_ORDER_CELL = "BloodOrderTableViewCell"
let CELL_IDENTIFIER_PATIENT_INFO_CELL = "PatientInfoTableViewCell"
let CELL_IDENTIFIER_PATIENT_NEXT_APPOINTMENT_CELL = "PatientNextAppointmentTableViewCell"
let CELL_IDENTIFIER_CALL_PATIENT_FOR_NEW_APPOINTMENT_CELL = "CallForAppointmentTableViewCell"
let CELL_IDENTIFIER_LAST_ANALYSIS_CELL = "LastAnalysisTableViewCell"
let CELL_IDENTIFIER_PAST_APPOINTMENTS_CELL = "PastAppointmentsTableViewCell"
let CELL_IDENTIFIER_BLOOD_ORDER_FOR_PATIENT_CELL = "BloodOrderForPatientTableViewCell"
let CELL_IDENTIFIER_PATIENT_SPECIFIC_BLOOD_ORDER_CELL = "PatientSpecificPastBloodOrderTableViewCell"
let CELL_IDENTIFIER_PATIENT_PAST_APPOINTMENT_CELL = "PatientPastAppointmentTableViewCell"
let CELL_IDENTIFIER_DATA_CELL = "DataTableViewCell"
let CELL_IDENTIFIER_PAST_DATA_CELL = "PastDataTableViewCell"
let CELL_IDENTIFIER_HEADING_CELL = "HeadingTableViewCell"
let CELL_IDENTIFIER_COLORED_LABEL_CELL = "ColoredLabelTableViewCell"
let CELL_IDENTIFIER_ENTER_DOSAGE_CELL = "EnterDosageTableViewCell"
let CELL_IDENTIFIER_SUGGESTION_CELL = "SuggestionTableViewCell"
let CELL_IDENTIFIER_GIVEN_MEDICINE_CELL = "GivenMedicineTableViewCell"
let CELL_IDENTIFIER_PRODUCT_ORDER_CELL = "ProductOrderTableViewCell"
let CELL_IDENTIFIER_BUTTON_CELL = "ButtonTableViewCell"

// MARK: Collection View Cell Identifiers
let CELL_IDENTIFIER_EMERGENCY_PATIENT_CELL = "EmergencyPatientCollectionViewCell"

// MARK: Cell Heights
let CELL_HEIGHT_SMALL = CGFloat(45)
let CELL_HEIGHT = CGFloat(70)
let CELL_HEIGHT_EXPANDED = CGFloat(200)

let ENTER_DOSADE_CELL_HEIGHT = CGFloat(65)
let ENTER_DOSADE_EXPANDED_CELL_HEIGHT = CGFloat(195)

//
let HEIGHT_FOR_HEADER = CGFloat(16)
let HEIGHT_FOR_DATA_CELL = CGFloat(126)

//
let ERROR_MESSAGE = "Error"
let UNEXPECTED_ERROR_MESSAGE = "Encountered an unexpected error"

// MARK: Fonts
let fontLight = UIFont(name: "HelveticaNeue-Light", size: 14.0)!
let fontRegular = UIFont(name: "HelveticaNeue-Light", size: 16.0)!

