
import UIKit

extension UIViewController {
    func isIphone() -> Bool {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return true
        case .pad:
            return false
        default:
            return true
        }
    }
}

extension String {
    func indicesOf(string: String) -> [Int] {
        let searchString = " " + self + " ";
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            if (colors.variable.contains(string) || string == "\n") {
                indices.append(index)
            } else {
                if (!colors.variable.contains(searchString.atIndex(index)) && !colors.variable.contains(searchString.atIndex(index+string.characters.count+1))) {
                    indices.append(index)
                }
            }
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
    
    func atIndex(_ index:Int) -> String {
        let start = self.index(startIndex, offsetBy: index)
        let end = self.index(startIndex, offsetBy: index+1)
        return substring(with: start..<end)
    }
    
    func removeTo(_ index:Int) -> String {
        let start = self.index(startIndex, offsetBy: index)
        let end = endIndex
        var returnString = substring(with: start..<end);
        for _ in 0 ..< index {
            returnString = " " + returnString;
        }
        return returnString
    }
    
}

extension UITextView {
    var cursorRange: NSRange? {
        guard let range = self.selectedTextRange else { return NSRange(location:0,length:0) }
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }
}

extension NSRange {
    func toTextRange(textInput:UITextView) -> UITextRange? {
        if let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: location),
            let rangeEnd = textInput.position(from: rangeStart, offset: length) {
            return textInput.textRange(from: rangeStart, to: rangeEnd)
        }
        return nil
    }
}
