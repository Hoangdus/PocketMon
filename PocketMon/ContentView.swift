//
//  ContentView.swift
//  PocketMon
//
//  Created by HoangDus on 31/08/2024.
//

import SwiftUI
 
public let appPrimaryColor: Color = Color("primaryColor1")
public let appAccentColor: Color = Color("accentColor")
public let tabBarColor: Color = Color("primaryColor2")

struct ContentView: View {	
    let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
    init() {
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(tabBarColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        TabView{
            PokemonSearchView()
                .tabItem{
                    Label("Search", systemImage: "magnifyingglass.circle.fill")
                }
//                .toolbarBackground(tabBarColor, for: .tabBar)
            FavPokemonListVIew()
                .tabItem{
                    Label("Favorite", systemImage: "heart.fill")
                }
//                .toolbarBackground(tabBarColor, for: .tabBar)
        }
        .accentColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
