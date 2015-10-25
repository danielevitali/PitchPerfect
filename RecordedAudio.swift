//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Daniele Vitali on 15/10/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    var filePathUrl: NSURL
    var title: String
    
    init(title: String, filePathUrl: NSURL) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
    
}