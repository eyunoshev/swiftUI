//
//  ViewModelToDo.swift
//  3cardSwiftUI
//
//  Created by dunice on 24.10.2022.
//

import SwiftUI

struct PostToDo: Codable, Hashable {
    let data: DataClass
    let statusCode: Int
    let success: Bool
}

// MARK: - DataClass
struct DataClass: Codable, Hashable {
    let content: [Content]
    let notReady, numberOfElements, ready: Int
}

// MARK: - Content
struct Content: Codable, Hashable, Identifiable {
    let id: Int
    var text: String
    var status: Bool
}


class MVVMtest: ObservableObject {
    
    @Published var massiveToDo = [Content]()
    @Published var countCompleted: Int = 0
    @Published var countNonCompleted: Int = 0
    
    @Published var todos: PostToDo?
    
    
    func getDataToDo(){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/todo?page=1&perPage=5") else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

//            guard let response = response as? HTTPURLResponse else { return }

//            if response.statusCode == 200
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedUsers = try JSONDecoder().decode(PostToDo.self, from: data)
                        self.massiveToDo = decodedUsers.data.content
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }

        }
        dataTask.resume()
//        print (self.todos ?? [])
//        print (todos?.data.content[0].text)
//        print (todos?.data.content.first{item in
//            item.status == true
//        })
    }
    
    
//    func getDataToDo(){
//        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/todo?page=1&perPage=5") else { fatalError("Missing URL") }
//        var request = URLRequest(url: url)
//
//        request.httpMethod = "GET"
//
//        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let response = response {
//                print (response)
//                return
//            }
//
//            guard let data = data  else { return }
//            DispatchQueue.main.async{
//            do {
//                let json = try JSONDecoder().decode(PostToDo.self, from: data)
//                self.massiveToDo = json.data.content
//                print (json)
//            } catch {
//                print(error)
//            }
//            }
//        }
//        session.resume()
//
//    }
    
    
    func postDataToDo(stringToDoFromTextField:String){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/todo") else { fatalError("Missing URL") }
        let parametrs = ["text" : stringToDoFromTextField]
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametrs, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print (response)
            }
            
            guard let data = data  else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print (json)
            } catch {
                print(error)
            }
        }.resume()

    }
    
    
    
    func deleteDataToDo(id: Int){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/todo/\(id)") else { fatalError("Missing URL") }
        let parametrs = ["id" : id]
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametrs, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print (response)
            }
            
            guard let data = data  else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print (json)
            } catch {
                print(error)
            }
        }.resume()
        print (id)
    }
    
    
    
    func deleteAllCompletedDataToDo(){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/todo") else { fatalError("Missing URL") }
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print (response)
            }
            
            guard let data = data  else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print (json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func makeAllActiveToDosOrNonActive(status: Bool){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/todo") else { fatalError("Missing URL") }
        let parametrs = ["status" : status]
        var request = URLRequest(url: url)
        
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametrs, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print (response)
            }
            
            guard let data = data  else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print (json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    
    func changeStatusToDo(status: Bool, id: Int){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/todo/status/\(id)") else { fatalError("Missing URL") }
        let parametrs = ["status": status]
        var request = URLRequest(url: url)
        
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametrs, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print (response)
            }
            
            guard let data = data  else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print (json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    
    func changeTextToDo(text: String, id: Int){
        guard let url = URL(string: "https://news-feed.dunice-testing.com/api/v1/todo/text/\(id)") else { fatalError("Missing URL") }
        let parametrs = ["text": text]
        var request = URLRequest(url: url)
        
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametrs, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print (response)
            }
            
            guard let data = data  else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print (json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    
    var massiveToCount = [Content]()
    
    
    func addToDo(stringToDoFromText:String, isActiveToDoFromNew: Bool){
        postDataToDo(stringToDoFromTextField: stringToDoFromText)
        getDataToDo()
        updateCount()
//        massiveToDo.append(Content.init(id: <#Int#>, text: stringToDoFromText, status: isActiveToDoFromNew)
    }
    
    func deleteToDo(id: Int){
        deleteDataToDo(id: id)
//        getDataToDo()
        massiveToDo.removeAll {item in
            item.id == id
        }
        updateCount()
    }
    
    func changeToDo(id: Int, stringToChange: String) {
        changeTextToDo(text: stringToChange, id: id)
//        getDataToDo()
        if let index = massiveToDo.firstIndex(where: { $0.id == id}) {
            massiveToDo[index].text = stringToChange
        }
        updateCount()
    }
    
    
    func showAlertInfo(){
        
    }
    
    
    func updateIsActive(isActive: Bool, id: Int) {
        changeStatusToDo(status: !isActive, id: id)
//        getDataToDo()
        if let index = massiveToDo.firstIndex(where: { $0.id == id}) {
            massiveToDo[index].status.toggle()
        }
        updateCount()
    }
    
    func makeAllActive(){
        makeAllActiveToDosOrNonActive(status: true)
//        getDataToDo()
        massiveToDo = massiveToDo.map { (item) -> Content in
            var temp = item
            temp.status = true
            return temp
        }
        updateCount()
    }
    
    func makeAllNonActive(){
        makeAllActiveToDosOrNonActive(status: false)
//        getDataToDo()
        massiveToDo = massiveToDo.map { (item) -> Content in
            var temp = item
            temp.status = false
            return temp
        }
        updateCount()
    }
    
    func deleteAllComplited(){
        deleteAllCompletedDataToDo()
//        getDataToDo()
        massiveToDo.removeAll{item in
            item.status == true
        }
        updateCount()
    }
    
    func updateCount(){
        massiveToCount = massiveToDo
        massiveToCount.removeAll{item in
            item.status == true
        }
        countNonCompleted = massiveToCount.count
        countCompleted = massiveToDo.count - countNonCompleted
        
    }
    
}
