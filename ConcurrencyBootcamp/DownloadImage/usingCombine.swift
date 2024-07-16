//
//  usingCombine.swift
//  ConcurrencyBootcamp
//
//  Created by Swayam Rustagi on 09/07/24.
//

import SwiftUI
import Combine

class AsyncImageLoader2 {
    
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
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: self.url) { data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data),
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    completionHandler(nil, error)
                    return
            }
            
            completionHandler(image, nil)
        }
        .resume()
    }
    
    func downloadWithCombine()-> AnyPublisher<UIImage?, Error>{
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({$0})
            .eraseToAnyPublisher()
    }
}

class asyncImageModel2: ObservableObject{
    @Published var image: UIImage? = nil
    let loader = AsyncImageLoader2()
    var cancellables = Set<AnyCancellable>()
    
    func fetchImage(){
        loader.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink{ _ in
                
            }receiveValue: { [weak self] image in
                    self?.image = image
            }.store(in: &cancellables)
    }
}


struct usingCombine: View {
    @StateObject var vm = asyncImageModel2()
    
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
            vm.fetchImage()
        }
    }
}

#Preview {
    usingCombine()
}
