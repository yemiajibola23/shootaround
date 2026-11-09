//
//  ShartedTestHelpers.swift
//  ShootaroundTests
//
//  Created by Yemi Ajibola on 11/8/26.
//

import Foundation
import SwiftData
@testable import Shootaround

func testURL(ext: String = ".store") -> URL { FileManager.default.temporaryDirectory.appending(path: UUID().uuidString + ext) }

func makeTestContext()  throws -> ModelContext {
    let url = testURL()
    
    let container = try makeContainer(storeURL: url)
    let context = ModelContext(container)
    
    return context
}
