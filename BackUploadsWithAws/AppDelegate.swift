//
//  AppDelegate.swift
//  BackUploadsWithAws
//
//  Created by ezen on 12/09/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		S3Keys.shared.fetchKeysAndInitialize()

		ChatFolderApi.initialize()
		
		UploadService.initialize()
		UploadService.shared.startOnLaunch()

		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		//
	}
}

