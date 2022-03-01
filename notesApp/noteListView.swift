//
//  noteListView.swift
//  notesApp
//
//  Created by Sushant Yadav on 03/05/21.
//

import SwiftUI

struct note: Identifiable {
    var id = UUID()
    var title: String
    var content: String
}

class notes_cls: ObservableObject {
    @Published var notes:[note]
    
    init(){
        self.notes = Array(repeating: note(title: "i am", content: "new note"), count: 15)
//        self.notes = Array()
    }
    
    func addNote(title:String, content:String) -> Void {
        self.notes.append(note(title: title, content: content))
    }
}

struct noteListView: View {
    
    @Environment(\.colorScheme) var colorScheme
    var note: note
    
    var body: some View {
        Text(note.title)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.white.opacity(0.8))
            .frame(maxWidth: .infinity, minHeight: 25.0, maxHeight: 25.0, alignment: .center)
            .padding()
            .background(Color(.black))
            .cornerRadius(10.0)
    }
}

struct noteDetailView: View{
    
    @EnvironmentObject var notes: notes_cls
    @State var note: note
    @State private var titleSelected = false
    @State private var titleOpac = 1.0
    @State private var contentOpac = 0.0
    @State var note_ind:Int? = nil
    @Environment(\.colorScheme) var colorScheme
    
    init(note: note){
        UITextView.appearance().backgroundColor = .clear
        _note = State(initialValue: note)
        print(colorScheme)
    }
    
    var body: some View{
        VStack(alignment: .leading, spacing: 30){
            
            if(!titleSelected){
                Button(action:{
                    titleSelected = true
                }){
                    Text(note.title == "" ? "Title":note.title)
                        .padding(10.0)
                        .foregroundColor(.black)
                        .font(.system(size: 30.0, weight: .bold, design: Font.Design.default))
                        .frame(maxWidth: .infinity, minHeight: 100,
                               maxHeight: 100)
                        .cornerRadius(20.0)
                        .multilineTextAlignment(.center)
                        .onAppear(){
                            titleOpac = 1.0
                        }
                        .onDisappear(){
                            titleOpac = 0.0
                        }
                        .opacity(titleOpac)
                        .animation(.easeInOut(duration: 1.0))
                }
            }
            
            if(titleSelected){
                ZStack {
                    TextEditor(text: $note.title)
                        .padding(10.0)
                        .foregroundColor(.white)
                        .font(.system(size: 30.0, weight: .bold, design: Font.Design.default))
                        .background(Color(red:184/255, green:142/255, blue:141/255))
                        .cornerRadius(20.0)
                        .multilineTextAlignment(.center)
                        .onChange(of: note.title, perform: { value in
                            let last = note.title.last
                            if(last != nil && last == "\n"){
                                titleSelected = false
                            }
                            note.title.removeAll { (chr) -> Bool in
                                chr == "\n"
                            }
                            if(note_ind != nil){
                                notes.notes[note_ind!].title = note.title
                            }
                        })
                    
                    if(note.title == ""){
                        Text("Title")
                            .foregroundColor(.gray)
                    }
                }
                .transition(AnyTransition.move(edge: .top))
                .animation(.default)
            }
            
            if(titleSelected){
                Button(action: {
                    titleSelected = false
                }){
                    Text(note.content == "" ? "Some Content":note.content)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 100,
                               maxHeight: 1000)
                        .foregroundColor(.black)
                        .font(.system(size: 24.0, weight: .regular, design: Font.Design.default))
                        .cornerRadius(20.0)
                        .multilineTextAlignment(.center)
                        .onAppear(){
                            contentOpac = 1.0
                        }
                        .onDisappear(){
                            contentOpac = 0.0
                        }
                        .opacity(contentOpac)
                        .animation(.easeInOut(duration: 1.0))
                }
            }
            
            if(!titleSelected){
                ZStack {
                    TextEditor(text: $note.content)
                        .padding()
                        .font(.system(size: 24.0, weight: .semibold, design: Font.Design.default))
                        .background(Color(red:53/255, green:67/255, blue:94/255))
                        .cornerRadius(20.0)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .onChange(of: note.content, perform: { value in
                            if(note_ind != nil){
                                notes.notes[note_ind!].content = note.content
                            }
                        })
                    
                    if(note.content == ""){
                        Text("Some Content")
                            .foregroundColor(.gray)
                    }
                }
                .transition(AnyTransition.move(edge: .bottom))
                .animation(.default)
            }
            
            Spacer()
        }
        .padding(.all)
        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .leading)
        .animation(.default)
        .onAppear(){
            if(note.title != "" || note.content != ""){
                DispatchQueue.main.async {
                    note_ind = notes.notes.firstIndex { (n) -> Bool in
                        n.id == note.id
                    }
                }
            }
            else{
                notes.notes.append(note)
                note_ind = notes.notes.count - 1
            }
        }
        .onDisappear(){
            if(note_ind != nil && notes.notes[note_ind!].title == "" && notes.notes[note_ind!].content == ""){
                notes.notes.remove(at: note_ind!)
            }
        }
        
    }
    
}


struct note_Preview: PreviewProvider {
    static var previews: some View {
        Group {
//            noteDetailView(note: note(title: "", content: ""))
            noteListView(note: note(title: "Hello", content: "World"))
                
            noteDetailView(note: note(title: "", content: ""))
                .preferredColorScheme(.light)
        }
        .environmentObject(notes_cls())
    }
}
