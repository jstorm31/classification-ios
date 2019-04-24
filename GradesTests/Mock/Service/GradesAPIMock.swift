//
//  File.swift
//  GradesTests
//
//  Created by Jiří Zdvomka on 06/03/2019.
//  Copyright © 2019 jiri.zdovmka. All rights reserved.
//

import RxSwift
@testable import GradesDev

class GradesAPIMock: GradesAPIProtocol {
	// MARK: mock data with default values
	var result = Result.success
	
	static var userInfo = User(userId: 14, username: "mockuser", firstName: "Ondřej", lastName: "Krátký")
	
	private let courses = [
		StudentCourse(code: "BI-PPA", finalValue: .number(4)),
		StudentCourse(code: "BI-ZMA", finalValue: .string("C")),
		TeacherCourse(code: "MI-IOS"),
		TeacherCourse(code: "BI-PST")
	]
	
	
	// MARK: methods
	
	func getUser() -> Observable<User> {
		switch result {
		case .success:
			return Observable.just(GradesAPIMock.userInfo)
		case .failure:
			return Observable.error(ApiError.general)
		}
	}
	
	func getCourses(username _: String) -> Observable<[Course]> {
		switch result {
		case .success:
			return Observable.just(courses)
		case .failure:
			return Observable.error(ApiError.general)
		}
	}
	
	func getCourse(code: String) -> Observable<Course> {
		return Observable.just(Course(code: code, name: "Programming paradigmas"))
	}
	
	func getCourseStudentClassification(username: String, code: String) -> Observable<[Classification]> {
		switch result {
		case .success:
			return Observable.just(CourseStudentMockData.classifications)
		case .failure:
			return Observable.error(ApiError.general)
		}
	}
	
	func getTeacherCourses(username: String) -> Observable<[TeacherCourse]> {
		switch result {
		case .success:
			return Observable.just([
				TeacherCourse(code: "BI-IOS"),
				TeacherCourse(code: "BI-OOP")
				])
		case .failure:
			return Observable.error(ApiError.general)
		}
	}
	
	func getStudentCourses(username: String) -> Observable<[StudentCourse]> {
		switch result {
		case .success:
			return Observable.just([
				StudentCourse(code: "MI-IOS", finalValue: .number(45)),
				StudentCourse(code: "BI-ZMA", finalValue: .bool(false))
				])
		case .failure:
			return Observable.error(ApiError.general)
		}
	}
	
	func getCurrentSemestrCode() -> Observable<String> {
		return Observable.just("B182")
	}
	
	func getStudentGroups(forCourse course: String, username: String?) -> Observable<[StudentGroup]> {
		switch result {
		case .success:
			return Observable.just([
				StudentGroup(id: "A145", name: "Cvičení 1"),
				StudentGroup(id: "A146", name: "Cvičení 2")
			])
		case .failure:
			return Observable.error(ApiError.general)
		}
	}
	
	func getClassifications(forCourse: String) -> Observable<[Classification]> {
		fatalError("getClassifications in GradesApiMock not implemented")
		return Observable.empty()
	}
	
	func getGroupClassifications(courseCode: String, groupCode: String, classificationId: String) -> Observable<[StudentClassification]> {
		fatalError("getClassifications in GradesApiMock not implemented")
		return Observable.empty()
	}
	
	func getTeacherStudents(courseCode: String) -> Observable<[User]> {
		switch result {
		case .success:
			return Observable.just([
				User(userId: 1, username: "kucerj48", firstName: "Jan", lastName: "Kučera"),
				User(userId: 2, username: "janatpa3", firstName: "Pavel", lastName: "Janata"),
				User(userId: 3, username: "ottastep", firstName: "Štěpán", lastName: "Otta")
			]).delaySubscription(0.5, scheduler: MainScheduler.instance)
		case .failure:
			return Observable.error(ApiError.general).delaySubscription(0.5, scheduler: MainScheduler.instance)
		}
	}
	
	func putStudentsClassifications(courseCode: String, data: [StudentClassification]) -> Observable<Void> {
		fatalError("putStudentsClassifications in GradesApiMock not implemented")
		return Observable.empty()
	}
}
