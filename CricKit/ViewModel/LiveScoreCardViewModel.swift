//
//  LiveScoreCardViewModel.swift
//  CricKit
//
//  Created by  Ephrim Daniel J on 23/08/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI

class LiveScoreCardViewModel : ObservableObject {
    
    @Published var liveScoreCardlists = [LiveScoreCardModel]()
    
    var teamStats : TeamStats? = nil
    var teamStatusArray = [TeamStats]()
    
    func getLiveScore() {
        let parentCollection = FSCollectionManager.getCollectionID(collection: .liveScore(subCollectionPath: .none))
            FbDataServiceManager.shared.getData(parentCollection: parentCollection) { [self] snapshot in
            if let snapshot = snapshot {
                self.liveScoreCardlists.removeAll()
                for doc in snapshot.documents{
                    let matchStatus = doc["matchStatus"] as? String ?? ""
                    let matchHeader = doc["matchHeader"] as? String ?? ""
                    let isLive = doc["isLive"] as? Bool ?? true
                    let teamsStatusDocumentID = doc.documentID
                    // accessing firestore sub-collection from document ID of parent Collection
                    let subCollection = FSCollectionManager.getCollectionID(collection: .liveScore(subCollectionPath: .teamStatus))
                    FbDataServiceManager.shared.getDataWithDocumentID(parentCollection: parentCollection, documentId: teamsStatusDocumentID, subCollection: subCollection) { snapshot in
                        if let snapshot = snapshot {
                            self.teamStatusArray.removeAll()
                            for doc in snapshot.documents {
                                let teamStats = TeamStats(name: doc["name"] as? String ?? "",
                                                          flag: doc["flag"] as? String ?? "",
                                                          overs: doc["overs"] as? String ?? "",
                                                          runs: doc["runs"] as? String ?? "",
                                                          wickets: doc["wickets"] as? String ?? "")
                                self.teamStatusArray.append(teamStats)
                            }
                            let liveScoreData = LiveScoreCardModel(matchStatus: matchStatus, matchHeader: matchHeader, isLive: isLive, TeamStatus:  self.teamStatusArray)
                            self.liveScoreCardlists.append(liveScoreData)
                        }
                    }
                }
            }
        }
    }
}


