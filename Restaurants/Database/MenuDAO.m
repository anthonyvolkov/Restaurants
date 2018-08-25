//
//  MenuDAO.m
//  Restaurants
//
//  Created by anthony volkov on 7/29/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import "MenuDAO.h"
#import "sqlite3.h"
#import "SQLManager.h"

@implementation MenuDAO

- (NSArray<MenuItem *> *) getMenu {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM `ch_item` WHERE restaurant_id = %d", self.restaurantID];
    NSArray *results = [SQLManager.sharedManager selectMultipleRows:sql];
    
    NSMutableArray *menu = [[NSMutableArray alloc] init];
    
    if (results) {
        for (NSDictionary *item in results) {
            MenuItem *menuItem = [[MenuItem alloc] init];
            
            menuItem.id = ((NSString *)item[@"id"]).intValue;
            menuItem.name = item[@"name"];
            menuItem.serving = item[@"serving"];
            menuItem.calories = ((NSString *)item[@"calories"]).intValue;
            
            [menu addObject:menuItem];
        }
    }
    
    return [self sortedMenu:menu];
}

- (NSArray *)sortedMenu:(NSMutableArray *)menu{
    
    NSArray *sortedMenu = [menu sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [((MenuItem *)obj1).name compare:((MenuItem *)obj2).name];
    }];
    
    return sortedMenu;
}

@end
