//
//  NotificationViewerTests.swift
//  NotificationViewerTests
//
//  Created by JH on 11/2/24.
//

import Testing
@testable import NotificationViewer

struct NotificationViewerTests {

    @Test func example() async throws {
        NotificationCenter.default.post(name: .init("test"), object: nil)
        try await Task.sleep(nanoseconds: 10000000000)
    }

}
