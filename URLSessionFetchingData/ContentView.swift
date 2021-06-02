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
                    }
                } else {
                    print("No data")
                }
            } catch let error {
                print("error - \(error.localizedDescription)")
            }
        }.resume()
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
