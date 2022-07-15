/// Enum representing the possible Order statuses. If providing to an api use the name value (e.g.
/// OrderStatus.active.rawValue)
enum OrderStatus: String {
    case active
    case filled
    case cancelled
    case expired
    case inactive
}
