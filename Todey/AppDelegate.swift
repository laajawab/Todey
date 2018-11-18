//
//  AppDelegate.swift
//  Todey
//
//  Created by Avilash on 04/10/18.
//  Copyright © 2018 Avilash. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
       // print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
        
        do {
            _ = try Realm()
        }
        catch {
            print("Error Intionalising New Realm, \(error)")
        }
        
        return true
    }

}

