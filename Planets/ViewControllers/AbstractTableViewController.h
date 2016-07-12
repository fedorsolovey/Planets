//
//  AbstractTableViewController.h
//  Planets
//
//  Created by Fedor Solovev on 26.04.16.
//  Copyright © 2016 FedorX. All rights reserved.
//

#import "CustomBlocks.h"

@interface AbstractTableViewController : AbstractViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong, nonnull) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong, nonnull) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak, nullable) IBOutlet UITableView *dynamicTableView;

@property (nonatomic, readonly, nullable) NSFetchedResultsController *frc;

@property (weak, nonatomic, nullable) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong, nullable) NSString *searchString;

@property (nonatomic, strong, nullable) NSIndexPath *selectedIndexPath;


- (void)reloadTableView;

- (nonnull Class)cellClass;

- (nonnull id)itemAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)registerNib:(nonnull Class)theClass;

- (void)updateListFromLocal:(nullable LogicalResponseBlock)completionBlock;

- (nullable NSPredicate *)queryForLocalRequest;

@end
