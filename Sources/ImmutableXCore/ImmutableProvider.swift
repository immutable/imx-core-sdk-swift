//
//  File.swift
//  
//
//  Created by Cassius Pacheco on 10/2/2023.
//

import Foundation

public struct JWT {
    public let token: String

    func getAddress() throws -> String {
        return "TODO: Implement this"
    }
}

public protocol Signers {
    var starkSigner: StarkSigner { get }
    var ethSigner: Signer? { get }

    func jwt() async throws -> JWT?
}

public struct WalletConnection {
    public let providerName: String
    public let providerIcon: String // Data URL of the image
    public let signers: Signers

    public init(providerName: String, providerIcon: String, signers: Signers) {
        self.providerName = providerName
        self.providerIcon = providerIcon
        self.signers = signers
    }
}

public struct ConnectParams {
    let rpc: Any?
    let chainID: Any?

    public init(rpc: Any? = nil, chainID: Any? = nil) {
        self.rpc = rpc
        self.chainID = chainID
    }
}

public protocol ImmutableProvider {
    var providerName: String { get }
    var providerIcon: String { get } // Data URL of the image

    func connect(params: ConnectParams) async throws -> WalletConnection
}
