//
//  Created by dora on 2024/2/1.
//

import SwiftUI
// The following library connects plugins with iOS platform code to this app.
import Flutter
import FlutterPluginRegistrant


@main
struct twm_testApp: App {
    @StateObject var kgSDKService = KgSDKService.shared

    var body: some Scene {
            WindowGroup {
                ContentView().environmentObject(kgSDKService)
            }
        }
}
