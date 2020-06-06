//
//  xpcconnector.swift
//  privilege
//
//  Created by Nikhil on 3/14/20.
//  Copyright © 2020 Nikhil. All rights reserved.
//

import Foundation
import XPC
///// XPC protocol to conform to
//@objc protocol ListenerProtocol {
//    func changePrivilege(toAdmin: Bool)
//}
///// Class to request privilege operation
//class PrivilegeRequest: NSObject {
//    var request = NSXPCConnection.init(machServiceName: "", options: .privileged)
//    func serviceRequest() -> NSXPCConnection {
//        if let privilegeRequest = request {
//             return privilegeRequest
//        } else {
//            if request = NSXPCConnection.init(machServiceName: "", options: .privileged) {
//            request?.remoteObjectInterface = NSXPCInterface.init(with: ListenerProtocol.self)
//            request?.resume()
//            return request
//            }
//        }
//    }
//}
