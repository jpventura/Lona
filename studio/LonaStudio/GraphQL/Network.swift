//
//  Network.swift
//  LonaStudio
//
//  Created by Mathieu Dutour on 12/02/2020.
//  Copyright © 2020 Devin Abbott. All rights reserved.
//

import Foundation
import Apollo

let API_BASE_URL = Bundle.main.infoDictionary?["API_BASE_URL"] as! String

class Network {
    static let shared = Network()

    private(set) lazy var lona: ApolloClient = {
        let httpNetworkTransport = HTTPNetworkTransport(
            url: URL(string:"\(API_BASE_URL)/graphql")!,
            delegate: self
        )

        httpNetworkTransport.clientName = "Lona API Transport"

        return ApolloClient(networkTransport: httpNetworkTransport)
    }()

    private(set) lazy var github: ApolloClient = {
        let httpNetworkTransport = HTTPNetworkTransport(
            url: URL(string:"https://api.github.com/graphql")!,
            delegate: self
        )

        httpNetworkTransport.clientName = "GitHub API Transport"

        return ApolloClient(networkTransport: httpNetworkTransport)
    }()
}

extension Network: HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        return true
    }

    func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
        if networkTransport.clientName == "Lona API Transport" {
            if let token = Account.shared.token {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }

        if networkTransport.clientName == "GitHub API Transport" {
            // We need this to get the check suites
            request.addValue("application/vnd.github.antiope-preview+json", forHTTPHeaderField: "Accept")

            let group = DispatchGroup()
            group.enter()

            Account.shared.me().finalResult({ _ in
                group.leave()
            })

            // wait for the Lona account to be fetched
            group.wait()

            if let githubToken = Account.shared.cachedMe?.githubAccessToken {
                request.addValue("Bearer \(githubToken)", forHTTPHeaderField: "Authorization")
            }
        }
    }
}
