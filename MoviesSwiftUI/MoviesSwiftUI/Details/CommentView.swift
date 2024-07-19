//
//  CommentView.swift
//  MoviesSwiftUI
//
//  Created by Mehmet ÖKSÜZ on 11.07.2024.
//

import SwiftUI
import Kingfisher

struct CommentView: View {
    @ObservedObject var viewModel: CommentViewModel
    let movieId: Int
    
    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                List(viewModel.comments) { comment in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            if let avatarPath = comment.avatar_path {
                                let profileImageUrl = "https://image.tmdb.org/t/p/w500" + avatarPath.absoluteString
                                KFImage(URL(string: profileImageUrl))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(comment.author)
                                    .font(.headline)
                                Text(comment.updated_at)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        Text(comment.content)
                            .font(.body)
                            .padding(.top, 5)
                    }
                    .padding()
                }
                .onAppear {
                    viewModel.getCommentsData(selected: movieId)
                }
            }
        }
        .navigationTitle("Yorumlar")
    }
}

extension Review: Identifiable { }

