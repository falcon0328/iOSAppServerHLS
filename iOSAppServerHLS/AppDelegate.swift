//
//  AppDelegate.swift
//  iOSAppServerHLS
//
//  Created by aseo on 2020/05/24.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import GCDWebServers

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var webServer: GCDWebServer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        webServer = GCDWebServer()
        /**
         * [GCDWebServer](https://github.com/swisspol/GCDWebServer)
         * [HLSの用意 ~ MIMETypeの話の参考](https://www.yaz.co.jp/tec-blog/web%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9/212)
         */
        let m3u8Path = Bundle.main.path(forResource: "prog_index", ofType: "m3u8", inDirectory: "HLSDatas")!
        for filePath in Bundle.main.paths(forResourcesOfType: "ts", inDirectory: "HLSDatas") {
            // アクセスするファイル名が取得できるかを確認する
            guard let fileName = filePath.components(separatedBy: "/").last else { continue }
            webServer?.addGETHandler(
                forPath: "/\(fileName)",
                filePath: filePath,
                isAttachment: true,
                cacheAge: 3600,
                allowRangeRequests: true
            )
            webServer?.addHandler(forMethod: "GET",
                                  path: "/\(fileName)",
                                  request: GCDWebServerRequest.self,
                                  processBlock: { (request) -> GCDWebServerResponse? in
                                    let tsData = try! Data(contentsOf: URL(fileURLWithPath: filePath))
                                    return GCDWebServerDataResponse(data: tsData,
                                                                    contentType: "video/mp2t")
            })
        }
        // M3U8ファイルをWebサーバに追加する
        webServer?.addHandler(forMethod: "GET",
                              path: "/prog_index.m3u8",
                              request: GCDWebServerRequest.self,
                              processBlock: { (request) -> GCDWebServerResponse? in
                                let m3u8Data = try! Data(contentsOf: URL(fileURLWithPath: m3u8Path))
                                return GCDWebServerDataResponse(data: m3u8Data,
                                                                contentType: "application/vnd.apple.mpegurl")
        })
        webServer?.start(withPort: 8080, bonjourName: "GCD Web Server")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

