//
//  DoTryCatch.swift
//  ConcurrencyBootcamp
//
//  Created by Swayam Rustagi on 09/07/24.
//

import SwiftUI


class DoTryCatchDataManager2: ObservableObject{
    let isActive: Bool = true
    
    func getTitle2()-> Result<String, Error>{
        if isActive{
            return .success("NEW TEXT BABY")
        }else{
            return .failure(URLError(.badURL))
        }
    }
}

class DoTryCatchViewModel2: ObservableObject{
    @Published var text: String = "Starting Text"
    let manager = DoTryCatchDataManager2()
    
    func fetchTitle(){
        let result = manager.getTitle2()
        switch result{
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text  = error.localizedDescription
        
        }
    }
    
    
}

struct DoTryCatch2: View {
    
    @StateObject var vm = DoTryCatchViewModel2()
    
    var body: some View {
        Text(vm.text)
            .foregroundStyle(.white)
            .padding()
            .frame(width: 300, height: 50)
            .background(.indigo)
            .onTapGesture {
                vm.fetchTitle()
            }
    }
}

#Preview {
    DoTryCatch2()
}
