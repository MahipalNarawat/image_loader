//
//  ContentView.swift
//  image_loder
//
//  Created by Mahipal on 16/04/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var vm: ContentViewModel = .init()
    
       var columns: [GridItem] = [
           GridItem(.flexible()),
           GridItem(.flexible()),
           GridItem(.flexible())
       ]
       
       var body: some View {
           
           ScrollView {
               LazyVGrid(columns: columns, spacing: 10) {
                   ForEach(0..<vm.data.count, id: \.self) { index in
                       CachedImageView(url: vm.data[index].coverageURL)
                          
                   }
               }
               .padding(.horizontal, 8)
              
           }
           .padding(.top, 1)
           .background(Color.mint)
           .overlay {
               if vm.loading {
                   ProgressView()
                       .tint(.white)
               }
           }
       }
    
}

#Preview {
    ContentView()
}
