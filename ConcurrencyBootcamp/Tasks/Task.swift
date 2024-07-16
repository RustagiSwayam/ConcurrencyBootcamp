//
//  Task.swift
//  ConcurrencyBootcamp
//
//  Created by Swayam Rustagi on 10/07/24.
//

import SwiftUI

class TaskBCViewModel: ObservableObject {
    
    @Published var image1: UIImage? = nil
    @Published var image2: UIImage? = nil
    func fetchImage1() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            
            if let fetchedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image1 = fetchedImage
                    print("Image1 Loaded successfuly")
                }
            }
        } catch {
            print("Error fetching image: \(error.localizedDescription)")
        }
    }
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/300") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            
            if let fetchedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image2 = fetchedImage
                    print("Image2 returned successfuly")
                }
            }
        } catch {
            print("Error fetching image: \(error.localizedDescription)")
        }
    }
}

struct TaskHomeView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                NavigationLink{
                    TaskView()
                }label: {
                    Text("Click Me!")
                }
            }
        }
    }
}

struct TaskView: View {
    
    @StateObject private var viewModel = TaskBCViewModel()
    //the major problem is user's device still running the tasks, they dont wanna execute and thus slowing their phone down.
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image1 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        //Since onAppear modifier works synchronusly, if we add 2 tasks, seperately, then it would work in the desired manner.
        
        .onDisappear{
            fetchImageTask?.cancel()
            print("Image2 was unreturned successfully")
        }
        .onAppear {
//            
//            //Currently task are working one after the another and not together
            fetchImageTask = Task {
                await viewModel.fetchImage1()
            }
//            //Tasks can be set of different priorities, but child task inherits the parent task's priority
            Task{
                await viewModel.fetchImage2()
            }
        }
        //SO these .onAppear and .onDisappear are quite irrelevant as apple introduced a .task modifier which automatically cancels the task if it's canceled before executing
    }
}

#Preview {
    TaskView()
}
