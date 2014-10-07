//  Copyright (c) 2014 Rob Rix. All rights reserved.

import XCTest
import Foundation
import Auspicion

class AuspicionTests: XCTestCase {
    
    let source: String = "int main(int argc, char *argv[]) { return 0; }"
    
    func createTestFile() -> (String, String) {
        let path = NSTemporaryDirectory().stringByAppendingPathComponent("test.c")
        let output = NSTemporaryDirectory().stringByAppendingPathComponent("test.o")
        source.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        return (path, output)
    }
    
    func testIndexCreation() {
        let idx = Index(excludeDeclarationsFromPCH: false, displayDiagnostics: false)
    }
    
    func testTUCreation() {
        let idx = Index(excludeDeclarationsFromPCH: false, displayDiagnostics: false)
        var path: String
        var output: String
        (path, output) = createTestFile()
        
        let TU = TranslationUnit(index: idx, sourceFile: path, args: ["-c", path, "-o", output])
    }
    
    func testFileAccess() {
        let idx = Index(excludeDeclarationsFromPCH: false, displayDiagnostics: false)
        var path: String
        var output: String
        (path, output) = createTestFile()
        
        let TU = TranslationUnit(index: idx, sourceFile: path, args: ["-c", path, "-o", output])
        let f = TU.file(path)
        XCTAssertEqual(f.path, path, "Expected file path should be equal")
    }
    
    func testFileRange() {
        let idx = Index(excludeDeclarationsFromPCH: false, displayDiagnostics: false)
        var path: String
        var output: String
        (path, output) = createTestFile()
        
        let TU = TranslationUnit(index: idx, sourceFile: path, args: ["-c", path, "-o", output])
        let f = TU.file(path)
        let r = SourceRange(begin: SourceLocation(tu: TU, file: f, offset: 0), end: SourceLocation(tu: TU, file: f, offset: source.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
    }
    
    func testTUTokenize() {
        let idx = Index(excludeDeclarationsFromPCH: false, displayDiagnostics: false)
        var path: String
        var output: String
        (path, output) = createTestFile()
        
        let TU = TranslationUnit(index: idx, sourceFile: path, args: ["-c", path, "-o", output])
        let f = TU.file(path)
        let r = SourceRange(begin: SourceLocation(tu: TU, file: f, offset: 0), end: SourceLocation(tu: TU, file: f, offset: source.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
        let tokens = TU.tokenize(r)
        XCTAssertEqual(tokens.count, 17, "Expected 17 tokens from test source file")
        let expectedTypes: [String] = ["Keyword",
            "Identifier",
            "Punctuation",
            "Keyword",
            "Identifier",
            "Punctuation",
            "Keyword",
            "Punctuation",
            "Identifier",
            "Punctuation",
            "Punctuation",
            "Punctuation",
            "Punctuation",
            "Keyword",
            "Literal",
            "Punctuation",
            "Punctuation"]
        for var i = 0; i < tokens.count; i++ {
            XCTAssertEqual(tokens[i].kind.name, expectedTypes[i], "Unexpected token type")
        }
    }
    
}
