//
//  FavoritesViewController.m
//  Restaurants
//
//  Created by anthony volkov on 7/22/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import "FavoritesViewController.h"
#import "MenuViewController.h"
#import "Restaurant.h"
#import "RestaurantDAO.h"

static NSString * const favoritesCellIdentifier = @"favoritesCellIdentifier";

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSArray <Restaurant *> *dataSource;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Favorites";
    
    [self cofigureTableview];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateDataSource];
    [self.table reloadData];
}

- (void)cofigureTableview {
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                               self.view.bounds.origin.y,
                                                               self.view.bounds.size.width,
                                                               self.view.bounds.size.height - self.tabBarController.tabBar.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - 20)
                                              style:UITableViewStylePlain];;
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self.view addSubview:self.table];
}


- (void)updateDataSource {
    RestaurantDAO *restaurantDAO = [[RestaurantDAO alloc] init];
    self.dataSource = [restaurantDAO getFavoritesRestaurants];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    menuViewController.title = (self.dataSource[indexPath.row]).name;
    menuViewController.restaurant = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:menuViewController animated:true];
    
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){

    UIContextualAction *removeFromFavorites = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"remove" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        NSLog(@"remove from favs: %@", (self.dataSource[indexPath.row]).name);
        
        RestaurantDAO *restaurantDAO = [[RestaurantDAO alloc] init];
        
        [restaurantDAO changeFavoriteStatus:self.dataSource[indexPath.row]];
        [self updateDataSource];
        
        completionHandler(YES);
    }];

    removeFromFavorites.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:70.0/255.0 blue:73.0/255.0 alpha:1];
    removeFromFavorites.image = [UIImage imageNamed: @"removeFromFavorites"];

    return [UISwipeActionsConfiguration configurationWithActions:@[removeFromFavorites]];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:favoritesCellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:favoritesCellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:self.dataSource[indexPath.row].logoFilePath];
    cell.textLabel.text = self.dataSource[indexPath.row].name;
    
    return cell;
}


@end
