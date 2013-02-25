//
//  StationDataCell.h
//  IrishRails
//
//  Created by Jaanus Siim on 2/25/13.
//  Copyright (c) 2013 JaanusSiim. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StationData;

@interface StationDataCell : UITableViewCell

- (void)configureWithData:(StationData *)data;

@end
