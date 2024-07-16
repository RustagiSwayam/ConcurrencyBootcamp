////
////  TaskGroup.swift
////  ConcurrencyBootcamp
////
////  Created by Swayam Rustagi on 11/07/24.
////
//
//import SwiftUI
//
//
//class TaskGroupDataManager{
//    
//    //This is working for now but not very scalable.
//    func fetchUsingAsyncLet() async throws-> [UIImage]{
//        async let fetchImage1 = fetchingImage(from: "https://picsum.photos/200")
//        async let fetchImage2 = fetchingImage(from: "https://picsum.photos/200")
//        async let fetchImage3 = fetchingImage(from: "https://picsum.photos/200")
//        async let fetchImage4 = fetchingImage(from: "https://picsum.photos/200")
//        
//        let(image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
//        
//        return[image1, image2, image3, image4]
//    }
//    
//    func fetchUsingTaskGroup() async throws->[UIImage]{
//        
//        //Well, we are still entering the strings manually
//        let urlStrings = ["https://picsum.photos/200","https://picsum.photos/200","https://picsum.photos/200","https://picsum.photos/200"]
//        //withtaskgroup -> if throws no errors
//        //withthrowingtaskgroup -> if throws errors
//        //using try await as general protocol for methods who throws.
//        return try await withThrowingTaskGroup(of: UIImage?.self){group in
//            var images: [UIImage] = []
//            images.reserveCapacity(urlStrings.count) //so that it stays ready for the no. of images coming to get stored in it
//            
//            for urlString in urlStrings{
//                group.addTask{
//                    try? await self.fetchingImage(from: urlString)
//                    //adding try? so that if one of the images fail to load, the whole results are not compromised.
//                }
//            }
//            //We never wanna enter these tasks manually.
////            group.addTask{
////                try await self.fetchingImage()
////            }
////            group.addTask{
////                try await self.fetchingImage()
////            }
////            group.addTask{
////                try await self.fetchingImage()
////            }
////            group.addTask{
////                try await self.fetchingImage()
////            }
//            
//            //This forloop will await each of the task in group to comeback
//            for try await image in group{
//                //since the images are optional, using if let to safely unwrap it.
//                if let image = image{
//                    images.append(image)
//                }
//            }
//            
//            return images
//        }
//    }
//    
//    func fetchingImage(from urlString: String) async throws -> UIImage {
//        guard let url = URL(string: urlString) else {
//            throw URLError(.badURL)
//        }
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
//            if let returnedImage = UIImage(data: data) {
//                return returnedImage
//            } else {
//                throw URLError(.cannotDecodeContentData)
//            }
//        } catch {
//            throw error
//        }
//    }
//    
//    class TaskGroupViewModel: ObservableObject{
//        @Published  var images: [UIImage] = []
//        let manager = TaskGroupDataManager()
//        
//        func getImage() async{
//            if let images = try? await manager.fetchUsingTaskGroup(){
//                self.images.append(contentsOf: images)
//            }
//        }
//        
//    }
//    
//    struct TaskGroupView: View {
//        @StateObject var viewModel = TaskGroupViewModel()
//        let columns = [GridItem(.flexible()), GridItem(.flexible())]
//        
//        var body: some View {
//            NavigationView{
//                ScrollView{
//                    LazyVGrid(columns: columns){
//                        ForEach(viewModel.images, id: \.self){ image in
//                            Image(uiImage: image)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 150)
//                        }
//                    }
//                }
//                .navigationTitle("Async let efficient")
//                .task{
//                    await viewModel.getImage()
//                }
//            }
//        }
//    }
//    
//    
//    //What if i wanna fetch 50 images at one time? we dont wanna use async let 50 times and address each image 1...50, we use tashGroup for that.
//    
//    
//    #Preview {
//        TaskGroupView()
//    }
//}
