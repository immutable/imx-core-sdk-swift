//
// Balance.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct Balance: Codable, JSONEncodable, Hashable {

    /** Amount which is currently inside the exchange */
    public private(set) var balance: String
    /** Amount which is currently preparing withdrawal from the exchange */
    public private(set) var preparingWithdrawal: String
    /** Symbol of the token (e.g. ETH, IMX) */
    public private(set) var symbol: String
    /** Amount which is currently withdrawable from the exchange */
    public private(set) var withdrawable: String

    public init(balance: String, preparingWithdrawal: String, symbol: String, withdrawable: String) {
        self.balance = balance
        self.preparingWithdrawal = preparingWithdrawal
        self.symbol = symbol
        self.withdrawable = withdrawable
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case balance
        case preparingWithdrawal = "preparing_withdrawal"
        case symbol
        case withdrawable
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(balance, forKey: .balance)
        try container.encode(preparingWithdrawal, forKey: .preparingWithdrawal)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(withdrawable, forKey: .withdrawable)
    }
}
