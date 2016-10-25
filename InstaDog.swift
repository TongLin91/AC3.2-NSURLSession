//
//  InstaDog.swift
//  AC3.2-InstaCats-2
//
//  Created by Tong Lin on 10/25/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation
/*
 {
 dog_id: "001",
 name: "Men's Wear Dog",
 instagram: "https://www.instagram.com/mensweardog/",
 imageName: "mens_wear_dog.jpg",
 stats: {
 followers: "283091",
 following: "269",
 posts: "518"
 }
 },
 */

struct InstaDog{
    let id: String
    let name: String
    let instagram: URL
    let imageName: String
    let follower: String
    let following: String
    let posts: String
    
    init(id: String, name: String, instagram: String, imageName: String, follower: String, following: String, posts: String ){
        self.id = id
        self.name = name
        self.instagram = URL(string: instagram)!
        self.imageName = imageName
        self.follower = follower
        self.following = following
        self.posts = posts
    }
    
    public var sayHello: String{
        return "Nice to me you, I'm \(self.name)"
    }
    
    public var detailForCell: String{
        return "Follower: " + self.follower + "  Following: " + self.following + "  Posts: " + self.posts
    }
    
}
