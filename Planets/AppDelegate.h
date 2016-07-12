//
//  AppDelegate.h
//  Planets
//
//  Created by Fedor Solovev on 23.04.16.
//  Copyright © 2016 FedorX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong, nullable) LocalDatastoreService *localDatastore;

@property (strong, nonatomic, nonnull) UIWindow *window;

//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//
//- (void)saveContext;

//- (nullable NSURL *)applicationDocumentsDirectory;


@end

