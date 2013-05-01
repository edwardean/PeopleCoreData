//
//  AddPersonViewController.h
//  People
//
//  Created by Edward on 13-5-1.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AddPersonViewController : UIViewController

@property (strong, nonatomic) UITextField *textFieldFirstName;
@property (strong, nonatomic) UITextField *textFieldLastName;
@property (strong, nonatomic) UITextField *textFieldAge;
@property (strong, nonatomic) UIBarButtonItem *barButtonAdd;
@end
