//
//  MenuViewController.m
//  Restaurants
//
//  Created by anthony volkov on 7/22/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import "MenuViewController.h"
#import "RestaurantDAO.h"
#import "MenuDAO.h"

static NSString * const menuCellIdentifier = @"menuCellIdentifier";

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *table;
@property (nonatomic) NSArray <MenuItem *> *dataSource;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabBarHiddenWithAnimation];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIBarButtonItem *buttonAddToFavorites = [[UIBarButtonItem alloc] initWithTitle:nil
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(addToFavorites:)];
    buttonAddToFavorites.image = [UIImage imageNamed:@"star.png"];
    if (self.restaurant.isFavorite) {
        buttonAddToFavorites.tintColor = [UIColor yellowColor];
    }else{
        buttonAddToFavorites.tintColor = [UIColor blackColor];
    }
    [self.navigationItem setRightBarButtonItem:buttonAddToFavorites];
    
    [self updateDataSource];
    [self cofigureTableview];
}

-(void) setTabBarHiddenWithAnimation {
    
    [UIView animateWithDuration:0.3f animations:^{
        self.tabBarController.tabBar.center = CGPointMake(self.tabBarController.tabBar.center.x,
                                                          self.view.bounds.size.height + self.tabBarController.tabBar.bounds.size.height / 2);
    } completion:^(BOOL finished) {
        [self.tabBarController.tabBar setHidden:true];
    }];
}

- (void)cofigureTableview {
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                               self.view.bounds.origin.y,
                                                               self.view.bounds.size.width,
                                                               self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - 20)
                                              style:UITableViewStylePlain];;
    self.table.delegate = self;
    self.table.dataSource = self;
    
    
    [self.view addSubview:self.table];
}


- (void)backToAllRestaurants:(id)sender {
    [self setTabBarHiddenWithAnimation];
    [self.navigationController popViewControllerAnimated:true];
}


- (void)addToFavorites:(id)sender {
    RestaurantDAO *restaurantDAO = [[RestaurantDAO alloc] init];
    
    if (self.restaurant.isFavorite) {
        [restaurantDAO changeFavoriteStatus:self.restaurant];
        self.restaurant.isFavorite = false;
        ((UIBarButtonItem *)sender).tintColor = [UIColor blackColor];
    } else {
        [restaurantDAO changeFavoriteStatus:self.restaurant];
        self.restaurant.isFavorite = true;
        ((UIBarButtonItem *)sender).tintColor = [UIColor yellowColor];
    }
}


- (void)updateDataSource {
    MenuDAO *menuDAO = [[MenuDAO alloc] init];
    menuDAO.restaurantID = self.restaurant.id;
    self.dataSource = [menuDAO getMenu];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"You have taped on %@", (self.dataSource[indexPath.row]).name);
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:menuCellIdentifier];

    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:menuCellIdentifier];
    }


    cell.textLabel.text = self.dataSource[indexPath.row].name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %d calories", self.dataSource[indexPath.row].serving, self.dataSource[indexPath.row].calories ];
    
    return cell;

}


@end
