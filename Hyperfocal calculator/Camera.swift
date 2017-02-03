//
//  Camera.swift
//  Hyperfocal calculator
//
//  Created by Loic Sillere on 03/02/2017.
//  Copyright © 2017 Loic Sillere. All rights reserved.
//

import Foundation

class Camera {
    var name: String // interval in second between 2 pictures taken
    var cercleDeConfusion: Double
    
    // Get var values from userdefault or set default values
    init(name: String, cercleDeConfusion: Double) {
        self.name = name
        self.cercleDeConfusion = cercleDeConfusion
    }
}
