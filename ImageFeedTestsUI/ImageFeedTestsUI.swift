//
//  ImageFeedTestsUI.swift
//  ImageFeedTestsUI
//
//  Created by Алик on 13.10.2026.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 10), "Кнопка авторизации не появилась")
        authButton.tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 15), "WebView не загрузился")
        
        let loginTextField = webView.textFields.firstMatch
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10), "Поле логина не найдено")
        
        loginTextField.tap()
        loginTextField.typeText("<эл.почта>")
        webView.swipeUp()
        
        let passwordTextField = webView.secureTextFields.firstMatch
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10), "Поле пароля не найдено")
        
        passwordTextField.tap()
        passwordTextField.typeText("<пароль>")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.cells.element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 15), "Лента приложения не загрузилась после авторизации")
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10), "Первая ячейка таблицы не загрузилась вовремя")//
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 0) // Работаем с первой ячейкой
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 7))
        
        let likeButtonOff = cellToLike.buttons["like button off"]
        let likeButtonOn = cellToLike.buttons["like button on"]
        
        if likeButtonOff.exists {
            likeButtonOff.tap()
            //XCTAssertTrue(likeButtonOn.waitForExistence(timeout: 10))
        } else if likeButtonOn.exists {
            likeButtonOn.tap()
            XCTAssertTrue(likeButtonOff.waitForExistence(timeout: 10))
        } else {
            XCTFail("Кнопка лайка не найдена в ячейке")
        }
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
        let tabBar = app.tabBars.element
        XCTAssertTrue(tabBar.waitForExistence(timeout: 7), "Панель таббара не появилась на экране")
        let profileTabButton = tabBar.buttons.element(boundBy: 1)
        XCTAssertTrue(profileTabButton.waitForExistence(timeout: 5), "Кнопка профиля в таббаре не найдена")
        
        profileTabButton.tap()
        
        let nameLabel = app.staticTexts.element(boundBy: 0)
        let loginLabel = app.staticTexts.element(boundBy: 1)
        
        XCTAssertTrue(nameLabel.waitForExistence(timeout: 5), "Имя пользователя не появилось")
        XCTAssertTrue(loginLabel.exists)
        
        let logoutButton = app.buttons["logout button"]
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 5))
        logoutButton.tap()
        
        let alert = app.alerts["Выйти из аккаунта?"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        alert.buttons["Выйти"].tap()
        
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 10), "экран авторизации не открылся")        
    }
}


