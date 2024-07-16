//
//  AsyncLet.swift
//  ConcurrencyBootcamp
//
//  Created by Swayam Rustagi on 11/07/24.
//

import SwiftUI

struct AsyncLet: View {
    
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
            .navigationTitle("Async let party")
            .onAppear {
                Task {
                    do{
                        let image1 = try await fetchingImage()
                        self.images.append(image1)
                        
                        let image2 = try await fetchingImage()
                        self.images.append(image2)
                        
                        let image3 = try await fetchingImage()
                        self.images.append(image3)
                        
                        let image4 = try await fetchingImage()
                        self.images.append(image4)
                    }catch{
                    
                    }
                }
            }
        }
    }
    
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
    AsyncLet()
}
