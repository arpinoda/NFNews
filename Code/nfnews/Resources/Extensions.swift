//
//  Extensions.swift
//  nfnews
//
//  Created by Work on 2/8/21.
//

import UIKit

/// https://gist.github.com/JayachandraA/1248545d4d8d8556a4b1ea1bbd729180
extension CAGradientLayer {
    func apply(angle : Double) {
        let x: Double! = angle / 360.0
        let a = pow(sinf(Float(2.0 * Double.pi * ((x + 0.75) / 2.0))),2.0);
        let b = pow(sinf(Float(2*Double.pi*((x+0.0)/2))),2);
        let c = pow(sinf(Float(2*Double.pi*((x+0.25)/2))),2);
        let d = pow(sinf(Float(2*Double.pi*((x+0.5)/2))),2);
        
        endPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
        startPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
    }
}

extension UIView {
    func addGradientBackground(colors: UIColor..., colorLocations: [NSNumber] = [NSNumber](), angle: Double = 0.0, rect: CGRect = .zero) {
        
        var locations = [NSNumber]()
        let gradientLayer = CAGradientLayer()
        gradientLayer.apply(angle: angle)
        gradientLayer.frame = (rect == .zero) ? bounds : rect
        gradientLayer.colors = [CGColor]()
        
        for (index, color) in colors.enumerated() {
            var location: NSNumber
            gradientLayer.colors!.append(color.cgColor)
            
            if colorLocations.indices.contains(index) {
                location = colorLocations[index]
            } else {
                location = NSNumber(value: index / (colors.count - 1))
            }
            locations.append(location)
        }
        gradientLayer.locations = locations
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIImage {
    func tinted(color: UIColor) -> UIImage? {
        let image = self.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color

        UIGraphicsBeginImageContext(image.size)
        if let context = UIGraphicsGetCurrentContext() {
            imageView.layer.render(in: context)
            let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return tintedImage
        } else {
            return self
        }
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
//        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }.withRenderingMode(.alwaysOriginal)
    }
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
//        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }.withRenderingMode(.alwaysOriginal)
    }
    
    class func combine(images: UIImage...) -> UIImage? {
        var contextSize = CGSize.zero

        for image in images {
            contextSize.width = max(contextSize.width, image.size.width)
            contextSize.height = max(contextSize.height, image.size.height)
        }

        UIGraphicsBeginImageContextWithOptions(contextSize, false, UIScreen.main.scale)

        for image in images {
            let originX = (contextSize.width - image.size.width) / 2
            let originY = (contextSize.height - image.size.height) / 2

            image.draw(in: CGRect(x: originX, y: originY, width: image.size.width, height: image.size.height))
        }

        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return combinedImage
    }
}

extension UITableView {
    public func register<T: UITableViewCell>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

extension UICollectionView {
    public func register<T: UITableViewCell>(cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
}

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

//  https://github.com/ilin-in/PrettyDate-Swift
extension Date {
    /**
     Helper method for timestamps between now and the date provided
     @return lowercase string, see readme for examples
     */
    static func prettyTimestamp(since date: Date) -> String {
        return Date().prettyTimestamp(since: date)
    }

    /**
     Timestamp between now and the NSDate instance
     @return lowercase string, see readme for examples
     */
    func prettyTimestampSinceNow() -> String {
        return prettyTimestamp(since: Date())
    }

    /**
     Timestamp between the date provided and the NSDate instance
     @return lowercase string, see readme for examples
     */
    func prettyTimestamp(since date: Date) -> String {
        return prettyTimestamp(since: date, withFormat: nil)
    }

    /**
     Timestamp between the date provided and the receiver, using the given format
     @param date The date to compare to the receiver
     @param format The format to print in. Format options are: %i for interval, e.g. "4"; %u for unit, e.g. "weeks"; %c for constant, e.g. "ago".
     Any other characters in the format will be left untouched, i.e. they will appear in the output.
     If the format is nil, then the default format is used, i.e. "%i %u %c", e.g. "4 weeks ago"
     @note Use this method if you don't want the default format, for example, if you don't want spaces between the components, or if you want to add other decorative text.
     @return lowercase string in the given format, see readme for examples
     */
    func prettyTimestamp(since date: Date, withFormat customFormat: String?) -> String {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.minute, .hour, .day, .weekOfYear, .month, .year])
        let earliest = date < self ? date : self
        let latest: Date = (earliest == self) ? date : self
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        let format = (customFormat == nil || customFormat == "") ? "%i %u %c" : customFormat!
        if let year = components.year, year >= 1 {
            return "over a year ago"
        }
        if let month = components.month, month >= 1 {
            return string(forComponentValue: month, withName: "month", andPlural: "mo", format: format)
        }
        if let weekOfYear = components.weekOfYear, weekOfYear >= 1 {
            return string(forComponentValue: weekOfYear, withName: "week", andPlural: "w", format: format)
        }
        if let day = components.day, day >= 1 {
            return string(forComponentValue: day, withName: "day", andPlural: "d", format: format)
        }
        if let hour = components.hour, hour >= 1 {
            return string(forComponentValue: hour, withName: "hour", andPlural: "h", format: format)
        }
        if let minute = components.minute, minute >= 1 {
            return string(forComponentValue: minute, withName: "minute", andPlural: "m", format: format)
        }
        return NSLocalizedString("now", comment: "")
    }

    func string(forComponentValue componentValue: Int, withName name: String, andPlural plural: String, format: String) -> String {
        let timespan = NSLocalizedString(componentValue == 1 ? name : plural, comment: "")
        var output: String = format
        output = output.replacingOccurrences(of: "%i", with: String(componentValue))
        output = output.replacingOccurrences(of: "%u", with: timespan)
        output = output.replacingOccurrences(of: "%c", with: "ago")
        return output
    }
}

extension DateFormatter {
    static let iso8601 = OptionalFractionalSecondsDateFormatter()
}
