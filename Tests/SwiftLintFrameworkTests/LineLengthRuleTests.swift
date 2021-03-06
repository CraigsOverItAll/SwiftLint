import SourceKittenFramework
@testable import SwiftLintFramework
import XCTest

class LineLengthRuleTests: XCTestCase {
    private let longFunctionDeclarations = [
        "public func superDuperLongFunctionDeclaration(a: String, b: String, " +
            "c: String, d: String, e: String, f: String, g: String, h: String, i: String, " +
            "j: String, k: String, l: String, m: String, n: String, o: String, p: String, " +
            "q: String, r: String, s: String, t: String, u: String, v: String, w: String, " +
            "x: String, y: String, z: String) {\n",
        "func superDuperLongFunctionDeclaration(a: String, b: String, " +
            "c: String, d: String, e: String, f: String, g: String, h: String, i: String, " +
            "j: String, k: String, l: String, m: String, n: String, o: String, p: String, " +
            "q: String, r: String, s: String, t: String, u: String, v: String, w: String, " +
            "x: String, y: String, z: String) {\n"
    ]

    private let longComment = String(repeating: "/", count: 121) + "\n"
    private let longBlockComment = "/*" + String(repeating: " ", count: 121) + "*/\n"
    private let declarationWithTrailingLongComment = "let foo = 1 " + String(repeating: "/", count: 121) + "\n"
    private let interpolatedString = "print(\"\\(value)" + String(repeating: "A", count: 113) + "\" )\n"
    private let plainString = "print(\"" + String(repeating: "A", count: 121) + ")\"\n"

    func testLineLength() {
        verifyRule(LineLengthRule.description, commentDoesntViolate: false, stringDoesntViolate: false)
    }

    func testLineLengthWithIgnoreFunctionDeclarationsEnabled() {
        let baseDescription = LineLengthRule.description
        let nonTriggeringExamples = baseDescription.nonTriggeringExamples + longFunctionDeclarations
        let description = baseDescription.with(nonTriggeringExamples: nonTriggeringExamples)

        verifyRule(description, ruleConfiguration: ["ignores_function_declarations": true],
                   commentDoesntViolate: false, stringDoesntViolate: false)
    }

    func testLineLengthWithIgnoreCommentsEnabled() {
        let baseDescription = LineLengthRule.description
        let triggeringExamples = longFunctionDeclarations + [declarationWithTrailingLongComment]
        let nonTriggeringExamples = [longComment, longBlockComment]

        let description = baseDescription.with(nonTriggeringExamples: nonTriggeringExamples)
                                         .with(triggeringExamples: triggeringExamples)

        verifyRule(description, ruleConfiguration: ["ignores_comments": true],
                   commentDoesntViolate: false, stringDoesntViolate: false, skipCommentTests: true)
    }

    func testLineLengthWithIgnoreURLsEnabled() {
        let url = "https://github.com/realm/SwiftLint"
        let triggeringLines = [String(repeating: "/", count: 121) + "\(url)\n"]
        let nonTriggeringLines = [
            "\(url) " + String(repeating: "/", count: 118) + " \(url)\n",
            "\(url)/" + String(repeating: "a", count: 120)
        ]

        let baseDescription = LineLengthRule.description
        let nonTriggeringExamples = baseDescription.nonTriggeringExamples + nonTriggeringLines
        let triggeringExamples = baseDescription.triggeringExamples + triggeringLines

        let description = baseDescription.with(nonTriggeringExamples: nonTriggeringExamples)
                                         .with(triggeringExamples: triggeringExamples)

        verifyRule(description, ruleConfiguration: ["ignores_urls": true],
                   commentDoesntViolate: false, stringDoesntViolate: false)
    }

    func testLineLengthWithIgnoreInterpolatedStringsTrue() {
        let triggeringLines = [plainString]
        let nonTriggeringLines = [interpolatedString]

        let baseDescription = LineLengthRule.description
        let nonTriggeringExamples = baseDescription.nonTriggeringExamples + nonTriggeringLines
        let triggeringExamples = baseDescription.triggeringExamples + triggeringLines

        let description = baseDescription.with(nonTriggeringExamples: nonTriggeringExamples)
            .with(triggeringExamples: triggeringExamples)

        verifyRule(description, ruleConfiguration: ["ignores_interpolated_strings": true],
                   commentDoesntViolate: false, stringDoesntViolate: false)
    }
    func testLineLengthWithIgnoreInterpolatedStringsFalse() {
        let triggeringLines = [plainString, interpolatedString]

        let baseDescription = LineLengthRule.description
        let nonTriggeringExamples = baseDescription.nonTriggeringExamples
        let triggeringExamples = baseDescription.triggeringExamples + triggeringLines

        let description = baseDescription.with(nonTriggeringExamples: nonTriggeringExamples)
            .with(triggeringExamples: triggeringExamples)

        verifyRule(description, ruleConfiguration: ["ignores_interpolated_strings": false],
                   commentDoesntViolate: false, stringDoesntViolate: false)
    }
}
