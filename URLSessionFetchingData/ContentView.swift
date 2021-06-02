//
//  ContentView.swift
//  URLSessionFetchingData
//
//  Created by 김정민 on 2021/06/02.
//

import SwiftUI

let getUrl = "https://jsonplaceholder.typicode.com/todos"
let postUrl = "https://jsonplaceholder.typicode.com/posts"

// model
struct Model: Codable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}

struct PostModel: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

// viewModel
class ViewModel: ObservableObject {
    @Published var items = [Model]()
    
    // get data
    func loadData() {
        guard let url = URL(string: getUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    let result = try JSONDecoder().decode([Model].self, from: data)
                    DispatchQueue.main.async {
                        self.items = result
                        print("get - items: \(self.items)")
                    }
                } else {
                    print("get - no data")
                }
            } catch let error {
                print("get error - \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // post data
    func postData() {
        guard let url = URL(string: postUrl) else { return }
        
        let title = "foo"
        let bar = "bar"
        let userId = 1
        
        let body: [String: Any] = ["title": title, "body": bar, "userId": userId]
        
        let finalData = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(PostModel.self, from: data)
                    print("post - result: \(result)")
                } else {
                    print("post - no data")
                }
            } catch let error {
                print("post - error: \(error.localizedDescription)")
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.items, id: \.id) { item in
                    Text(item.title)
                }
            }.onAppear(perform: {
                viewModel.loadData()
                viewModel.postData()
            })
            .navigationTitle("Datas")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
