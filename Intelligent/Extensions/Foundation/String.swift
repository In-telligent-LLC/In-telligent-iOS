//
//  String.swift
//  Intelligent
//
//  Created by Kurt Jensen on 9/28/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

extension String {
    
    var isValidUsername: Bool {
        return alphanumericsLowercased.count >= 4
    }
    
    var isValidName: Bool {
        return !isEmpty
    }
    
    var isValidAddress: Bool {
        return !isEmpty
    }
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return regexCheck(regex: emailRegex)
    }
    
    var isValidPhoneNumber: Bool {
        return digits.count == 10
    }
    
    var alphanumerics: String {
        let alphanumerics = components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        return alphanumerics
    }
    
    var alphanumericsLowercased: String {
        return alphanumerics.lowercased()
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    func maxLength(_ maxLength: Int = -1) -> String {
        var text = self
        if maxLength > 0 {
            text = text.substring(span: maxLength) ?? text
        }
        return text
    }
    
    func substring(start: Int = 0, span: Int) -> String? {
        guard let start = index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        let end = index(start, offsetBy: span, limitedBy: endIndex) ?? endIndex
        return String(self[start..<end])
    }
    
    func substring(fromEndSpan: Int) -> String? {
        guard let end = index(endIndex, offsetBy: -fromEndSpan, limitedBy: startIndex) else {
            return nil
        }
        return String(self[end..<endIndex])
    }

    func regexCheck(regex: String) -> Bool {
        var isValid = false
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let result = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, count))
            isValid = result != nil
        } catch {
            isValid = false
        }
        return isValid
    }

}
