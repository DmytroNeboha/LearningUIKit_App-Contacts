
import UIKit



protocol ContactProtocol {
    // name
    var title: String { get set }
    // phone number
    var phone: String { get set }
}


struct Contact: ContactProtocol {
    var title: String
    var phone: String
}




