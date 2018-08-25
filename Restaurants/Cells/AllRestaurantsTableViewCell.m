//
//  AllRestaurantsTableViewCell.m
//  Restaurants
//
//  Created by anthony volkov on 8/9/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import "AllRestaurantsTableViewCell.h"

@implementation AllRestaurantsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.logo.image = nil;
    self.name.text = @"";
    self.favorite.image = nil;
}

- (void)configureCellWithRestaurant:(Restaurant *)restaurant {
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 44, 44)];
    self.logo = logoView;
    self.logo.image = [UIImage imageNamed:restaurant.logoFilePath];
    [self addSubview:self.logo];

    UILabel *nameRestaurant = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 230, 44)];
    self.name = nameRestaurant;
    self.name.text = restaurant.name;
    [self addSubview:self.name];

    UIImageView *favoriteView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 7.5, 30, 30)];
    self.favorite = favoriteView;
    self.favorite.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", restaurant.isFavorite ? @"favorite" : @"unfavorite"]];
    [self addSubview:self.favorite];
    
}

- (void)changeRestaurantFavoriteStatus:(Restaurant *)restaurant {
    self.favorite.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", restaurant.isFavorite ? @"favorite" : @"unfavorite"]];
}

@end
