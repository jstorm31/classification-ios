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

    var userRoles = CoursesByRoles(studentCourses: ["BI-PPA", "BI-PST"], teacherCourses: ["BI-ZMA", "MI-IOS"])

    static var userInfo = User(userId: 14, username: "mockuser", firstName: "Ondřej", lastName: "Krátký")

    var courses = [
		Course(code: "BI-PPA", totalPoints: "7"),
		Course(code: "BI-PST", totalPoints: "14"),
		Course(code: "MI-IOS", totalPoints: nil)
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

    func getRoles() -> Observable<CoursesByRoles> {
        return Observable.just(userRoles)
    }

    func getCourses(username _: String) -> Observable<[Course]> {
		switch result {
		case .success:
			return Observable.just(courses)
		case .failure:
			return Observable.error(ApiError.general)
		}
    }
	
	func getCourse(code: String) -> Observable<CourseRaw> {
		return Observable.just(CourseRaw(code: "BI-PPA", name: "Programming paradigmas"))
	}
	
	func getCourseStudentClassification(username: String, code: String) -> Observable<CourseStudent> {
		return Observable<CourseStudent>.just(CourseStudent(classifications: CourseStudentMockData.classifications))
	}
}
