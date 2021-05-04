//
//  AppDelegate.swift
//  TestLBC
//
//  Created by Nicolas Ta on 02/05/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


	var window:UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

		self.window = UIWindow(frame: UIScreen.main.bounds)
		let navController = UINavigationController()
		let controller = AdsViewController()
		navController.viewControllers = [controller]
		window?.tintColor = .orange

		window?.rootViewController = navController

		window?.makeKeyAndVisible()

		return true
	}
}

