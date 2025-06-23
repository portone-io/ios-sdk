import SwiftUI

enum PortOneLogger {
  static func log(
    _ message: @autoclosure () -> String, file: String = #file, function: String = #function,
    line: Int = #line
  ) {
    #if DEBUG
      let fileName = (file as NSString).lastPathComponent
      print("portone-ios-sdk [\(fileName):\(line) \(function)] - \(message())")
    #endif
  }
}
