//
//  DoTryCatch.swift
//  ConcurrencyBootcamp
//
//  Created by Swayam Rustagi on 09/07/24.
//

import SwiftUI


class DoTryCatchDataManager3: ObservableObject{
    let isActive: Bool = true
    
    func getTitle3() throws -> String{
        if isActive{
            return "New Text3"
        }else{
            throw URLError(.badServerResponse)
        }
    }
    
    func getTitle4()throws -> String{
        if isActive{
            return "Final Text4"
        }else{
            throw URLError(.badServerResponse)
        }
    }
}

class DoTryCatchViewModel3: ObservableObject{
    @Published var text: String = "Starting Text"
    let manager = DoTryCatchDataManager3()
    
    func fetchTitle(){
        
        //the optional try almost eliminates the do-catch block
        let finalTitle = try? manager.getTitle4()
        if let newTitle = finalTitle{
            self.text = newTitle
        }
        
        do{
            //even if first line fails in do block, the catch block will be executed
            let newTitle = try manager.getTitle3()
            self.text = newTitle
        
        }catch{
            self.text = error.localizedDescription
        }
        
    }
    
    
}

struct DoTryCatch3: View {
    
    @StateObject var vm = DoTryCatchViewModel3()
    
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
    DoTryCatch3()
}
