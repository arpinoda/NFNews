//
//  Helpers.swift
//  nfnews
//
//  Created by Work on 2/7/21.
//

import Foundation

class Helpers {
    static func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}

// https://stackoverflow.com/a/50281094
class OptionalFractionalSecondsDateFormatter: DateFormatter {

     // NOTE: iOS 11.3 added fractional second support to ISO8601DateFormatter,
     // but it behaves the same as plain DateFormatter. It is either enabled
     // and required, or disabled and... anti-required
     // let formatter = ISO8601DateFormatter()
     // formatter.timeZone = TimeZone(secondsFromGMT: 0)
     // formatter.formatOptions = [.withInternetDateTime ] // .withFractionalSeconds

    static let withoutSeconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        return formatter
    }()

    func setup() {
        self.calendar = Calendar(identifier: .iso8601)
        self.locale = Locale(identifier: "en_US_POSIX")
        self.timeZone = TimeZone(identifier: "UTC")
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX" // handle up to 6 decimal places, although iOS currently only preserves 2 digits of precision
    }

    override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func date(from string: String) -> Date? {
        if let result = super.date(from: string) {
            return result
        }
        return OptionalFractionalSecondsDateFormatter.withoutSeconds.date(from: string)
    }
}
