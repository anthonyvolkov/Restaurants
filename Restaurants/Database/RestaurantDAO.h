//
//  RestaurantDAO.h
//  Restaurants
//
//  Created by anthony volkov on 7/27/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import "AudioToolbox/AudioToolbox.h"
#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface RestaurantDAO : NSObject

- (NSMutableArray<Restaurant *> *) getAllRestaurants;
- (NSArray<Restaurant *> *) getFavoritesRestaurants;


- (void)changeFavoriteStatus:(Restaurant *)restaurant;
- (void)playAddOrRemoveFavoritesSound;

@end

