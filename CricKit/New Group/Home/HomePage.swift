//
//  HomePage.swift
//  CricKit
//
//  Created by ephrim.daniel on 26/07/23.
//

import SwiftUI

struct HomePage: View {
    @State var selectedIndex = 0
    
    @ObservedObject var liveScoreCardViewModel = LiveScoreCardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBlacks
                    .clipShape(BackgroundCard())
                VStack(spacing: 0) {
                    HStack {
                        Text("CricKit")
                            .padding()
                            .fontWidth(.expanded)
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.appPrimary)
                        Spacer()
                    }
                    
                    switch selectedIndex {
                    case 0:
                        HomeBoard(liveScoreCardViewModel: liveScoreCardViewModel)
                    case 1:
                        ShopPage()
                    default:
                        UserProfilePage()
                    }
                    
                    VStack() {
                        HStack (alignment: .center, spacing: 30) {
                            customTabBar(selectedIndex: $selectedIndex)
                        }
                        .padding(.top, 16)
                        .padding(.bottom, -20)
                        
                    }
                    Spacer()
                }
            }.background(Color.linearColor)
                .navigationBarBackButtonHidden(true)
        }
    }
    init() {
        liveScoreCardViewModel.getLiveScore()
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

struct HomeBoard: View {
    
    @StateObject var sectionProgress = HomeSection()
    @ObservedObject var liveScoreCardViewModel: LiveScoreCardViewModel
    
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack{
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    if liveScoreCardViewModel.isLoading {
                        LiveScoreCardShimmerView(width: width - 32)
                            .offset(x: 16)
                    } else {
                        ForEach(Array(liveScoreCardViewModel.liveScoreCardlists.enumerated()), id: \.element.id) { index, liveScoreItem in
                            LiveScoreCardView(liveScoreCardData: liveScoreItem)
                                .frame(width: width - 32, height: 200)
                                .clipShape(LiveMatchCard())
                                .background(Blur(style: .systemChromeMaterialDark))
                                .clipShape(LiveMatchCard())
                                .cornerRadius(10, corners: .allCorners)
                                .padding(.trailing, index == liveScoreCardViewModel.liveScoreCardlists.count - 1 ? 30: 0)
                        }
                        .offset(x: 16)
                    }
                    
                }
            }
            HomeSections(sectionProgress: sectionProgress)
                .frame(width: width)
                .padding(.top, 5)
                .padding(.bottom, 5)
            ScrollView(showsIndicators: false) {
                VStack(spacing: -20) {
                    HomeSectionSwitches(sectionProgress: sectionProgress)
                        .frame(width: UIScreen.main.bounds.width)
                }
                .padding(.bottom, 10)
            }
            
            .shadow(radius: 5)
        }
    }
}

struct HomeSectionSwitches: View {
    let categoryDataImages: [String] = ["playerVirat", "playerJoeRoot", "playerBabar", "playerSteveSmith", "playerKaneWill"]
    
    @StateObject var recentMatchesViewModel = RecentMatchesViewModel()
    @StateObject var upComingMatchesViewModel = UpComingMatchViewModel()
    @StateObject var featuredPlayersViewModel = FeaturedPlayersViewModel()
    @StateObject var sectionProgress = HomeSection()
    
    var width = UIScreen.main.bounds.width - 32
    
    var body: some View {
        VStack(spacing: 10) {
            if (sectionProgress.index == 0) {
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        ForEach(recentMatchesViewModel.recentMatches, id: \.self) { recentMatch in
                            RecentMatchView(recentMatchModel: recentMatch)
                                .frame(width: width, height: 120)
                                .clipShape(LiveMatchCard())
                                .background(Blur(style: .systemChromeMaterialDark))
                                .clipShape(LiveMatchCard())
                                .cornerRadius(10, corners: .allCorners)
                        }
                    }
                }
            } else if (sectionProgress.index == 1) {
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        ForEach(upComingMatchesViewModel.upComingMatches, id: \.self) { upComingMatch in
                            UpComingMatchesView(upComingMatchModel: upComingMatch)
                                .frame(width: width, height: 120)
                                .clipShape(LiveMatchCard())
                                .background(Blur(style: .systemChromeMaterialDark))
                                .clipShape(LiveMatchCard())
                                .cornerRadius(10, corners: .allCorners)
                        }
                    }
                }
            } else if (sectionProgress.index == 2) {
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
						ForEach(Array(featuredPlayersViewModel.featuredPlayers.enumerated()), id: \.element.id) { index, featuredPlayer in
							FeaturedPlayersSectionView(featuredPlayer: featuredPlayer, playerImage: categoryDataImages[index])
                                .background(Blur(style: .systemChromeMaterialDark))
								.clipShape(LiveMatchCard())
                                .cornerRadius(20, corners: .allCorners)
                        }
                    }
                }
            } else if (sectionProgress.index == 3) {
                CricketNews()
            } else if (sectionProgress.index == 4) {
                RankingCardView()
            }
            
        }
        .padding()
        .onAppear {
            recentMatchesViewModel.getRecentMatches()
            upComingMatchesViewModel.geUpComingMatches()
            featuredPlayersViewModel.getFeaturedPlayers()
        }
    }
}
