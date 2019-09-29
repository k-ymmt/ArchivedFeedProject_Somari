//
//  ContentView.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/25.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Text("foo").background(Color.green)
                    .listRowBackground(Color.blue)
                }.listStyle(GroupedListStyle())
            .navigationBarTitle("hoge")
        }.background(Color.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
