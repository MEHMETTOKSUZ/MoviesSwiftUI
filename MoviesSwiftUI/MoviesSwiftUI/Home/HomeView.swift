//
//  ContentView.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 24.06.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @StateObject private var headerViewModel = HeaderViewModel()
    @ObservedObject private var favoriteManager = FavoriteManager.shared
    @ObservedObject private var cartManager = CartManager.shared
    @State private var isShowingSideMenu = false
    @State private var isShowingSearch = false
    @State private var searchText = ""
    @State private var isShowingPurchaseView = false
    @State private var showEmptyCartAlert = false
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        ZStack {
            TabView {
                NavigationView {
                    ScrollView {
                        VStack(alignment: .leading) {
                            MovieHorizontalScrollView(movies: headerViewModel.movies)
                                .padding(.top, 10)
                            Text("Şu Anda Oynayan Filmler")
                                .font(.system(size: 30)).bold()
                                .lineLimit(1)
                                .padding([.leading, .top])
                            
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    MovieRow(movie: movie)
                                        .frame(width: 400, height: 120)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    .navigationBarItems(leading: Button(action: {
                        withAnimation {
                            isShowingSideMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                    }, trailing: NavigationLink(destination: SearchResultsView(searchText: $searchText)) {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.large)
                    })
                    .onAppear {
                        viewModel.getNowPlayingMovies()
                        headerViewModel.getUpcomingMovies()
                        favoriteManager.loadFavoriteMovies()
                        cartManager.load()
                    }
                    .navigationTitle("Yaklaşan Filmler")
                }
                .tabItem {
                    Image(systemName: "film")
                    Text("Filmler")
                }
                
                NavigationView {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(favoriteManager.favorites) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    FavoriteMovieRow(movie: movie)
                                }
                            }
                        }
                        .padding()
                    }
                    .navigationTitle("Favoriler")
                    .onAppear {
                        favoriteManager.loadFavoriteMovies()
                    }
                }
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favoriler")
                }
                
                NavigationView {
                    VStack {
                        List {
                            ForEach(cartManager.items) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    CartMovieRow(movie: movie)
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                        Button(action: {
                            if cartManager.items.isEmpty {
                                showEmptyCartAlert = true
                            } else {
                                isShowingPurchaseView = true
                            }
                        }) {
                            Text("Sepeti Onayla")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding()
                        }
                        .sheet(isPresented: $isShowingPurchaseView) {
                            PaymentView()
                        }
                        .alert(isPresented: $showEmptyCartAlert) {
                            Alert(title: Text("Uyarı"), message: Text("Sepet boş! Lütfen önce sepetinize film ekleyin."), dismissButton: .default(Text("Tamam")))
                        }
                    }
                    .navigationTitle("Sepet")
                }
                .tabItem {
                    Image(systemName: "basket")
                    Text("Sepet")
                }
            }
            .offset(x: isShowingSideMenu ? 200 : 0)
            .disabled(isShowingSideMenu)
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    SideMenuView(isShowing: $isShowingSideMenu)
                        .frame(width: geometry.size.width * 0.5)
                        .offset(x: isShowingSideMenu ? 0 : -geometry.size.width * 0.5)
                    
                    Spacer()
                }
                .background((isShowingSideMenu ? Color.black.opacity(0.6) : Color.clear)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    withAnimation {
                                        isShowingSideMenu = false
                                    }
                                })
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -50 {
                                withAnimation {
                                    isShowingSideMenu = false
                                }
                            }
                        }
                )
            }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let movie = cartManager.items[index]
            cartManager.delete(for: movie.id)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}










