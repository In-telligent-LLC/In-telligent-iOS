//
//  HeroImage.swift
//  Intelligent
//
//  Created by Kurt on 10/11/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import UIKit

public class HeroImage {
    
    static public let imageNames: [String] = [
        "hero_business_suit_guy",
        "hero_closeup_phone",
        "hero_couple_looking_at_tablet",
        "hero_elevator_women",
        "hero_guy_glasses_and_tablet",
        "hero_guy_with_glasses",
        "hero_lobby_guy",
        "hero_man_leaning_on_wall",
        "hero_man_on_bike",
        "hero_women_in_white_dress",
        "hero_women_looking_down",
        "hero_women_outside_on_wall",
        "hero_women_plus_coffee_cup",
        "hero_women_striped_dress",
        "hero_arm_at_baseball_game",
        "hero_blonde_girl_in_class",
        "hero_girl_in_pink_sweater",
        "hero_kid_sitting_with_backpack",
        "hero_man_at_convention",
        "hero_man_with_glasses",
        "hero_sitting_with_books",
        "hero_two_girls_at_football_game",
        "hero_two_girls_looking_at_phone",
        "hero_woman_in_library"
    ]
    
    static public func buildingImage(_ buildingId: Int) -> UIImage? {
        guard let imageName = imageNames[safe: buildingId % imageNames.count] else { return nil }
        
        return UIImage(named: imageName)
    }
    
}
