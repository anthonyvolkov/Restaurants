//
//  MenuDAO.h
//  Restaurants
//
//  Created by anthony volkov on 7/29/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"

@interface MenuDAO : NSObject

@property (nonatomic, assign) int restaurantID;

- (NSArray<MenuItem *> *) getMenu;

@end
