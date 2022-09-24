//
//  DBModels.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/6/21.
//

import Foundation

class DBUserModel: Identifiable {
    public var uId: Int64 = 0
    public var firstName: String = ""
    public var lastName: String = ""
    public var email: String = ""
    public var phoneNumber: String = ""
    public var password: String = ""
}

class DBApptModel: Identifiable {
    public var apptId: Int64 = 0
    public var uId: Int64 = 0
    public var description: String = ""
    public var date: Date = Date()
}
