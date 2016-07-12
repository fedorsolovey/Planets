//
//  ConfigurableCell.h
//  SON
//
//  Created by Pavel Zhuravlev on 08.12.15.
//  Copyright © 2015 Digipeople. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConfigurableCell <NSObject>

- (void)configWithModel:(nonnull id)model;

+ (nonnull NSString *)reuseIdentifier;

+ (CGFloat)heightCell;

@end
