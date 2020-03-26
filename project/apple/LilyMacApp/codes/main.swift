//
//  main.swift
//  Lily
//
//  Created by kengo on 2015/04/04.
//  Copyright (c) 2017- Watanabe-DENKI Inc.
//

import Foundation
import LilySwift

autoreleasepool
{
    let app = Application.shared as! Application
    app.delegate = app
    app.setActivationPolicy( .regular )
    app.run()
}

exit(0)
