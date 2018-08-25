//
//  Restaurant.h
//  Restaurants
//
//  Created by anthony volkov on 7/27/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logoFilePath;
@property (nonatomic, assign) BOOL isFavorite;

@end
