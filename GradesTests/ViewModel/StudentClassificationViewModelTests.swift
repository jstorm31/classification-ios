//
//  StudentClassificationViewModelTests.swift
//  GradesTests
//
//  Created by Jiří Zdvomka on 18/04/2019.
//  Copyright © 2019 jiri.zdovmka. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import GradesDev

class StudentClassificationViewModelTests: XCTestCase {
	var scheduler: ConcurrentDispatchQueueScheduler!
	var viewModel: StudentClassificationViewModel!
	var coordinator: SceneCoordinatorMock!
	var gradesApi = AppDependencyMock.shared._gradesApi
	
    override func setUp() {
		scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
		coordinator = SceneCoordinatorMock()
		viewModel = StudentClassificationViewModel(dependencies: AppDependencyMock.shared, coordinator: coordinator, course: Course(code: "MI-IOS"))
    }

	func testBindStudents() {
		gradesApi.result = .success
		let studentsObservable = viewModel.students.subscribeOn(scheduler)
		viewModel.bindOutput()
		
		do {
			guard let students = try studentsObservable.toBlocking(timeout: 2).first() else {
				XCTFail("should not be nil")
				return
			}
			
			XCTAssertEqual(students.count, 3)
		} catch {
			XCTFail(error.localizedDescription)
		}
	}
	
	func testBindStudentName() {
		gradesApi.result = .success
		let studentObservable = viewModel.studentName.subscribeOn(scheduler)
		viewModel.bindOutput()
		
		do {
			guard let result = try studentObservable.toBlocking(timeout: 2).first() else {
				XCTFail("should not be nil")
				return
			}
			
			XCTAssertEqual(result, "Jan Kučera")
		} catch {
			XCTFail(error.localizedDescription)
		}
	}
	
	func testError() {
		gradesApi.result = .failure
		let errorObservable = viewModel.error.subscribeOn(scheduler)
		viewModel.bindOutput()
		
		do {
			guard let result = try errorObservable.toBlocking(timeout: 2).first() else {
				XCTFail("should not be nil")
				return
			}

			XCTAssertNotNil(result)
			XCTAssertEqual(result as! ApiError, .general)
		} catch {
			XCTFail(error.localizedDescription)
		}
	}

}
