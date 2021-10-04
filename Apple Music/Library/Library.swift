//
//  Library.swift
//  Apple Music
//
//  Created by Vlad Lytvynets on 04.10.2021.
//

import SwiftUI

struct Library: View {
    
    var tracks = UserDefaults.standard.saveDataTracks()
    
    var body: some View {
        
        NavigationView {
            
            VStack{
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        
                        Button {
                            print("ActionButton")
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .foregroundColor(.pink)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                        
                        
                        Button {
                            print("Pause")
                        } label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .foregroundColor(.pink)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                    }
                }.padding().frame(height: 65)
                Divider().padding(.leading).padding(.trailing)
                
                
                List(tracks) { track in
                    LibraryCell(cell: track)
                }
            }
            .navigationBarTitle("Library")
        }
        
    }
}




struct LibraryCell: View {
    
    var cell: SearchViewModel.Cell
    
    var body: some View {
        
        HStack{
            Image("bmw-m3").resizable().frame(width: 60, height: 60)
            VStack(alignment: .leading){
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
                
            }
        }
        
        
        
    }
}





struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
