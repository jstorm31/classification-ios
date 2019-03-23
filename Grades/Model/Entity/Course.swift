//
//  Subject.swift
//  Grades
//
//  Created by Jiří Zdvomka on 04/03/2019.
//  Copyright © 2019 jiri.zdovmka. All rights reserved.
//

import RxDataSources

class Course: Decodable {
    var code: String
    var name: String?

    init(code: String, name: String? = nil) {
        self.code = code
        self.name = name
    }

    init(fromCourse course: Course) {
        code = course.code
        name = course.name
    }

    enum CodingKeys: String, CodingKey {
        case code = "courseCode"
        case name = "courseName"
    }
}

/// Raw course representation for decoding from JSON
struct StudentCourseRaw: Decodable {
    var code: String
    var items: [OverviewItem]

    enum CodingKeys: String, CodingKey {
        case code = "courseCode"
        case items = "overviewItems"
    }
}

class StudentCourse: Course {
    var finalValue: DynamicValue?

    init(code: String, finalValue: DynamicValue? = nil) {
        super.init(code: code)
        self.code = code
        self.finalValue = finalValue
    }

    override init(fromCourse course: Course) {
        super.init(fromCourse: course)
    }

    init(fromCourse course: StudentCourse) {
        super.init(code: course.code, name: course.name)
        finalValue = course.finalValue
    }

    init(fromRawCourse rawCourse: StudentCourseRaw) {
        super.init(code: rawCourse.code)

        if let overviewItem = rawCourse.items.first(where: { $0.type == "POINTS_TOTAL" }),
            let value = overviewItem.value {
            finalValue = value
        } else if let overviewItem = rawCourse.items.first(where: { $0.type == "FINAL_SCORE" }),
            let value = overviewItem.value {
            finalValue = value
        }
    }

    required init(from _: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class TeacherCourse: Course {
    init(code: String) {
        super.init(code: code)
    }

    override init(fromCourse course: Course) {
        super.init(fromCourse: course)
    }

    required init(from _: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

struct CoursesByRolesRaw: Decodable {
    var studentCourses: [String]
    var teacherCourses: [String]
}

struct CoursesByRoles {
    var student: [StudentCourse]
    var teacher: [TeacherCourse]
}

/// Type for grouping courses
struct CourseGroup {
    var header: String
    var items: [CellConfigurator]
}

extension CourseGroup: SectionModelType {
    typealias Item = CellConfigurator

    init(original: CourseGroup, items: [Item]) {
        self = original
        self.items = items
    }
}
