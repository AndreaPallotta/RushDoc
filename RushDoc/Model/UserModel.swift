//
//  UserModel.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 4/22/21.
//

import Foundation
import Combine
import Regex

class UserModel: ObservableObject {
    
    // form validation input
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    
    // form validation output
    @Published var isSignUpValid: Bool = false
    @Published var isLoginValid: Bool = false
    
    private var cancelSet: Set<AnyCancellable> = []
    private let regexCharOnly: String = "[a-zA-Z]"
    private let regexEmail: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    // constructor
    init() {
        validateForm
          .receive(on: RunLoop.main)
          .assign(to: \.isSignUpValid, on: self)
          .store(in: &cancelSet)
        
        validateLogin
          .receive(on: RunLoop.main)
          .assign(to: \.isLoginValid, on: self)
          .store(in: &cancelSet)
        
    }
    
    public func validateForm(user: UserModel) -> Bool {
        let firstName = 1...15 ~= user.firstName.count && user.firstName.trimmingCharacters(in: .whitespacesAndNewlines) =~ self.regexCharOnly.r
        
        let lastName = 1...15 ~= user.lastName.count && user.lastName.trimmingCharacters(in: .whitespacesAndNewlines) =~ self.regexCharOnly.r
        
        let email = user.email != "" && user.email.trimmingCharacters(in: .whitespacesAndNewlines) =~ self.regexEmail.r
        
        let password = 8...15 ~= user.password.count && user.password == user.repeatPassword
        
        return firstName && lastName && email && password
    }
    
    // validation functions
    private var validateFirstName: AnyPublisher<Bool, Never> {
        $firstName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return 1...25 ~= input.count && input.trimmingCharacters(in: .whitespacesAndNewlines) =~ self.regexCharOnly.r
            }
            .eraseToAnyPublisher()
    }
    
    private var validateLastName: AnyPublisher<Bool, Never> {
        $lastName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return 1...25 ~= input.count && input.trimmingCharacters(in: .whitespacesAndNewlines) =~ self.regexCharOnly.r
            }
            .eraseToAnyPublisher()
    }
    
    private var validateEmail: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.trimmingCharacters(in: .whitespacesAndNewlines) != "" && input.trimmingCharacters(in: .whitespacesAndNewlines) =~ self.regexEmail.r
            }
            .eraseToAnyPublisher()
    }
    
    private var validatePhoneNumber: AnyPublisher<Bool, Never> {
        $phoneNumber
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input.trimmingCharacters(in: .whitespacesAndNewlines) != ""
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordNotEmpty: AnyPublisher<Bool, Never> {
        $password
          .debounce(for: 0.8, scheduler: RunLoop.main)
          .removeDuplicates()
          .map { password in
            return password.trimmingCharacters(in: .whitespacesAndNewlines) != ""
          }
          .eraseToAnyPublisher()
    }
    
    private var validatePasswordMatch: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $repeatPassword)
          .map { password, repeatPassword in
            return password.trimmingCharacters(in: .whitespacesAndNewlines) == repeatPassword.trimmingCharacters(in: .whitespacesAndNewlines) && password != "" && repeatPassword != ""
          }
          .eraseToAnyPublisher()
    }
    
    private var validatePassword: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isPasswordNotEmpty, validatePasswordMatch)
            .map { passwordIsNotEmpty, passwordsAreEqual in
                /// TODO: Fix validatePasswordMatch()
                return passwordIsNotEmpty //&& passwordsAreEqual
            }
            .eraseToAnyPublisher()
    }
    
    private var validateFormFields: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(validateFirstName, validateLastName, validateEmail, validatePhoneNumber)
          .map { firstNameIsValid, lastNameIsValid, emailIsValid, phoneNumberIsValid in
            return firstNameIsValid && lastNameIsValid && emailIsValid && phoneNumberIsValid
          }
        .eraseToAnyPublisher()
      }
    
    private var validateForm: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(validateFormFields, validatePassword)
          .map { formFieldsAreValid, passwordIsValid in
            return formFieldsAreValid && passwordIsValid
          }
        .eraseToAnyPublisher()
      }
    
    private var validateLogin: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(validateEmail, isPasswordNotEmpty)
            .map { emailIsValid, passwordIsValid in
                return emailIsValid && passwordIsValid
            }
            .eraseToAnyPublisher()
    }
    
    
}

enum PasswordCheck {
    case valid
    case empty
    case noMatch
}
