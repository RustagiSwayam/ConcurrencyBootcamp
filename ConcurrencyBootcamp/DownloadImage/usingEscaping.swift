//
//  usingAsyncAwait.swift
//  ConcurrencyBootcamp
//
//  Created by Swayam Rustagi on 09/07/24.
//

import SwiftUI


class AsyncImageLoader {
    
    let url = URL(string: "https://picsum.photos/200")!
    
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
}


class asyncImageModel: ObservableObject{
    @Published var image: UIImage? = nil
    
    let loader = AsyncImageLoader()
    
    //by using self, we make it a strong ref, use [weak self] and make it a weak ref and add a self? while setting the image's value.
    func fetchImage(){
        loader.downloadWithEscaping{[weak self] image, error in
//            if let image = image{//considering image contains an image we can use.
//                self?.image = image
//            }
            
            
            //we used the dispatch queue, as the self.image is optional and with this, we are putting this on main thread. 
            DispatchQueue.main.async{
                self?.image = image
            }
        }
    }
}

struct usingEscaping: View {
    
    @StateObject var vm = asyncImageModel()
    
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
    usingEscaping()
}
