//
//  AbstractEntity+CoreDataProperties.h
//  SON
//
//  Created by Pavel Zhuravlev on 08.12.15.
//  Copyright © 2015 Digipeople. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AbstractEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface AbstractEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *pk;
@property (nullable, nonatomic, retain) NSDate *updatedAt;

@end

NS_ASSUME_NONNULL_END
