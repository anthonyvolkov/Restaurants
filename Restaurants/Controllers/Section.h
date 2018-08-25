//
//  Section.h
//  Restaurants
//
//  Created by anthony volkov on 8/16/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface Section : NSObject

@property (strong, nonatomic) NSString *sectionName;
@property (strong, nonatomic) NSMutableArray <Restaurant *> *itemsArray;

@end
