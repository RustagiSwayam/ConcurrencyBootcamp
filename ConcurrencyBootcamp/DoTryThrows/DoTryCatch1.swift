//
//  DoTryCatch.swift
//  ConcurrencyBootcamp
//
//  Created by Swayam Rustagi on 09/07/24.
//

import SwiftUI


class DoTryCatchDataManager1: ObservableObject{
    let isActive: Bool = true
    
    //THIS WORKS TOO, BUT TOO MUCH HASSLE AND LESS CODE READBILITY
    func getTitle1()-> (title: String? , error: Error?){
        if isActive{
            return ("New Text", nil)
        }else{
            return (nil, URLError(.badURL))
        }
    }
}

class DoTryCatchViewModel1: ObservableObject{
    @Published var text: String = "Starting Text"
    let manager = DoTryCatchDataManager1()
    
    func fetchTitle(){
                let returnedValue = manager.getTitle1()
                if let newTitle = returnedValue.title{
                    self.text = newTitle
                }else if let error = returnedValue.error{
                    self.text = error.localizedDescription
                }
        
        }
    }

struct DoTryCatch1: View {
    
    @StateObject var vm = DoTryCatchViewModel1()
    
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
    DoTryCatch1()
}
