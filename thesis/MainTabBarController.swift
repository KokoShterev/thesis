//
//  MainTabBarController.swift
//  thesis
//
//  Created by Constantine Shterev on 18.02.24.
//

//import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let homeVC = HomeViewController()
//        let profileVC = ProfileViewController()
//
//        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
//        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
//
//        let viewControllerList = [homeVC, profileVC]
//        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let homeVC = HomeViewController()
//        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
//
//        let profileVC = ProfileViewController()
//        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
//
//        let controllers = [homeVC, profileVC]
//        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
//    }
    struct TabBarView: View {
        var body: some View {
            TabView {
                NavigationView {
                    HomeView()
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                NavigationView {
                    ProfileView()
                }
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            }
        }
    }
}

