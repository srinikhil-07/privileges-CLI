# PrivilegesCLI
A CLI tool to switch admin privileges for macOS. This is inspired from SAP's Privileges app. 

## About
This repository aims to build a CLI only tool to switch/toggle admin privileges.

## Goals
This repository's goals are as follows:
1. CLI tool should run in user context,
2. Privilege operations should happen via XPC Mach service daemon,
3. The code should be fully in Swift,
4. Use Apple's new Argument Parser library,

## Design
Proposed design:
1. Build a package with user CLI and XPC daemon,
2. Installing the package will start the deamon and install the CLI tool,
3. When the CLI is invoked, CLI asks XPC to do appropriate privilege change to the currently 
logged in user,
4. Uninstallation can also be done in user privilege if possible and make XPC to shut down 
itself

## Current Status
- [x] The working XPC daemon service and a sample client invoking it code is ready,

## TODO
- [x] Add Apple's collaboration framework to XPC daemon and check if its daemon safe,
- [ ] In client, add Apple's argument parser Swift package to parse CLI arguments,
- [x] Test the functionality
- [ ] Package it in PKG format
- [ ] Add security to XPC daemon

## Usage
Build both XPC helper and privileges CLI tool. 
1. Copy the com.privilge.helper XCP to /Library/PrivilegeHelper directory,
2. Load the XPC daemon plist,
3. Edit your user name in privileges CLI and its required privilege before runnig it. The user privilege should change accordingly.

## Future Scope
- [ ] This tool can be extended to other privlege operations while staying as user,
- [ ] Some way to restrict only a set of users with some form of authorization (lise password etc.) to 
be able to use this tool. This will be helpful when this tool is deployed in a managed environment.

Contributions are welcome.
