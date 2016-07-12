//
//  PlanetCell.m
//  Planets
//
//  Created by Fedor Solovev on 30.04.16.
//  Copyright © 2016 FedorX. All rights reserved.
//

#import "PlanetCell.h"

@interface PlanetCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation PlanetCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

+ (CGFloat)heightCell
{
    return 50;
}

- (void)configWithModel:(PlanetsEntity *)model
{
    self.numberLabel.text = model.number.stringValue;
    self.nameLabel.text = model.pk;
}

@end
