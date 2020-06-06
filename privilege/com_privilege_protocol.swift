//
//  com_privilege_protocol.swift
//  com.privilege.helper
//
//  Created by Nikhil on 3/15/20.
//  Copyright © 2020 Nikhil. All rights reserved.
//

import Foundation

@objc protocol ListenerProtocol {
    func changePrivilege(for user: String,toAdmin: Bool, withReply reply: @escaping (String) -> Void)
    func upperCaseString(_ string: String, withReply reply: @escaping (String) -> Void)
    
}

