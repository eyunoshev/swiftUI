//
//  ContentView.swift
//  3cardSwiftUI
//
//  Created by dunice on 21.10.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var mvvmTest = MVVMtest()
    
    var body: some View{
        ToDoView()
            .environmentObject(mvvmTest)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
