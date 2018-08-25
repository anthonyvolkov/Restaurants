//
//  RestaurantDAO.m
//  Restaurants
//
//  Created by anthony volkov on 7/27/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import "RestaurantDAO.h"
#import "sqlite3.h"
#import "SQLManager.h"

@implementation RestaurantDAO

- (NSMutableArray<Restaurant *> *)getAllRestaurants {
    
    NSString *sql = @"SELECT * FROM `ch_restaurant`";
    NSArray *results = [SQLManager.sharedManager selectMultipleRows:sql];
    
    NSMutableArray *restaurants = [[NSMutableArray alloc] init];
    
    if (results) {
        for (NSDictionary *restaurantItem in results) {
            Restaurant *restaurant = [[Restaurant alloc] init];
            
            NSDictionary *idRestaurantAndLogoFilePath = [self getAllLogosFilePath];
            
            restaurant.id = ((NSString *)restaurantItem[@"id"]).intValue;
            restaurant.name = restaurantItem[@"name"];
            restaurant.logoFilePath = [idRestaurantAndLogoFilePath objectForKey:restaurantItem[@"id"]];
            
            if (((NSString *)restaurantItem[@"isFavorites"]).intValue == 0) {
                restaurant.isFavorite = false;
            } else {
                restaurant.isFavorite = true;
            }
            
            [restaurants addObject:restaurant];
        }
    }
    
    return restaurants;
}

- (NSArray<Restaurant *> *)getFavoritesRestaurants {
    
    NSString *sql = @"SELECT * FROM `ch_restaurant` WHERE isFavorites = 1";
    NSArray *results = [SQLManager.sharedManager selectMultipleRows:sql];
    
    NSMutableArray *favoritesRestaurants = [[NSMutableArray alloc] init];
    
    if (results) {
        for (NSDictionary *restaurantItem in results) {
            Restaurant *restaurant = [[Restaurant alloc] init];
            
            NSDictionary *idRestaurantAndLogoFilePath = [self getAllLogosFilePath];
            
            restaurant.id = ((NSString *)restaurantItem[@"id"]).intValue;
            restaurant.name = restaurantItem[@"name"];
            restaurant.logoFilePath = [idRestaurantAndLogoFilePath objectForKey:restaurantItem[@"id"]];
            
            if (((NSString *)restaurantItem[@"isFavorites"]).intValue == 0) {
                restaurant.isFavorite = false;
            } else {
                restaurant.isFavorite = true;
            }
            
            [favoritesRestaurants addObject:restaurant];
        }
    }
    
    return favoritesRestaurants;
}


- (void)changeFavoriteStatus:(Restaurant *)restaurant {
    
    [self playAddOrRemoveFavoritesSound];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE 'ch_restaurant' SET isFavorites = %d WHERE id = %d", restaurant.isFavorite ? 0 : 1, restaurant.id];
    [SQLManager.sharedManager updateRow:sql];
}


- (NSDictionary *) getAllLogosFilePath {
    
    NSString *sql = @"SELECT * FROM `ch_restaurant_logo`";
    NSArray *results = [SQLManager.sharedManager selectMultipleRows:sql];
    
    NSMutableDictionary *idRestaurantAndLogoFilePath = [[NSMutableDictionary alloc] init];
    
    if (results) {
        for (NSDictionary *restaurantItem in results) {
            [idRestaurantAndLogoFilePath setObject:restaurantItem[@"file_path"] forKey:restaurantItem[@"restaurant_id"]];
        }
    }
    
    return idRestaurantAndLogoFilePath;
}

- (void)playAddOrRemoveFavoritesSound {
    
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    
    CFURLRef soundFileURLRef;
    soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (CFStringRef) @"Fav",CFSTR ("wav"), NULL);
    
    UInt32 sound;
    AudioServicesCreateSystemSoundID(soundFileURLRef, &sound);
    AudioServicesPlaySystemSound(sound);
}

@end
