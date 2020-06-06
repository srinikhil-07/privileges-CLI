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
5. Use Apple's swift-log for logging

## TODO
- [x] Add Apple's collaboration framework to XPC daemon and check if its daemon safe,
- [x] In client, add Apple's argument parser Swift package to parse CLI arguments,
- [x] Test the functionality
- [x] Automated build, install and uninstall 
- [ ] Add security to XPC daemon
- [ ] Toogle for n minutes like in SAP's app.

## Usage
Build both XPC helper and privileges CLI tool. 
1. Build byrunnning ./build.sh build
2. Install the tool by sudo ./build.sh install
3. To get tool help and usage information : privilege --help
4. To remove admin privilege for an user: privilege --user Test --admin false
5. To get admin rights for an user: privilege --user Test --admin true

## Deployment 

1. Add your sign in build.sh
2. The CLI, XPC and build.sh can be zipped and "sudo ./buid.sh install" can be used to deploy,
3. To remove this tool "sudo ./build.sh uninstall" can be deployed on users

## Future Scope
- [ ] This tool can be extended to other privlege operations while staying as user,
- [ ] Some way to restrict only a set of users with some form of authorization (like password etc.) to 
be able to use this tool. This will be helpful when this tool is deployed in a managed environment.

Contributions are welcome.
