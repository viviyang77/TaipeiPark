//
//  AttractionData.h
//  TaipeiPark
//
//  Created by Vivi on 11/07/2017.
//  Copyright © 2017 Vivi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttractionData : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *parkName;
@property (strong, nonatomic) NSString *introduction;
@property (strong, nonatomic) NSString *imageName;

- (id)initWithName:(NSString *)name parkName:(NSString *)parkName introduction:(NSString *)introduction imageName:(NSString *)imageName;

@end
