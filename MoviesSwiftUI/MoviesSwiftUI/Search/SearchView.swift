//
//  SearchView.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 28.06.2024.
//

import Foundation
import SwiftUI

struct SearchResultsView: View {
    @StateObject private var searchViewModel = SearchViewModel()
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            List(searchViewModel.items) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    MovieRow(movie: movie)
                }
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
            searchViewModel.getSearchResults(query: searchText)
        }
        .onChange(of: searchText) { newValue in
            searchViewModel.getSearchResults(query: newValue)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    CustomSearchBar(text: $searchText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct CustomSearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search movies", text: $text)
                .padding(10)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    withAnimation {
                        self.isEditing = true
                    }
                }
                .animation(.default, value: isEditing)
            
            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                        self.text = ""
                    }
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default, value: isEditing)
            }
        }
    }
}
