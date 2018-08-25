//
//  InitialViewController.m
//  Restaurants
//
//  Created by anthony volkov on 7/22/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import "InitialViewController.h"
#import "MenuViewController.h"
#import "RestaurantDAO.h"
#import "AllRestaurantsTableViewCell.h"
#import "Section.h"

static NSString * const kCellIdentifier = @"CellIdentifier";

@interface InitialViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchBarDelegate>

@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray <Restaurant *> *dataSource;
@property (strong, nonatomic) NSArray <Section *> *sectionsArray;
@property (strong, nonatomic) NSOperation *currentOperation;

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Restaurants";
    [self cofigureTableview];
}


- (void)viewWillAppear:(BOOL)animated {
    [self.table reloadData];
    [self updateDataSource];
}

- (void)cofigureTableview {
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                                self.view.bounds.origin.y,
                                                                self.view.bounds.size.width,
                                                                44)];
    self.searchBar.delegate = self;

    self.table = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                               self.view.bounds.origin.y,
                                                               self.view.bounds.size.width,
                                                               self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - self.tabBarController.tabBar.bounds.size.height - 20)
                                              style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.table.tableHeaderView = self.searchBar;
    
    [self.view addSubview:self.table];
    
}


- (void)updateDataSource {
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        __strong typeof(self)strongSelf = weakSelf;

        RestaurantDAO *restaurantDAO = [[RestaurantDAO alloc] init];
        strongSelf.dataSource = [restaurantDAO getAllRestaurants];

        __weak typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self)strongSelf = weakSelf;

            [strongSelf generateSectionsInBackgroundFromArray:self.dataSource withFilter:self.searchBar.text];
        });
    });
}


- (NSArray*) generateSectionsFromArray:(NSArray*) array withFilter:(NSString*) filterString {
    NSMutableArray* sectionsArray = [NSMutableArray array];
    
    NSString* currentLetter = nil;
    
    for (Restaurant *restaurant in self.dataSource) {
        
        if ((filterString.length > 0) && ([[[restaurant.name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""] rangeOfString:[filterString lowercaseString]].location == NSNotFound)) {
            continue;
        }
        
        NSString *firstLetter = [restaurant.name substringToIndex:1];
        
        
        Section *section = nil;
        
        if (![currentLetter isEqualToString:firstLetter]) {
            section = [[Section alloc] init];
            section.sectionName = firstLetter;
            section.itemsArray = [NSMutableArray array];
            [sectionsArray addObject:section];
            currentLetter = firstLetter;
        } else {
            section = [sectionsArray lastObject];
        }
        
        [section.itemsArray addObject:restaurant];
    }
    
    // remove header for "Drinks"
    if (sectionsArray.count > 0 && [[([sectionsArray[0] itemsArray])[0] name] isEqualToString:@"Drinks"]) {
        [sectionsArray[0] setSectionName:@""];
    }
    
    return sectionsArray;
}


- (void) generateSectionsInBackgroundFromArray:(NSArray*) array withFilter:(NSString*) filterString {
    
    if (self.currentOperation) {
        [self.currentOperation cancel];
    }
    
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    
    __weak typeof(self)weakSelf = self;
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        __strong typeof(self)strongSelf = weakSelf;
        
        NSArray* sectionsArray = [strongSelf generateSectionsFromArray:array withFilter:filterString];
        
        __weak typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self)strongSelf = weakSelf;
            
            strongSelf.sectionsArray = sectionsArray;
            [strongSelf.table reloadData];
            
            strongSelf.currentOperation = nil;
        });
    }];
    
    [backgroundQueue addOperation:self.currentOperation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Section* section = [self.sectionsArray objectAtIndex:indexPath.section];
    
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    menuViewController.title = section.itemsArray[indexPath.row].name;
    menuViewController.restaurant = section.itemsArray[indexPath.row];
    
    [self.navigationController pushViewController:menuViewController animated:true];
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1];
}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    
    NSString *title;
    UIColor *color;
    BOOL value;
    
    Section* section = [self.sectionsArray objectAtIndex:indexPath.section];

    if (section.itemsArray[indexPath.row].isFavorite) {
        title = @"remove from favorites";
        color = [UIColor colorWithRed:211.0/255.0 green:70.0/255.0 blue:73.0/255.0 alpha:1];
        value = false;
    } else {
        title = @"add to favorites";
        color = [UIColor colorWithRed:10/255.f green:66/255.f blue:145/255.f alpha:1];
        value = true;
    }

    UIContextualAction *changeFavoriteStatus = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:title handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

        RestaurantDAO *restaurantDAO = [[RestaurantDAO alloc] init];

        [restaurantDAO changeFavoriteStatus:section.itemsArray[indexPath.row]];
        section.itemsArray[indexPath.row].isFavorite = value;
        
        [self performSelector:@selector(updateDataSource) withObject:nil afterDelay:0.5f];
        
        AllRestaurantsTableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
        [cell changeRestaurantFavoriteStatus:section.itemsArray[indexPath.row]];
        
        completionHandler(YES);
    }];
    
    changeFavoriteStatus.backgroundColor = color;
    
    return [UISwipeActionsConfiguration configurationWithActions:@[changeFavoriteStatus]];
}


#pragma mark - UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (Section* section in self.sectionsArray) {
        [array addObject:section.sectionName];
    }
    
    return array;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionsArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [[self.sectionsArray objectAtIndex:section] sectionName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionsArray objectAtIndex:section].itemsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllRestaurantsTableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(cell == nil) {
        cell = [[AllRestaurantsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    Section* section = [self.sectionsArray objectAtIndex:indexPath.section];
    
    [cell configureCellWithRestaurant:section.itemsArray[indexPath.row]];
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    
    searchBar.text = @"";
    
    [self generateSectionsInBackgroundFromArray:self.dataSource withFilter:self.searchBar.text];
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSLog(@"textDidChange %@", searchText);
    [self generateSectionsInBackgroundFromArray:self.dataSource withFilter:self.searchBar.text];
    
}


@end
