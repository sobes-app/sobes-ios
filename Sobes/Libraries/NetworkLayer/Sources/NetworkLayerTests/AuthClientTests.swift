import XCTest
import OHHTTPStubsSwift
import OHHTTPStubs
@testable import NetworkLayer

class AuthClientTests: XCTestCase {
    
    var accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ2c2hnckB5YS5ydSIsImlhdCI6MTcxNTc4MzkxNywiZXhwIjoxNzE1Nzg3NTE3fQ.ylNIWcqiXA6Eqe4MmcjHWpgbulq088ZpvDne0ub6eCe-oCWbLaNTWA-anWBs4IEm5Krf1AbrhbKoSxtLocVIGw"
    
    let testEmail = "vshgr@ya.ru"
    let testUsername = "Тестовый аккаунт"
    var testRefreshToken = "f7a808c4-8ef7-4886-9622-db9982ae9b02"
    let testTokenType = "Bearer"
    var testPassword = "1234"

    var authClient: AuthClient!

    override func setUpWithError() throws {
        try super.setUpWithError()
        authClient = AuthClient()
    }

    override func tearDownWithError() throws {
        authClient = nil
        HTTPStubs.removeAllStubs()
        try super.tearDownWithError()
    }
    
    func testSendEmailIntegration() async throws {
        let authClient = AuthClient()
        let email = "alitella2010@ya.ru"
        let result = await authClient.sendEmail(email: email)
        
        switch result {
        case .success(let response):
            print("Email sent successfully: \(response)")
            XCTAssertNotNil(response)
        case .failure(let error):
            XCTFail("Failed to send email: \(error)")
        }
    }
    
    func testAuthUserSuccessfully() async throws {
        let authClient = AuthClient()
        let result = await authClient.authUser(email: testEmail, password: testPassword)
        
        switch result {
        case .success(let response):
            testRefreshToken = response.refreshToken
            accessToken = response.token
            XCTAssertTrue(type(of: response) == SignUpResponse.self)
        case .failure(let error):
            XCTFail("Failed to auth user: \(error)")
        }
    }
    
    func testRefreshToken() async throws {
        let authClient = AuthClient()
        let result = await authClient.refreshToken(refreshToken: testRefreshToken)
        
        switch result {
        case .success(let response):
            accessToken = response.accessToken
            XCTAssertTrue(type(of: response) == RefreshAccessTokenResponse.self)
        case .failure(let error):
            XCTFail("Failed to auth user: \(error)")
        }
    }
    
    func testRecoverAccount() async throws {
        let authClient = AuthClient()
        let result = await authClient.recoverAccountRequest(email: testEmail)
        
        switch result {
        case .success(let response):
            XCTAssertTrue(type(of: response) == [String:String].self)
        case .failure(let error):
            XCTFail("Failed to auth user: \(error)")
        }
    }
    
    func testUpdatePassword() async throws {
        let authClient = AuthClient()
        let result = await authClient.updatePassword(email: testEmail, password: "1234")
        
        switch result {
        case .success(let response):
            testPassword = "1234"
            XCTAssertTrue(type(of: response) == [String:String].self)
        case .failure(let error):
            XCTFail("Failed to auth user: \(error)")
        }
    }
}
