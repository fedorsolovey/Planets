//
//  AbstractEntity+Management.m
//  SON
//
//  Created by Pavel Zhuravlev on 18.12.15.
//  Copyright © 2015 Digipeople. All rights reserved.
//

#import "AbstractEntity.h"

@implementation AbstractEntity (Management)

+ (nonnull instancetype)createByPk:(nonnull NSString*)pk inContext:(nonnull NSManagedObjectContext*)context
{
    AbstractEntity *model = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self)
                                                          inManagedObjectContext:context];
    model.pk = pk;
    model.createdAt = [NSDate date];
    model.updatedAt = [NSDate date];
    return model;
}

+ (nonnull instancetype)findOrCreateByPk:(nonnull NSString*)pk inContext:(nonnull NSManagedObjectContext*)context
{
    AbstractEntity *model = [self findByPk:pk inContext:context];
    if (model == nil)
        model = [self createByPk:pk inContext:context];
    return model;
}

+ (void)deleteByPk:(nonnull NSString*)pk inContext:(nonnull NSManagedObjectContext*)context
{
    AbstractEntity *entity = [self findByPk:pk inContext:context];
    if (entity)
        [context deleteObject:entity];
}

@end
