import class Foundation.Bundle
import XCTest

final class GenerateSubcommandTests: XCTestCase {
    func testHTMLGeneration() throws {
        let command = Bundle.productsDirectory.appendingPathComponent("swift-doc")
        let outputDirectory = try temporaryDirectory()

        defer { try? FileManager.default.removeItem(at: outputDirectory) }
        try Process.run(command: command,
                        arguments: [
                            "generate",
                            "--module-name", "SwiftDoc",
                            "--format", "html",
                            "--output", outputDirectory.path,
                            "Sources"
                        ]
        ) { result in
            XCTAssertEqual(result.terminationStatus, EXIT_SUCCESS)
            XCTAssertEqual(result.output, "")
            XCTAssertEqual(result.error, "")

            do {
                let html = try String(contentsOf: outputDirectory.appendingPathComponent("index.html"))
                XCTAssertTrue(html.contains("<!DOCTYPE html>"))
            }

            do {
                let css = try String(contentsOf: outputDirectory.appendingPathComponent("all.css"))
                XCTAssertTrue(css.contains(":root"))
            }
        }
    }
}
