//
//  LoginFeatureUITests.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 13/11/25.
//

import XCTest

final class LoginFeatureUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testLoginButtonDisabledUntilFieldsFilled() throws {
        let app = XCUIApplication()
        app.launch()

        let emailField = app.textFields["login_email_field"].firstMatch
        let passwordField = app.secureTextFields["login_password_field"].firstMatch
        let signInWelcomeButton = app.buttons["login_welcome_button"].firstMatch
        let signInButton = app.buttons["login_signin_button"].firstMatch
        signInWelcomeButton.tap()
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        XCTAssertTrue(signInButton.waitForExistence(timeout: 5))

        emailField.tap()
        emailField.typeText("user@example.com")

        passwordField.tap()
        passwordField.typeText("WrongPass1")
        XCTAssertTrue(signInButton.isEnabled, "Sign In button should be enabled when fields are filled")
    }
    
    @MainActor
    func testLoginFlow_showsErrorToastOnSuccess() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITEST_FORCE_LOGIN_SUCCESS"] = "1"
        app.launch()

        let emailField = app.textFields["login_email_field"].firstMatch
        let passwordField = app.secureTextFields["login_password_field"].firstMatch
        let signInWelcomeButton = app.buttons["login_welcome_button"].firstMatch
        let signInButton = app.buttons["login_signin_button"].firstMatch
        signInWelcomeButton.tap()

        emailField.tap()
        emailField.typeText("irfandarys@gmail.com")

        passwordField.tap()
        passwordField.typeText("12345678")

        XCTAssertTrue(signInButton.isEnabled)
        signInButton.tap()
        
        let failedPredicate = NSPredicate(format: "label CONTAINS[c] 'success'")
        let errorLabel = app.staticTexts.containing(failedPredicate).firstMatch
        XCTAssertTrue(errorLabel.waitForExistence(timeout: 5), "Expected an error message to appear after failed login")
    }

    @MainActor
    func testLoginFlow_showsErrorToastOnFailure() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITEST_FORCE_LOGIN_FAILURE"] = "1"
        app.launch()

        let emailField = app.textFields["login_email_field"].firstMatch
        let passwordField = app.secureTextFields["login_password_field"].firstMatch
        let signInWelcomeButton = app.buttons["login_welcome_button"].firstMatch
        let signInButton = app.buttons["login_signin_button"].firstMatch
        signInWelcomeButton.tap()
        
        emailField.tap()
        emailField.typeText("user@example.com")

        passwordField.tap()
        passwordField.typeText("WrongPass1")

        XCTAssertTrue(signInButton.isEnabled)
        signInButton.tap()
        
        let failedPredicate = NSPredicate(format: "label CONTAINS[c] 'failed' OR label CONTAINS[c] 'error' OR label CONTAINS[c] 'unable' OR label CONTAINS[c] 'incorrect'")
        let errorLabel = app.staticTexts.containing(failedPredicate).firstMatch
        XCTAssertTrue(errorLabel.waitForExistence(timeout: 5), "Expected an error message to appear after failed login")
    }
}
