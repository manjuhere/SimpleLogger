//
//  Logger.swift
//  L-Connectt
//
//  Created by Manjunath Chandrashekar on 03/12/17.
//  Copyright © 2017 Manjunath Chandrashekar. All rights reserved.
//

import Foundation

class Log {
    
    static let dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSSSZ"
    class var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    private class func writeTofile(_ content: Any) {
        let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("\(appName).log")
        
        if let outputStream = OutputStream(url: fileURL, append: true) {
            outputStream.open()
            let string = "\n" + String.init(describing: content)
            let bytesWritten = outputStream.write(string, maxLength: string.lengthOfBytes(using: .utf8))
            if bytesWritten < 0 {
                print("write failure")
            }
            outputStream.close()
        } else {
            print("Unable to open file")
        }
    }

    class func error(_ message: Any,
                     fileName: String = #file,
                     line: Int = #line,
                     column: Int = #column,
                     funcName: String = #function) {
        let content = "\(Date().toString()) [Error][\(sourceFileName(filePath: fileName))]:\(funcName) \(line):\(column) -> \(message)"
        print(content)
        writeTofile(content)
    }
    
    class func warning(_ message: Any,
                     fileName: String = #file,
                     line: Int = #line,
                     column: Int = #column,
                     funcName: String = #function) {
        let content = "\(Date().toString()) [Warning][\(sourceFileName(filePath: fileName))]:\(funcName) \(line):\(column) -> \(message)"
        print(content)
        writeTofile(content)
    }
    
    class func debug(_ message: Any,
                       fileName: String = #file,
                       line: Int = #line,
                       column: Int = #column,
                       funcName: String = #function) {
        #if DEBUG
            let content = "\(Date().toString()) [Debug][\(sourceFileName(filePath: fileName))]:\(funcName) \(line):\(column) -> \(message)"
            print(content)
            writeTofile(content)
        #endif
    }
    
    class func info(_ message: Any,
                     fileName: String = #file,
                     line: Int = #line,
                     column: Int = #column,
                     funcName: String = #function) {
        #if DEBUG
            let content = "\(Date().toString()) [Info][\(sourceFileName(filePath: fileName))]:\(funcName) \(line):\(column) -> \(message)"
            print(content)
            writeTofile(content)
        #endif
    }
    
}

internal extension Date {
    func toString() -> String {
        return Log.dateFormatter.string(from: self as Date)
    }
}
