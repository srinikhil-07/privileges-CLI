# PrivilegesCLI
A CLI tool to switch admin privileges for macOS. This is inspired from SAP's Privileges app https://github.com/SAP/macOS-enterprise-privileges. 

## About
This repository contains a CLI only tool to switch/toggle admin privileges.

## Goals
This repository's goals are as follows:
1. CLI tool should run in user context,
2. Privilege operations should happen via XPC Mach service daemon,
3. The code should be fully in Swift,
4. Use Apple's new Argument Parser library,
5. Use Apple's swift-log for logging
6. XPC in high privilege should be secure. Audit token check from https://github.com/securing/SimpleXPCApp 
has been implemented.

## TODO
- [x] Add Apple's collaboration framework to XPC daemon and check if its daemon safe,
- [x] In client, add Apple's argument parser Swift package to parse CLI arguments,
- [x] Test the functionality
- [x] Automated build, install and uninstall 
- [x] Add security to XPC daemon
- [ ] Toggle for 'n' minutes like in SAP's app.

## Usage
Build both XPC helper and privileges CLI tool. 
1. To build the tool: ./build.sh build
2. To install the tool: sudo ./build.sh install
3. Fot help after installing : privilege --help
4. To remove admin privilege for an user: privilege --user Test --admin false
5. To get admin rights for an user: privilege --user Test --admin true
6. Security check for XPC in file ConnectionVerifier.swift can be replaced with relevant information.

## Future Scope
- [ ] This tool can be extended to other privlege operations while staying as user,
- [ ] Some way to restrict only a set of users with some form of authorization (like password etc.) to 
be able to use this tool. This will be helpful when this tool is deployed in a managed environment.

Contributions are welcome.
