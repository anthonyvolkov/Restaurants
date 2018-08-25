//
//  MenuItem.h
//  Restaurants
//
//  Created by anthony volkov on 7/29/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *serving;
@property (nonatomic, assign) int calories;

@end
