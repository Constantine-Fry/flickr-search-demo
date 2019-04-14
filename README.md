#  UberTest Description

## UI

// app screenshots

## Architecture

This UberTest application is written in Swift and runs on iOS and macOS. It utilizes Clean Architecture by Uncle Bob which is known in iOS community as VIPER. Nearly 60% of code is reused between iOS and macOS. To to rease code between platforms the app is split into the following targets: 
    - BusinessLogicKit.framework - it contains Viewing protocols, Presenter, Interactor and Repositoring protocols.
    - FlickrKit.framework - it implements Repositoring protocols and incapsulates networking layer.
    - UberTest-iOS.app and UberTest-macOS.app - targets implements Viewing protocols and performs dependency injection.
  
  // framework architecture
  // VIPER stack
  
## Tests

Since BusinessLogicKit.framework doesn't have any UIKit dependency, tests for this framework are runned on macOS. In future, when project grows in size it give a significant boost in testing time, because there is no need to compile third party components, UI related code and launch simulator in order to run tests on Business Logic.
