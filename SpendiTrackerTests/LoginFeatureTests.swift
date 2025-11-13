//
//  LoginFeatureTests.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 13/11/25.
//

import Testing
@testable import SpendiTracker

struct LoginFeatureTests {

    // MARK: - Login Validation Tests

    @Test("Email validation accepts common valid email")
    func emailValidation_valid() async throws {
        let vm = LoginViewModel()
        vm.email = "user@example.com"
        #expect(vm.isEmailValid() == true)
    }

    @Test("Email validation rejects invalid email formats")
    func emailValidation_invalid() async throws {
        let vm = LoginViewModel()
        for invalid in ["", "user", "user@", "@example.com", "user@example", "user@example.", "user@@example.com", "user example@example.com"] {
            vm.email = invalid
            #expect(vm.isEmailValid() == false, "Expected invalid email to fail: \(invalid)")
        }
    }

    @Test("Password validation passes when it meets all requirements")
    func passwordValidation_valid() async throws {
        let vm = LoginViewModel()
        vm.password = "Password1" // >=8 chars, 1 uppercase, 1 lowercase, 1 digit
        #expect(vm.isPasswordValid() == true)
    }

    @Test("Password validation fails when requirements are not met")
    func passwordValidation_invalid() async throws {
        let vm = LoginViewModel()
        for invalid in [
            "",                 // empty
            "pass",             // too short
            "password",         // no uppercase or digit
            "PASSWORD",         // no lowercase or digit
            "Password",         // no digit
            "password1",        // no uppercase
            "PASSWORD1"         // no lowercase
        ] {
            vm.password = invalid
            #expect(vm.isPasswordValid() == false, "Expected invalid password to fail: \(invalid)")
        }
    }

    @Test("Prompts are empty when valid or showPromp is false")
    func prompts_hiddenWhenValidOrPromptDisabled() async throws {
        let vm = LoginViewModel()
        vm.showPromp = false

        // Even if invalid, with showPromp == false prompts should be empty
        vm.email = "invalid"
        vm.password = "short"
        #expect(vm.emailPrompt.isEmpty)
        #expect(vm.passwordPrompt.isEmpty)

        // With valid values, prompts stay empty regardless of showPromp
        vm.email = "user@example.com"
        vm.password = "Password1"
        vm.showPromp = true
        #expect(vm.emailPrompt.isEmpty)
        #expect(vm.passwordPrompt.isEmpty)
    }

    @Test("Prompts are shown when invalid and showPromp is true")
    func prompts_shownWhenInvalidAndPromptEnabled() async throws {
        let vm = LoginViewModel()
        vm.showPromp = true
        vm.email = "invalid"
        vm.password = "short"
        #expect(vm.emailPrompt.isEmpty == false)
        #expect(vm.passwordPrompt.isEmpty == false)
    }

    @Test("isSignUpComplete sets showPromp and returns false when invalid")
    func isSignUpComplete_invalid() async throws {
        let vm = LoginViewModel()
        vm.email = "bad"
        vm.password = "short"
        let complete = vm.isSignUpComplete
        #expect(complete == false)
        #expect(vm.showPromp == true)
    }

    @Test("isSignUpComplete returns true when email and password are valid")
    func isSignUpComplete_valid() async throws {
        let vm = LoginViewModel()
        vm.email = "user@example.com"
        vm.password = "Password1"
        // showPromp should remain unchanged (default false) when valid
        let complete = vm.isSignUpComplete
        #expect(complete == true)
        #expect(vm.showPromp == false)
    }

    // MARK: - State Reset Tests

    @Test("resetValue clears token and message")
    func resetValue_clearsState() async throws {
        let vm = LoginViewModel()
        vm.token = "abc"
        vm.message = "Hello"
        vm.resetValue()
        #expect(vm.token == nil)
        #expect(vm.message.isEmpty)
    }

    @Test("clearField clears email and password only")
    func clearField_clearsCredentials() async throws {
        let vm = LoginViewModel()
        vm.email = "user@example.com"
        vm.password = "Password1"
        vm.firstName = "John"
        vm.lastName = "Doe"

        vm.clearField()

        #expect(vm.email.isEmpty)
        #expect(vm.password.isEmpty)
        // Ensure other fields are untouched
        #expect(vm.firstName == "John")
        #expect(vm.lastName == "Doe")
    }

    // MARK: - API Layer Tests (Login)

    @Test("LoginUseCase returns response on success")
    func loginUseCase_success() async throws {
        // Arrange
        let expected = LoginResponseModel(
            user: User(email: "user@example.com", id: "1", lastName: "Doe", firstName: "John"),
            accessToken: "access-token",
            refreshToken: "refresh-token"
        )
        let fakeRemote = FakeLoginRemoteDatasource(result: .success(expected))
        let repo = LoginRepositoryImpl(remoteDataSource: fakeRemote)
        let usecase = LoginUseCase(repository: repo)
        let request = LoginRequestModel(email: "user@example.com", password: "Password1")

        // Act
        let response = try await usecase.execute(data: request)

        // Assert
        let res = try #require(response)
        #expect(res.accessToken == expected.accessToken)
        #expect(res.refreshToken == expected.refreshToken)
        #expect(res.user.email == expected.user.email)
        #expect(res.user.firstName == expected.user.firstName)
        #expect(res.user.lastName == expected.user.lastName)
        #expect(res.user.id == expected.user.id)
    }

    @Test("LoginUseCase propagates ErrorResponse on failure")
    func loginUseCase_failure_propagatesError() async throws {
        // Arrange
        let apiError = ErrorResponse(error: true, reason: "Invalid credentials", errorCode: "AUTH_401")
        let fakeRemote = FakeLoginRemoteDatasource(result: .failure(apiError))
        let repo = LoginRepositoryImpl(remoteDataSource: fakeRemote)
        let usecase = LoginUseCase(repository: repo)
        let request = LoginRequestModel(email: "user@example.com", password: "wrongpass")

        // Act & Assert
        do {
            _ = try await usecase.execute(data: request)
            Issue.record("Expected execute to throw, but it succeeded")
        } catch let error as ErrorResponse {
            #expect(error.reason == apiError.reason)
            #expect(error.errorCode == apiError.errorCode)
        } catch {
            Issue.record("Expected ErrorResponse, got: \(error)")
        }
    }

    @Test("Repository forwards request to remote data source")
    func loginRepository_forwardsParameters() async throws {
        // Arrange: a spy that records the last request
        var captured: LoginRequestModel?
        let fake = FakeLoginRemoteDatasource { request in
            captured = request
            return LoginResponseModel(
                user: User(email: request.email, id: "id-123", lastName: "Doe", firstName: "John"),
                accessToken: "token-123",
                refreshToken: "refresh-123"
            )
        }
        let repo = LoginRepositoryImpl(remoteDataSource: fake)
        let request = LoginRequestModel(email: "spy@example.com", password: "Password1")

        // Act
        _ = try await repo.doLogin(data: request)

        // Assert
        let sent = try #require(captured)
        #expect(sent.email == request.email)
        #expect(sent.password == request.password)
    }
    
    
    @Test("LoginViewModel.login sets loaded state and saves token on success")
    func loginViewModel_login_success() async throws {
        // Arrange
        let expected = LoginResponseModel(
            user: User(email: "user@example.com", id: "1", lastName: "Doe", firstName: "John"),
            accessToken: "access-token",
            refreshToken: "refresh-token"
        )

        let fakeRemote = FakeLoginRemoteDatasource(result: .success(expected))
        let repo = LoginRepositoryImpl(remoteDataSource: fakeRemote)
        let usecase = LoginUseCase(repository: repo)
        let vm = LoginViewModel(loginUseCase: usecase)

        // Act
        await vm.login(data: LoginRequestModel(email: "user@example.com", password: "Password1"))

        // Assert
        switch vm.loadingState {
        case .loaded(let res):
            #expect(res.accessToken == expected.accessToken)
            #expect(vm.token == expected.accessToken)
            #expect(vm.message == "Berhasil Login")
        default:
            Issue.record("Expected loaded state on success, got: \(vm.loadingState)")
        }
    }

    @Test("LoginViewModel.login sets failed state on error")
    func loginViewModel_login_failure() async throws {
        // Arrange
        let apiError = ErrorResponse(error: true, reason: "Invalid credentials", errorCode: "AUTH_401")
        let fakeRemote = FakeLoginRemoteDatasource(result: .failure(apiError))
        let repo = LoginRepositoryImpl(remoteDataSource: fakeRemote)
        let usecase = LoginUseCase(repository: repo)
        let vm = LoginViewModel(loginUseCase: usecase)

        // Act
        await vm.login(data: LoginRequestModel(email: "user@example.com", password: "wrongpass"))

        // Assert
        switch vm.loadingState {
        case .failed(let message):
            #expect(message == apiError.reason)
        default:
            Issue.record("Expected failed state on error, got: \(vm.loadingState)")
        }
    }
}

// MARK: - Test Doubles

private struct FakeLoginRemoteDatasource: LoginRemoteDatasource {
    enum ResultKind {
        case success(LoginResponseModel)
        case failure(Error)
    }

    private let behavior: (LoginRequestModel) async throws -> LoginResponseModel?

    init(result: ResultKind) {
        switch result {
        case .success(let response):
            self.behavior = { _ in response }
        case .failure(let error):
            self.behavior = { _ in throw error }
        }
    }

    init(_ behavior: @escaping (LoginRequestModel) async throws -> LoginResponseModel?) {
        self.behavior = behavior
    }

    func login(data: LoginRequestModel) async throws -> LoginResponseModel? {
        try await behavior(data)
    }
}

