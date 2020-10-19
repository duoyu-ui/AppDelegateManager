//
//  PingModel.swift
//  NetworkLineDemo
//
//  Created by Tom on 2019/10/29.
//  Copyright © 2019 Tom. All rights reserved.
//

import HandyJSON

struct PingRouter: HandyJSON {
       var refresh: String?
       var domain: String?

}

struct PingModel: HandyJSON {
       var router: [PingRouter]?

}
