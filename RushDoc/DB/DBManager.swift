//
//  DBManager.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/6/21.
//

import Foundation
import SQLite

class DBManager {
    /// sqlite db instance
    private var db: Connection!
    
    /// users table instance
    private var users_table: Table!
    ///  users table columns
    private var uId: Expression<Int64>!
    private var firstName: Expression<String>!
    private var lastName: Expression<String>!
    private var email: Expression<String>!
    private var phoneNumber: Expression<String>!
    private var password: Expression<String>!
    
    /// appointments table instance
    private var appts_table: Table!
    /// appointments table columns
    private var apptId: Expression<Int64>!
    private var uId_appt: Expression<Int64>!
    private var description: Expression<String>!
    private var apptDate: Expression<Date>!
    
    
    init() {
        
        do {
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            /// create db connect
            db = try Connection("\(path)/rushdoc_db.sqlite3")
            /// create users table object
            users_table = Table("users_table")
            /// create users table columns instances
            uId = Expression<Int64>("uId")
            firstName = Expression<String>("first_name")
            lastName = Expression<String>("last_name")
            email = Expression<String>("email")
            phoneNumber = Expression<String>("phone_number")
            password = Expression<String>("password")
            
            /// create appointments table object
            appts_table = Table("appts_table")
            /// create appointments table columns instances
            apptId = Expression<Int64>("apptId")
            uId_appt = Expression<Int64>("uId")
            description = Expression<String>("app_description")
            apptDate = Expression<Date>("appt_date")
            
            /// check if table exists
            if (!UserDefaults.standard.bool(forKey: "users_table_exists")) {
                
                try db.run(users_table.create { (t) in
                    t.column(uId, primaryKey: true)
                    t.column(firstName)
                    t.column(lastName)
                    t.column(email, unique: true)
                    t.column(phoneNumber, unique: true)
                    t.column(password)
                })
                
                if (addUser(firstNameValue: "Andrea", lastNameValue: "Pallotta", emailValue: "ap4534@rit.edu", phoneNumberValue: "(585) 441-2853", passwordValue: "password")) {
                    print("User Inserted Correctly")
                } else {
                    print("Error Inserting User")
                }
                
                UserDefaults.standard.set(true, forKey: "users_table_exists")
            }
            
            if (!UserDefaults.standard.bool(forKey: "appt_table_exists")) {
                
                try db.run(appts_table.create { (t) in
                    t.column(apptId, primaryKey: true)
                    t.column(uId_appt)
                    t.column(description)
                    t.column(apptDate)
                })
                
                if (addAppt(uIdValue: 1, descriptionValue: "Appointment with Dr. Mariah Hairam", dateValue: Date())) {
                    print("Appointment Inserted Correctly")
                } else {
                    print("Error Inserting Appointment")
                }
                UserDefaults.standard.set(true, forKey: "appt_table_exists")
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    public func addAppt(uIdValue: Int64, descriptionValue: String, dateValue: Date) -> Bool {
        do {
            
            let apptModels: [DBApptModel] = getAppts()
            let calendar =  Calendar.current
            var isNewAppt: Bool = true
            
            for appt in apptModels {
                if (appt.uId == uIdValue && appt.date.compare(dateValue, .hour) && calendar.isDate(appt.date, inSameDayAs: dateValue)) {
                    isNewAppt = false
                }
            }
            
            if isNewAppt {
                try db.run(
                    appts_table.insert(uId_appt <- uIdValue, description <- descriptionValue, apptDate <- dateValue)
                )
                
                return true
            }
            
        } catch {
            print("Error inserting appointment: \(error.localizedDescription)")
            return false
        }
        
        
        return false
    }
    
    public func addUser(firstNameValue: String, lastNameValue: String, emailValue: String, phoneNumberValue: String, passwordValue: String) -> Bool {
        do {
            
            let userModsls: [DBUserModel] = getUsers()
            var isNewUser: Bool = true
            
            for user in userModsls {
                if user.email == emailValue {
                    isNewUser = false
                }
            }
            
            if isNewUser {
                try db.run(
                    users_table.insert(firstName <- firstNameValue, lastName <- lastNameValue, email <- emailValue, phoneNumber <- phoneNumberValue, password <- passwordValue))
                
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return false
    }
    
    public func getAppts() -> [DBApptModel] {
        var apptsModels: [DBApptModel] = []
        
        appts_table = appts_table.order(apptId.desc)
        
        do {
            
            for appt in try db.prepare(appts_table) {
                let apptsModel: DBApptModel = DBApptModel()
                
                apptsModel.apptId = appt[apptId]
                apptsModel.uId = appt[uId_appt]
                apptsModel.description = appt[description]
                apptsModel.date = appt[apptDate]
                
                apptsModels.append(apptsModel)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return apptsModels
    }
    
    
    public func getUsers() -> [DBUserModel] {
        var userModels: [DBUserModel] = []
        
        users_table = users_table.order(uId.desc)
        
        do {
            for user in try db.prepare(users_table) {
                let userModel: DBUserModel = DBUserModel()
                
                userModel.uId = user[uId]
                userModel.firstName = user[firstName]
                userModel.lastName = user[lastName]
                userModel.email = user[email]
                userModel.phoneNumber = user[phoneNumber]
                userModel.password = user[password]
                
                userModels.append(userModel)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return userModels
    }
    
    public func getApptsByUID(uIdValue: Int64) -> [DBApptModel] {
        var apptsModels: [DBApptModel] = []
        
        appts_table = appts_table.order(apptId.desc)
        
        do {
            
            for appt in try db.prepare(appts_table.filter(uId_appt == uIdValue)) {
                let apptsModel: DBApptModel = DBApptModel()
                
                apptsModel.apptId = appt[apptId]
                apptsModel.uId = appt[uId_appt]
                apptsModel.description = appt[description]
                apptsModel.date = appt[apptDate]
                
                apptsModels.append(apptsModel)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return apptsModels
    }
    
    
    public func getUserByEmail(emailValue: String) -> DBUserModel {
    
        let user: DBUserModel = DBUserModel()
        
        do {
            let userRow: AnySequence<Row> = try db.prepare(users_table.filter(email == emailValue))
            
            try userRow.forEach({ (rowValue) in
                user.uId = try rowValue.get(uId)
                user.firstName = try rowValue.get(firstName)
                user.lastName = try rowValue.get(lastName)
                user.email = try rowValue.get(email)
                user.phoneNumber = try rowValue.get(phoneNumber)
                user.password = try rowValue.get(password)
            })
        } catch {
            print(error.localizedDescription)
        }
        
        return user
    
    }
    
    public func updateUser(uIdValue: Int64, emailValue: String, passwordValue: String, phoneNumberValue: String) -> Bool {
        
        do {
            let user: Table = users_table.filter(uId == uIdValue)
            
            try db.run(
                user.update(uId <- uIdValue, email <- emailValue, password <- passwordValue, phoneNumber <- phoneNumberValue)
            )
            return true
            
        } catch {
            print("Error updating user info: \(error.localizedDescription)")
            return false
        }
    }
    
}
