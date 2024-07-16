//
//  ActorView.swift
//  ConcurrencyBootcamp
//
//  Created by Swayam Rustagi on 15/07/24.
//

import SwiftUI

class DataManagerMy{
    static let instance = DataManagerMy()
    private init(){}
    
    var data: [String] = []
    private let queue = DispatchQueue(label: "com.ConcurrencyBootcamp.DataManagerMy")
    
    //old way of getting out of sync blocks are 'ComletionHandlers'
    func getRandomData()-> String?{
        queue.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            return data.randomElement()
        }
    }
}

struct HomeView: View {
    @State private var text: String = ""
    let timer = Timer.publish(every: 3, on: .main, in: .common, options: nil).autoconnect()
    
    let manager = DataManagerMy.instance
    var body: some View {
        ZStack{
            Color.gray.opacity(0.3).ignoresSafeArea()
            Text(text)
        }
        .onReceive(timer){ _ in //every 0.1 seconds, we recieve a value
            
            DispatchQueue.global(qos: .background).async {
                if let data = manager.getRandomData() {
                    DispatchQueue.main.async{
                        self.text = data
                    }
                }
            }
        }
    }
}

struct SearchView: View {
    @State private var text: String = ""
    let timer = Timer.publish(every: 3, on: .main, in: .common, options: nil).autoconnect()
    
    let manager = DataManagerMy.instance
    var body: some View {
        ZStack{
            Color.red.opacity(0.3).ignoresSafeArea()
            Text(text)
        }
        .onReceive(timer){ _ in //every 0.1 seconds, we recieve a value
            DispatchQueue.global(qos: .background).async {
                if let data = manager.getRandomData() {
                    DispatchQueue.main.async{
                        self.text = data
                    }
                }
            }
        }
    }
}
//Here 2 different threads are trying to access the same memory in the heap.
    
    struct ActorView: View {
        var body: some View {
            TabView{
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }
                
                SearchView()
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
            }
        }
    }
    
    #Preview {
        ActorView()
    }

