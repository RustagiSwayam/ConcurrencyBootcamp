//
//  CheckedContinuation.swift
//  ConcurrencyBootcamp
//
//  Created by Swayam Rustagi on 12/07/24.
//

import SwiftUI


class CheckedContinuationNetworkManager {
    
    func getData(url: URL) async throws -> Data{
        do{
            //The sharad.data api is customized for async, but we use continuations for converting non customized to customized.
            
            let (data, _) = try await  URLSession.shared.data(from: url, delegate: nil)
            return data
        }catch{
            throw error
        }
    }
    
    //we can use checkedContinuations that checks errors too, use withCheckedThrowingContinuation
    
    func getData2(url: URL) async throws -> Data{
        
        
        //we are basically suspending the other tasks to run this task below and wait for it to complete and continue
        return try await withCheckedThrowingContinuation{continuation in
            URLSession.shared.dataTask(with: url){data, response, error in
                if let data = data{
                    //resume only once or the app could potentially crash
                    continuation.resume(returning: data)
                }else if let error = error{
                    continuation.resume(throwing: error)
                }else{
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
            //data task requires resume to continue its operations.
        }
    }
    
    func getHeartImageFromDatabase(completionHandler: @escaping (_ image: UIImage?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if let heartImage = UIImage(systemName: "heart.fill") {
                completionHandler(heartImage)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func getHeartImageAsync() async -> UIImage?{
        return await withCheckedContinuation{continuation in
             getHeartImageFromDatabase{image in //as above function is returning a UIImage
                continuation.resume(returning: image)
            }
        }
    }
}

class CheckedContinuationViewModel: ObservableObject{
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuationNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        
        do{
            let data = try await networkManager.getData2(url: url)
            if let image = UIImage(data: data){
                await MainActor.run(body: {
                    self.image = image
                })
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func getHeartImage() async {
        let image = await networkManager.getHeartImageAsync()
        self.image = image
    }
    }

struct CheckedContinuation: View {
    
    @StateObject var viewModel = CheckedContinuationViewModel()
    
    var body: some View {
        ZStack{
            if let image = viewModel.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task{
            await viewModel.getHeartImage()
        }
    }
}

#Preview {
    CheckedContinuation()
}
