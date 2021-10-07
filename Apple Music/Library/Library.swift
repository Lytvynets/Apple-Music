//
//  Library.swift
//  Apple Music
//
//  Created by Vlad Lytvynets on 04.10.2021.
//

import SwiftUI

struct Library: View {
    
    @State var tracks = UserDefaults.standard.saveDataTracks()
    @State private var track: SearchViewModel.Cell!
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    
    var body: some View {
        
        NavigationView {
            
            VStack{
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        
                        Button {
                            self.track = self.tracks[0]
                            self.tabBarDelegate?.maximizedTrackDetailController(viewModel: self.track)
                            print("ActionButton")
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .foregroundColor(.pink)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                        
                        
                        Button {
                            self.tracks = UserDefaults.standard.saveDataTracks()
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
                
                
                List {
                    ForEach(tracks){ track in
                        LibraryCell(cell: track).simultaneousGesture(TapGesture().onEnded({ _ in
                            
                            let keyWindow = UIApplication.shared.connectedScenes
                                .filter ({$0.activationState == .foregroundActive})
                                .map({$0 as? UIWindowScene})
                                .compactMap({$0})
                                .first?.windows
                                .filter({$0.isKeyWindow}).first
                            let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                            tabBarVC?.trackDetailView.delegate = self
                            
                            self.track = track
                            self.tabBarDelegate?.maximizedTrackDetailController(viewModel: self.track)
                        }))
                    }.onDelete(perform: deleteCell )
                    
                }
            }
            .navigationBarTitle("Library")
        }
        
    }
    
    func deleteCell(at offsets: IndexSet){
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
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

extension Library: TrackMovingDelegate {
    
    func moveBackTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex - 1 == -1 {
            nextTrack = tracks[tracks.count - 1]
            
        }else{
            nextTrack = tracks[myIndex - 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    func moveForwardTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex + 1 == tracks.count {
            nextTrack = tracks[0]
            
        }else{
            nextTrack = tracks[myIndex + 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    
}
