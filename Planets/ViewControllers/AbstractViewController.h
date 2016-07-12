//
//  AbstractViewController.h
//  Planets
//
//  Created by Fedor Solovev on 26.04.16.
//  Copyright © 2016 FedorX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractViewController : UIViewController

- (nonnull NSString *)segueToAdd;

- (void)showAlertWithTitle:(nonnull NSString *)title andMessage:(nonnull NSString *)message;

- (void)addItemButton;

@end
