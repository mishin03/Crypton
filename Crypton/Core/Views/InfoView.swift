//
//  InfoView.swift
//  Crypton
//
//  Created by Илья Мишин on 31.01.2023.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let personalURL = URL(string: "https://github.com/mishin03")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let linkedinURL = URL(string: "https://www.linkedin.com/in/ilya-mishin-10224223a/")!
    let defaultURL = URL(string: "https://www.google.com")!

    
    var body: some View {
        NavigationView {
            ZStack {
//                Color.theme.backgound
//                    .ignoresSafeArea()
                List {
                    Section(header: Text("Developer section")) {
                        VStack(alignment: .leading) {
                            Image("Crypton")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(.vertical)
                        Link("Creator Github", destination: personalURL)
                        Link("Creator LinkedIn", destination: linkedinURL)
                        Link("Used resources (API)", destination: coingeckoURL)
                    }
//                    .listRowBackground(Color.theme.backgound)
                    Section(header: Text("Application Section")) {
                        Link("Terms of Service", destination: defaultURL)
                        Link("Privacy Policy", destination: defaultURL)
                        Link("Learn More", destination: defaultURL)
                    }
//                    .listRowBackground(Color.theme.backgound)
                }
            }
            .navigationTitle("Information")
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: { Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
            }
        }
        
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
