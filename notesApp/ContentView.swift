//
//  ContentView.swift
//  notesApp
//
//  Created by Sushant Yadav on 03/05/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var notes = notes_cls()
    
    init(){
        UITableView.appearance().backgroundColor = .none
        UITableView.appearance().backgroundView = .none
        UIListContentView.appearance().backgroundColor = .none
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().separatorColor = .clear
    }
    
    var body: some View {
        
            NavigationView{
                ZStack {
                        
                    List(notes.notes){
                        note in
                        ZStack {
                            
                            NavigationLink(
                                    destination: noteDetailView(note: note)){
                                EmptyView()
                            }
                            
                            noteListView(note: note)
                            
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(content: {
                            ToolbarItem(placement: ToolbarItemPlacement.principal) {
                                HStack {
                                    Text("Notes")
                                    Image(systemName: "pencil")
                                }
                            }
                        })
                    
                    VStack {
                        if(notes.notes.count == 0){
                            Text("Create a Note")
                                .foregroundColor(.gray)
                                .offset(y:100)
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink(
                                destination: noteDetailView(note: note(title: "", content: "")),
                                label: {
                                    Image(systemName: "plus.circle.fill")
                                        .scaleEffect(2.0)
                                        .padding()
                                })
                        }
                        .offset(x: -30.0, y: -30.0)
                    }
                }
            }
            .environmentObject(notes)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
            
    }
}
