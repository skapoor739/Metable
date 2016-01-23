import UIKit

let names = ["a","b","c","d","e","f"]
let named = "a"

func iterateNames() -> Bool {
    var isSame:Bool?
    for name in names {
        if name == named {
            isSame = true
        }   else {
            isSame = false
        }
    }
    return isSame!
}

iterateNames()