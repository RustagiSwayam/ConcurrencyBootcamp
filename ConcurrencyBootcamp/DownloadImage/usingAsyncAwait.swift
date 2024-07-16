//
//  usingAsyncAwait.swift
//  ConcurrencyBootcamp
//
//  Created by Swayam Rustagi on 09/07/24.
//

import SwiftUI

class AsyncImageLoader3{
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?)-> UIImage?{
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                return nil
        }
        
        return image
    }
    
    func downloadWithAsync()async throws-> UIImage?{
        do{
        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            
        let image = handleResponse(data: data, response: response)
        return image
        }catch{
            throw error
        }
    }
}

class AsyncImageModel3: ObservableObject{
    @Published var image: UIImage? = nil
    var loader = AsyncImageLoader3()
    
    func fetchImage() async {
        let image = try? await loader.downloadWithAsync()
        
        //using mainactor macro to run it on main thread.
        await MainActor.run{
            self.image = image
        }
    }
}

struct usingAsyncAwait: View {
    
    @StateObject var vm = AsyncImageModel3()
    
    var body: some View {
        ZStack{
            if let image = vm.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear{
            Task{
                await vm.fetchImage()
            }
        }
    }
}

#Preview {
    usingAsyncAwait()
}
