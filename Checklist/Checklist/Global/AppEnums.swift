import UIKit
import Foundation

enum BookingStatus: String {
    case Assigned =  "assigned"
    case Arrived = "arrived"
    case Completed = "completed"
    case Rejected = "reject"
    case POB = "pob"
}


enum BookingType: String {
    case Return =  "return"
    case Departure = "departure"
}
