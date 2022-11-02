//
//  SecondContentView.swift
//  3cardSwiftUI
//
//  Created by dunice on 24.10.2022.
//

import SwiftUI

struct SecondContentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var mvvmTest: MVVMtest
    @State var newToDo: String = ""
    @State var newToDoFieldIsFocused: Bool = false
    @State var activeToDo: Bool = false
    
    var body: some View {
        VStack{
            
            HStack{
                TextField("Введите новую задачу",
                          text: $newToDo
                )
                .disableAutocorrection(true)
                .padding()
//                Toggle(isOn: $activeToDo, label: {
//                    Text("Выберите состояние задачи")
//                })
//                .padding()
                
            }
            
            Button(action: {
                mvvmTest.addToDo(stringToDoFromText: newToDo,isActiveToDoFromNew: activeToDo)
                mvvmTest.updateCount()
            }, label: {
                Text("Добавить задачу")
            })
        }
        .navigationBarBackButtonHidden(false)
//        .navigationBarItems(leading: Button {
//            presentationMode.wrappedValue.dismiss()
//        } label: {
//            Text("Back ToDo")
//        })
        
        
    }
}

struct SecondContentView_Previews: PreviewProvider {
    static var previews: some View {
        SecondContentView()
    }
}
