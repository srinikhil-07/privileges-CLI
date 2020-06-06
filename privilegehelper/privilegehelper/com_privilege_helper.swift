//
//  
//  com.privilege.helper
//
//  Created by Nikhil on 3/15/20.
//  Copyright © 2020 Nikhil. All rights reserved.
//
// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
import Foundation
import XPC
import Collaboration
import SystemConfiguration
import Logging
/// Class conforming to XPC listener delgate.
///
/// This class starts the service, listens to the requests and handles them
/// - ToDo: 1. Handle security aspect for the requests,
///
class PrivilegeListener: NSObject, NSXPCListenerDelegate, ListenerProtocol {
    var privilegeListener = NSXPCListener()
    var serviceStarted = false
    var toggleDictionary = [String: Int]()
    var userId = CBIdentity()
    var adminGroupId = CBGroupIdentity()
    let logger = Logger(label: "com.privilege.helper",factory: StreamLogHandler.standardError)
    /// Initialize the listener
    override init() {
        logger.info("Initializing the daemon service")
        privilegeListener = NSXPCListener.init(machServiceName: "com.privilege.helper")
        super.init()
        privilegeListener.delegate = self
        serviceStarted = false
    }
    /// Resume the listener
    func startService() throws {
        guard serviceStarted == false else {
            logger.error("Service start failed")
            throw ListenerError.serviceAlreadyResumed
        }
        logger.info("Resuming the service")
        serviceStarted = true
        privilegeListener.resume()
    }
    /// Suspend the listener
    func stopService() throws {
        guard serviceStarted == true else {
            logger.error("Service stop failed")
            throw ListenerError.serviceAlreadySuspended
        }
        serviceStarted = false
        privilegeListener.suspend()
    }
    /// XPC method to change privilege of the user
    ///
    /// This method checks if the given user doesnt have the requested privilege already.
    /// If not the prvivilege change is handledc else remains quiet
    ///
    /// - Parameters:
    ///     - user: user name string
    ///     - toAdmin: admin/user privilege request
    ///
    func changePrivilege(for user: String,toAdmin: Bool, withReply reply: @escaping (String) -> Void) {
        if let userId = CBIdentity.init(name: user, authority: .default()) {
            self.userId = userId
            if let adminGroupId = CBGroupIdentity.init(posixGID: 80, authority: .local()) {
                self.adminGroupId = adminGroupId
                if toAdmin && userId.isMember(ofGroup: adminGroupId) {
                    logger.error("User already admin")
                    reply("User already admin")
                } else if !toAdmin && !userId.isMember(ofGroup: adminGroupId) {
                    logger.error("User already not admin")
                     reply("User already not admin")
                } else {
                    logger.info("Privilege change needed")
                    do {
                        try self.changePrivilegeHelper(to: toAdmin, for: user)
                        reply("Privilege change successful")
                    } catch {
                        logger.error("Error in privilege change: \(error)")
                        reply("Error in privilege change")
                    }
                }
            } else {
                logger.error("Error in creating group identity")
            }
        }
    }
    /// Test method for XPC
    func upperCaseString(_ string: String, withReply reply: @escaping (String) -> Void) {
        logger.info("Request received for upper casing - test logger")
        let response = string.uppercased()
        reply(response)
    }
    /// Method to listen to XPC requests
    /// - Warning: Requests should be checked for code sign here before processing
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        logger.info("Request to listner recieved")
        newConnection.exportedInterface = NSXPCInterface.init(with: ListenerProtocol.self)
        newConnection.exportedObject = self
        newConnection.resume()
        return true
   }
}
/// Extending the listener
extension PrivilegeListener {
    enum ListenerError : Error {
        case serviceAlreadyResumed
        case serviceAlreadySuspended
        case consoleUserQueryError
        case privilegeChangeError
    }
}
/// Extending for helper methods
extension PrivilegeListener {
    /// Method to check group membership of a user
    func checkMembershipInAdminUser(for user: String) {
        if let userId = CBIdentity.init(name: user, authority: .default()) {
        if let adminGroupId = CBGroupIdentity.init(posixGID: 80, authority: .local()) {
            logger.info("Is user \(user) member of admin? \(userId.isMember(ofGroup: adminGroupId))")
            }
        }
    }
    /// Get current console user
    /// https://stackoverflow.com/questions/24591760/swift-how-to-get-console-user-uid-and-gid-via-scdynamicstorecopyconsoleuser
    func consoleUser() throws -> String{
        var uid: uid_t = 0
        var gid: gid_t = 0
        if let theResult = SCDynamicStoreCopyConsoleUser(nil, &uid, &gid) {
            let name = theResult
            logger.info("User name: \(name)")
            return name as String
        }
        logger.error("Error in getting console user")
        throw ListenerError.consoleUserQueryError
    }
    /// Method to change privilege for a user
    func changePrivilegeHelper(to admin: Bool, for user: String) throws {
        let obj = Bridger.init()
        if let csUserId = obj.getUserCSIdentity(for: userId) {
            if let csGroupId = obj.getGroupCSIdentity(for: adminGroupId) {
                let csUserIdRetained = csUserId.takeUnretainedValue()
                let csGroupIdRetained = csGroupId.takeUnretainedValue()
                if admin {
                   logger.info("Setting admin rights to the user")
                    CSIdentityAddMember(csGroupIdRetained,csUserIdRetained)
                } else {
                    logger.info("Stripping admin rights to the user")
                    CSIdentityRemoveMember(csGroupIdRetained, csUserIdRetained )
                }
                if let csGroupId2 = obj.getGroupCSIdentity(for: adminGroupId) {
                    let csGroupIdRetained2 = csGroupId2.takeUnretainedValue()
                    logger.info("Committing the changes")
                    let status = CSIdentityCommit(csGroupIdRetained2, nil, nil)
                    if status {
                        checkMembershipInAdminUser(for: user)
                        return
                    }
                }
            }
        }
        throw ListenerError.privilegeChangeError
    }
}
