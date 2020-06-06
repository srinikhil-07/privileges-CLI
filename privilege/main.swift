//
//  main.swift
//  privilege
//
//  Created by Nikhil on 3/14/20.
//  Copyright © 2020 Nikhil. All rights reserved.
//

import Foundation
import ArgumentParser
import Logging

let logger = Logger(label: "privilege")
struct Privilege: ParsableCommand {
    @Option(name: .shortAndLong, default: "Test", help: "The user whose privlige needs change")
    var user: String
    @Option(name: .shortAndLong, default: true, help: "Needs admin privilege")
    var admin: Bool
    func run() throws {
        let connection = NSXPCConnection(machServiceName: "com.privilege.helper", options: .privileged)
        connection.remoteObjectInterface = NSXPCInterface(with: ListenerProtocol.self)
        connection.resume()
        let service = connection.remoteObjectProxyWithErrorHandler { error in
            logger.error("\(error)")
        } as? ListenerProtocol
        service?.changePrivilege(for: user, toAdmin: admin) { reply in
            logger.info("\(reply)")
        }
        //test
        service?.upperCaseString("hello XPC") { response in
            print("Response from XPC service:", response)
        }
    }
}
Privilege.main()
