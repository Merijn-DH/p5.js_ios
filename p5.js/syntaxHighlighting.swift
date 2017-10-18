
import UIKit

struct colors {
    // color scheme
    static let scheme = [UIColor(red:242/255,green:197/255,blue:145/255,alpha:1),
                         UIColor(red:144/255,green:190/255,blue:250/255,alpha:1),
                         UIColor(red:138/255,green:194/255,blue:200/255,alpha:1),
                         UIColor(red:235/255,green:155/255,blue:242/255,alpha:1),
                         UIColor(red:245/255,green:137/255,blue:141/255,alpha:1)];
    
    // standard p5 functions and variables
    static let js = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "frameCount", "focused", "width", "height", "displayWidth", "displayHeight", "windowWidth", "windowHeight", "mouseX", "mouseY", "pmouseX", "pmouseY", "pixels"],
                     ["background", "clear", "colorMode", "fill", "noFill", "noStroke", "stroke", "alpha", "blue", "brightness", "color", "green", "hue", "lerpColor","lightness","red","saturation","arc","ellipse","line","point","quad","rect","triangle","ellipseMode","noSmooth","rectMode","smooth","strokeCap","strokeJoin","strokeWeight","bezier","bezierPoint","bezierTangent","curve","curveTightness","curvePoint","curveTangent","beginContour","beginShape","bezierVertex","curveVertex","endContour","endShape","quadraticVertex","vertex","loadModel","model","plane","box","sphere","cylinder","cone","ellipsoid","torus","preload","setup","draw","remove","noLoop","loop","push","pop","redraw","print","cursor","frameRate","noCursor","windowResized","fullscreen","pixelDensity","displayDensity","getURL","getURLPath","getURLParams","createCanvas","resizeCanvas","noCanvas","createGraphics","blendMode","applyMatrix","resetMatrix","rotate","rotateX","rotateY","rotateZ","scale","shearX","shearY","translate","append","arrayCopy","concat","reverse","shorten","shuffle","sort","splice","subset","float","int","str","boolean","byte","char","unchar","hex","unhex","join","match","matchAll","nf","nfc","nfp","nfs","split","splitTokens","trim","setMoveThreshold","setShakeThreshold","deviceMoved","deviceTurned","deviceShaken","keyPressed","keyReleased","keyTyped","keyIsDown","mouseMoved","mouseDragged","mousePressed","mouseReleased","mouseClicked","doubleClicked","mouseWheel","touchStarted","touchMoved","touchEnded","createImage","saveCanvas","saveFrames","loadImage","image","tint","noTint","imageMode","blend","copy","filter","get","loadPixels","set","updatePixels","loadJSON","loadStrings","loadTable","loadXML","httpGet","httpPost","httpDo","save","saveJSON","saveStrings","saveTable","day","hour","minute","millis","month","second","year","createVector","abs","ceil","constrain","dist","exp","floor","lerp","log","mag","map","max","min","norm","pow","round","sq","sqrt","noise","noiseDetail","noiseSeed","randomSeed","random","randomGaussian","asin","atan","atan2","cos","sin","tan","degrees","radians","angleMode","textAlign","textLeading","textSize","textStyle","textWidth","textAscent","textDescent","loadFont","text","textFont","camera","perspective","ortho","ambientLight","directionalLight","pointLight","loadShader","shader","normalMaterial","texture","ambientMaterial","specularMaterial", "constructor"],
                     ["+","-","*","/","=","<",">","PI","HALF_PI","QUARTER_PI","TAU","TWO_PI"],
                     ["function","class", "let", "var","new","for","while","if","foreach","do","return"],
                     ["this"]];
    // a few standard html syntax. this should be replaced by regular expressions for <tags>
    static let html = [[],[],["src","value","type","color","backgroundColor"],[],["style", "html","head","body","script","meta","input","textarea","form","button", "h1","br","h2","h3"]];
    
    // if any of the above syntax is next to any of these characters, it should not be colored. this could probably be replaced by some kind of build-in alphanumerical checker.
    static let variable = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0","-","_", "A", "B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
}

extension UIViewController {
    
    // syntax highlighting of main textField. line is the lineNumber of a potential error, if no error line=-1.
    // Normally only the editing line is re-highlighted. Reset=true re-does the entire text field.
    func syntaxHighlighting(codeField: UITextView, mode: String, line:Int, reset:Bool) {
        
        let nsstring = codeField.text! as NSString
        let linerange = nsstring.lineRange(for: codeField.cursorRange!)
        
        var checkingString = (codeField.text(in: linerange.toTextRange(textInput: codeField)!)!)
        var addRange = linerange.location
        
        if (reset) {
            checkingString = codeField.text
            addRange = 0
        }
        
        let attribute2 = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!]
        let range2 = NSMakeRange(addRange,checkingString.characters.count)
        codeField.textStorage.setAttributes(attribute2, range: range2)
        
        var findString = checkingString
        
        if (mode == "js") {
            for i in 0 ..< colors.js.count {
                let types = colors.js[i]
                for j in 0 ..< types.count {
                    let typie = types[j]
                    let attribute = [NSForegroundColorAttributeName: colors.scheme[i], NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!]
                    let indices = checkingString.indicesOf(string: typie)
                    for indice in indices {
                        let range = NSMakeRange(indice+addRange,typie.characters.count)
                        codeField.textStorage.setAttributes(attribute, range: range)
                    }
                }
            }
            
            while let match = findString.range(of: "[ \t\n.]([\\w-]*?)[(]", options: .regularExpression) {
                let substring = (findString.substring(with: match))
                var range = (findString as NSString).range(of: substring)
                findString = findString.removeTo(range.length+range.location)
                range.location += 1+addRange
                range.length -= 2
                let attribute3 = [NSForegroundColorAttributeName: UIColor(red:154/255,green:200/255,blue:255/255,alpha:1), NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!]
                codeField.textStorage.setAttributes(attribute3, range: range)
            }
            
            findString = checkingString
            while let match = findString.range(of: "\\/\\/(.*)", options: .regularExpression) {
                let substring = (findString.substring(with: match))
                var range = (findString as NSString).range(of: substring)
                findString = findString.removeTo(range.length+range.location)
                range.location += addRange
                let attribute3 = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!]
                codeField.textStorage.setAttributes(attribute3, range: range)
            }
            
            findString = checkingString
            while let match = findString.range(of: "class (.*?) {", options: .regularExpression) {
                let substring = (findString.substring(with: match))
                var range = (findString as NSString).range(of: substring)
                findString = findString.removeTo(range.length+range.location)
                range.location += addRange
                let attribute3 = [NSForegroundColorAttributeName: colors.scheme[1], NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!]
                codeField.textStorage.setAttributes(attribute3, range: range)
            }
            
        } else {
            for i in 0 ..< colors.html.count {
                let types = colors.html[i]
                for type in types {
                    let attribute = [NSForegroundColorAttributeName: colors.scheme[i], NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!]
                    let indices = codeField.text.indicesOf(string: type)
                    for indice in indices {
                        let range = NSMakeRange(indice,type.characters.count)
                        codeField.textStorage.setAttributes(attribute, range: range)
                    }
                }
            }
        }
        
        findString = checkingString
        while let match = findString.range(of: "\"((.|\n)*?)\"", options: .regularExpression) {
            let substring = (findString.substring(with: match))
            var range = (findString as NSString).range(of: substring)
            findString = findString.removeTo(range.length+range.location)
            range.location += 1+addRange
            range.length -= 2
            let attribute3 = [NSForegroundColorAttributeName: colors.scheme[0], NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!]
            codeField.textStorage.setAttributes(attribute3, range: range)
        }
        
        findString = checkingString
        while let match = findString.range(of: "'((.|\n)*?)'", options: .regularExpression) {
            let substring = (findString.substring(with: match))
            var range = (findString as NSString).range(of: substring)
            findString = findString.removeTo(range.length+range.location)
            range.location += 1+addRange
            range.length -= 2
            let attribute3 = [NSForegroundColorAttributeName: colors.scheme[0], NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!]
            codeField.textStorage.setAttributes(attribute3, range: range)
        }
        
        if (line > 0) {
            let lines = codeField.text.indicesOf(string: "\n")
            var newline = line;
            if (newline > lines.count) {
                newline = lines.count-1;
            }
            var range = NSMakeRange(lines[newline-1], 1)
            let nsstring = codeField.text! as NSString
            let linerange = nsstring.lineRange(for: range)
            range.location += addRange
            let attribute3 = [NSBackgroundColorAttributeName: UIColor.red, NSFontAttributeName: UIFont(name: "Courier", size: 17.0)!]
            codeField.textStorage.setAttributes(attribute3, range: linerange)
        }
    }
}
