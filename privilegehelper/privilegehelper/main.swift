//
//  main.swift
//  com.privilege.helper
//
//  Created by Nikhil on 3/16/20.
//  Copyright © 2020 Nikhil. All rights reserved.
//

import Foundation

let daemon = PrivilegeListener.init()
do {
    try daemon.startService()
    RunLoop.current.run()
    NSLog("I didnt stop at resume")
} catch {
    NSLog("Error in starting service : %@ ", String(describing: error))
}
