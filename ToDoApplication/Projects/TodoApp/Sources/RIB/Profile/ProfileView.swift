//
//  ProfileView.swift
//  ToDoApp
//
//  Created by hong on 2023/09/21.
//  Copyright © 2023 co.godo. All rights reserved.
//

import SwiftUI
import NetworkProvider
import LocalProvider

struct ProfileView: View {
    
    @State private var catContents: [Data] = []
    @State private var dogContents: [Data] = []
    @State private var selected: Int = 0
    private let imageRepository: ImageRepositoryProtocol
    
    init(imageRepository: ImageRepositoryProtocol) {
        self.imageRepository = imageRepository
    }
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 10) {
                
                HStack {
                    Image("Default")
                        .frame(width: 88, height: 88)
                        .cornerRadius(44)
                    
                    VStack {
                        Text("0")
                        Text("post")
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("0")
                        Text("follower")
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("0")
                        Text("following")
                    }
                    .frame(maxWidth: .infinity)
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("프로필")
                        Text("iOS Develover")
                    }
                    Spacer()
                }
                
                HStack {
                    
                    Button {
                        
                    } label: {
                        Text("Follow")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(4)
                    
                    Button {
                        
                    } label: {
                        Text("Message")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.gray, lineWidth: 1.5)
                            )
                    }
                    .cornerRadius(4)
                    
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.gray, lineWidth: 1.5)
                            )
                    }
                    .cornerRadius(4)
                    
                }
                
                TapView(selected: $selected)
                
                if selected == 0 {
                    cell(catContents)
                } else {
                    cell(dogContents)
                }
                
                Spacer()
            }
            .padding(.horizontal, 28)
            .onAppear {
                Task {
                    let catDatas = try await imageRepository.getCatAndDogRandomImageDatas(.catImageSearch)
                    self.catContents = catDatas
                    let dogDatas = try await imageRepository.getCatAndDogRandomImageDatas(.dogImageSearch)
                    self.dogContents = dogDatas
                }
            }
        }
    }
    
    private func cell(_ datas: [Data]) -> some View {
        let columns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        return LazyVGrid(columns: columns) {
            ForEach(datas, id: \.self) { data in
                Color.white
                    .aspectRatio(1, contentMode: .fill)
                    .overlay(
                        Image(uiImage: UIImage(data: data) ?? UIImage())
                            .resizable()
                            .scaledToFill()
                    ).clipped()
                    .cornerRadius(4)
            }
        }

    }

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(imageRepository: ImageRepository(imageProvider: ImageProvider(), catAndDogProvider: NetworkProvider<CatAndDogAPI>(), anyProvider: NetworkProvider<AnyAPI>(), nsChacheProvider: NSCacheProvider<LocalTargetType>(), plistProvider: PlistProvider<LocalTargetType>(), userdefaultsProvier: UserDefaultsProvider<LocalTargetType>()))
    }
}

struct TapView: View {
    
    @Binding var selected: Int
    
    var body: some View {
        HStack {
            
            Button {
                selected = 0
            } label: {
                VStack {
                    if selected == 0 {
                        Image(systemName: "text.below.photo.fill")
                            .foregroundColor(.black)
                        Color.black
                            .frame(height: 1)
                    } else {
                        Image(systemName: "text.below.photo")
                            .foregroundColor(.black)
                        Color.clear
                            .frame(height: 1)
                    }
                }
      
            }
            .frame(maxWidth: .infinity)
            
            Button {
                selected = 1
            } label: {
                VStack {
                    if selected == 1 {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.black)
                        Color.black
                            .frame(height: 1)
                    } else {
                        Image(systemName: "tag")
                            .foregroundColor(.black)
                        Color.clear
                            .frame(height: 1)
                    }
                }
            }
            .frame(maxWidth: .infinity)

        }
    }
}
