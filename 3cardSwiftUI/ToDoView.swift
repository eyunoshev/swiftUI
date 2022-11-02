//
//  ToDoView.swift
//  3cardSwiftUI
//
//  Created by dunice on 25.10.2022.
//

import SwiftUI

struct ToDoView: View {
    
    @EnvironmentObject var mvvmTest: MVVMtest
    @State var segmentIndex: Int = 0
    //    @State var eachToDo: toDo
    
    var conditionsToDo = ["All", "Only completed", "Only non-completed"]
    
    
    var body: some View {
        NavigationView {
            VStack{
                
                Button(action: {
                    mvvmTest.deleteAllComplited()
                }, label: {
                    Text("Delete all completed")
                })
                
                HStack{
                    Text("\(mvvmTest.countCompleted) completed")
                        .padding()
                    Text("\(mvvmTest.countNonCompleted) non-completed")
                        .padding()
                }
                
                HStack{
                    Button(action: {
                        mvvmTest.makeAllActive()
                    }, label: {
                        Text("Set all completed")
                    })
                    .padding()
                    
                    Button(action: {
                        mvvmTest.makeAllNonActive()
                    }, label: {
                        Text("Set all non-completed")
                    })
                    .padding()
                }
                .padding()
                
                
                Picker(selection: $segmentIndex, label: Text(""), content: {
                    ForEach(0..<conditionsToDo.count){
                        Text(self.conditionsToDo[$0]).tag($0)
                    }
                })
                .pickerStyle(SegmentedPickerStyle()).padding()
                
                switch segmentIndex{
                case 0:
                    List {
                        ForEach(mvvmTest.massiveToDo){ Content in
                            ListRow(eachToDo: Content)}
                    }
                    
                case 1:
                    List(mvvmTest.massiveToDo.filter { $0.status}){
                        Content in ListRow(eachToDo: Content)
                    }
                    
                    
                case 2:
                    List(mvvmTest.massiveToDo.filter { !$0.status}){
                        Content in ListRow(eachToDo: Content)
                    }
                    
                default:
                    List(mvvmTest.massiveToDo){
                        Content in ListRow(eachToDo: Content)
                    }
                }
            }
            .navigationBarItems(trailing:
                                    NavigationLink(
                                        destination: SecondContentView(),
                                        label: {
                                            Text("Add ToDo")
                                        }))
        }
        .onAppear{
            mvvmTest.getDataToDo()
            mvvmTest.updateCount()
        }
    }
}




struct ListRow: View{
    @EnvironmentObject var mvvmTest: MVVMtest
    @State var isPresentedAlert = false
    var eachToDo: Content
    
    var body: some View {
        
        HStack {
            HStack(spacing:10){
                Text (eachToDo.text)
                    .onTapGesture {
                        mvvm2.alertTextField(title: eachToDo.text, message: "Внесите изменения", hintText: eachToDo.text, primaryTitle: "Change ToDo", secondaryTitle: "Delete ToDo") { str in
                            mvvmTest.changeToDo(id: eachToDo.id, stringToChange: str)
                        } secondaryAction: {
                            mvvmTest.deleteToDo(id: eachToDo.id)
                            mvvmTest.updateCount()
                        }
                    }
                
                Spacer()
                
            }
            .background(Color.white)
            
            Button {
                mvvmTest.updateIsActive(isActive: eachToDo.status, id: eachToDo.id)
                mvvmTest.updateCount()
            } label: {
                Image(systemName: eachToDo.status ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(eachToDo.status ? .purple : .gray)
                    .font(.system(size: 20, weight: .bold, design: .default))
            }
            .onAppear{
                mvvmTest.getDataToDo()
                mvvmTest.updateCount()
            }
            .frame(width: 24, height: 24)
            
        }
        
    }
}



struct CheckboxStyle: ToggleStyle {
    @EnvironmentObject var mvvmTest: MVVMtest
    var eachToDo: Content
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        return Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(configuration.isOn ? .purple : .gray)
            .font(.system(size: 20, weight: .bold, design: .default))
            .onTapGesture {
                configuration.isOn.toggle()
                mvvmTest.updateIsActive(isActive: eachToDo.status, id: eachToDo.id)
            }
        
    }
    
}



//extension View{
class MVVM2{
    
    func alertTextField(title: String, message: String, hintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (_ changeStringToDo: String) -> (), secondaryAction: @escaping () -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField{ field in
            field.placeholder = hintText
        }
        
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { [self]_ in
            let textField = alert.textFields?[0]
            print("Text field: \(String(describing: textField?.text))")
            
            let changeStringToDo = alert.textFields?[0].text ?? ""
            primaryAction(changeStringToDo)
        }
        ))
        
        alert.addAction(.init(title: secondaryTitle, style: .destructive, handler: { _ in
            secondaryAction()
        }))
        
        rootController().present(alert, animated: true, completion: nil)
    }
    
    
    func rootController() -> UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

var mvvm2 = MVVM2()

