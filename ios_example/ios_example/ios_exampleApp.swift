//
//  twm_testApp.swift
//  twm_test
//
//  Created by dora on 2024/2/1.
//

import SwiftUI
// The following library connects plugins with iOS platform code to this app.
import Flutter
import FlutterPluginRegistrant


class FlutterDependencies: ObservableObject {
    let flutterEngine = FlutterEngine(name: "flutter_engine")
    init(){
        // Runs the default Dart entrypoint with a default Flutter route.
        flutterEngine.run()
        // Connects plugins with iOS platform code to this app.
        GeneratedPluginRegistrant.register(with: self.flutterEngine);
    }
}

@main
struct twm_testApp: App {
    @StateObject var flutterDependencies = FlutterDependencies()
    var body: some Scene {
        WindowGroup {
            ContentView(flutterDependencies: flutterDependencies)
        }
    }
}
