//
//  AllRestaurantsTableViewCell.h
//  Restaurants
//
//  Created by anthony volkov on 8/9/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface AllRestaurantsTableViewCell : UITableViewCell

@property (nonatomic, weak) UIImageView *logo;
@property (nonatomic, weak) UILabel *name;
@property (nonatomic, weak) UIImageView *favorite;

- (void)configureCellWithRestaurant:(Restaurant *)restaurant;
- (void)changeRestaurantFavoriteStatus:(Restaurant *)restaurant;

@end
