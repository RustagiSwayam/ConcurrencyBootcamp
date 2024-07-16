//
//  efficient.swift
//  ConcurrencyBootcamp
//
//  Created by Swayam Rustagi on 11/07/24.
//

import SwiftUI

struct efficient: View {
    
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/200")!
    
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: columns){
                    ForEach(images, id: \.self){ image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                    }
                }
            }
            .navigationTitle("Async let efficient")
            .onAppear {
                Task {
                    do{
                        //we are executing these functions all at one time
                        async let fetchImage1 = fetchingImage()
                        async let fetchTitle1 = fetchTitle()
//                        async let fetchImage2 = fetchingImage()
//                        async let fetchImage3 = fetchingImage()
//                        async let fetchImage4 = fetchingImage()
                        
                        //returning images all at one time
                        
//                        let(image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
                        
                        let(image1, title) = await(try fetchImage1, fetchTitle1)
                        
                        self.images.append(contentsOf: [image1])
                    }catch{
                    
                    }
                }
            }
        }
    }
    
    func fetchTitle()async-> String{
        return "new titile"
    }
    
    //What if i wanna fetch 50 images at one time? we dont wanna use async let 50 times and address each image 1...50, we use tashGroup for that.
    
    func fetchingImage() async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let returnedImage = UIImage(data: data) {
                return returnedImage
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

#Preview {
    efficient()
}
