//
//  TestViewController.swift
//  diplomna
//
//  Created by Constantine Shterev on 23.03.24.
//

import SwiftUI
import UIKit

struct HomeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HomeViewController {
        return HomeViewController()
    }

    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
        // Update HomeViewController if needed based on SwiftUI state changes
    }
}

struct ProfileView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ProfileViewController {
        return ProfileViewController()
    }

    func updateUIViewController(_ uiViewController: ProfileViewController, context: Context) {
        // Update ProfileViewController if needed based on SwiftUI state changes
    }
}

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
