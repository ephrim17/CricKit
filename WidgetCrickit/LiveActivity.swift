//
//  LiveActivity.swift
//  WidgetCrickitExtension
//
//  Created by  Ephrim Daniel J on 05/09/23.
//

import Foundation
import WidgetKit
import ActivityKit
import SwiftUI

struct LiveScoreActivityAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable{
        var endTime: Date
        var liveScoreModel: LiveScoreCardModel
        enum CodingKeys: String, CodingKey {
            case liveScoreModel = "liveScoreModel"
            case endTime = "endTime"
        }
    }

    var matchName: String
}


struct CrickitLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveScoreActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            LiveScoreCardViewForIntent(liveScoreCardData: context.state.liveScoreModel)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("")
                    // more content
                }
            } compactLeading: {
                Text("")
            } compactTrailing: {
                Text("")
            } minimal: {
                Text("")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
