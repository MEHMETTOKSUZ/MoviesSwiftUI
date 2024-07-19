//
//  DetailsView.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 25.06.2024.
//

import SwiftUI
import Kingfisher
//import YouTubeiOSPlayerHelper

struct MovieDetailView: View {
    let movie: Results
    
    @StateObject private var castViewModel = CastViewModel()
    @StateObject private var genreViewModel = MovieGenresViewModel()
    @StateObject private var commentViewModel = CommentViewModel()
    @StateObject private var videosViewModel = VideosViewModel()
    @State private var isFavorite: Bool = false
    @State private var isInCart: Bool = false
    @State private var isVideoPlaying: Bool = false
    @State private var showPurchaseAlert: Bool = false
    @State private var isLoading: Bool = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if isVideoPlaying {
                    ZStack {
                        if let videoKey = videosViewModel.videos.first?.key {
                            YouTubePlayerView(videoID: videoKey, isLoading: $isLoading)
                                .frame(width: 400, height: 300)
                        } else {
                            ProgressView()
                                .frame(width: 400, height: 300)
                        }
                        
                        if isLoading {
                            ProgressView()
                                .frame(width: 400, height: 300)
                        }
                    }
                } else {
                    if let posterPath = movie.poster_path {
                        let imageUrl = "https://image.tmdb.org/t/p/w500" + posterPath
                        ImageView(url: imageUrl, width: 400, height: 300, cornerRadius: 20)
                            .onTapGesture {
                                if PaymentManager.shared.isPurchased(item: movie) {
                                    startVideoPlayback()
                                } else {
                                    showPurchaseAlert = true
                                }
                            }
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(movie.original_title)
                        .font(.largeTitle)
                        .padding(.horizontal)
                    
                    HStack(alignment: .center, spacing: 5) {
                        Image(systemName: "calendar")
                            .foregroundColor(.black)
                            .padding(8)
                        Text(movie.release_date)
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    RatingView(rating: movie.vote_average)
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                    HStack {
                        Image(systemName: "theatermasks")
                            .foregroundColor(.gray)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(genreViewModel.genres) { genre in
                                    Text(genre.name)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.gray)
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    HStack(alignment: .center, spacing: 30) {
                        FavoriteButton(isFavorite: $isFavorite, movie: movie)
                        
                        if !PaymentManager.shared.isPurchased(item: movie) {
                            CartButton(isInCart: $isInCart, movie: movie)
                        }
                        
                        NavigationLink(destination: CommentView(viewModel: commentViewModel, movieId: movie.id)) {
                            Image(systemName: "text.bubble.rtl")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        }
                        ActionButton(iconName: "play.fill", action: {
                            if PaymentManager.shared.isPurchased(item: movie) {
                                startVideoPlayback()
                            } else {
                                showPurchaseAlert = true
                            }
                        })
                    }
                    .padding(.horizontal)
                    
                    Text(movie.overview)
                        .font(.body)
                        .padding()
                    
                    Text("Oyuncular")
                        .font(.title2)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(castViewModel.casting) { castMember in
                                VStack {
                                    if let profilePath = castMember.profile_path {
                                        let profileImageUrl = "https://image.tmdb.org/t/p/w500" + profilePath
                                        KFImage(URL(string: profileImageUrl))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                    } else {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    Text(castMember.name)
                                        .font(.headline)
                                        .lineLimit(4)
                                }
                                .frame(width: 100)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .onAppear {
                castViewModel.getCastData(movieId: movie.id)
                genreViewModel.getGenres(movieId: movie.id)
                FavoriteManager.shared.loadFavoriteMovies()
                isFavorite = FavoriteManager.shared.isFavorite(item: movie)
                isInCart = CartManager.shared.isInCart(item: movie)
                videosViewModel.getVideos(videoId: String(movie.id))
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("newMovies"), object: nil, queue: .main) { _ in
                    if PaymentManager.shared.isPurchased(item: movie) {
                        startVideoPlayback()
                    }
                }
            }
            .alert(isPresented: $showPurchaseAlert) {
                Alert(
                    title: Text("Satın Alma Gerekli"),
                    message: Text("Bu videoyu izlemek için önce satın almalısınız."),
                    dismissButton: .default(Text("Tamam"))
                )
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    private func startVideoPlayback() {
        isVideoPlaying = true
        isLoading = true
    }
}



