//
//  TreeViewNode.h
//  The Projects
//
//  Created by Ahmed Karim on 1/12/13.
//  Copyright (c) 2013 Ahmed Karim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeViewNode : NSObject

@property (nonatomic) NSUInteger nodeLevel;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic, strong) id nodeObject;
@property (nonatomic, strong) NSMutableArray *nodeChildren;
@property (nonatomic, strong) NSString* beeid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSString * content_no;
@property (nonatomic) NSNumber* imageid;
@property (nonatomic) NSNumber* like;
@property (nonatomic) NSNumber* happy;
@property (nonatomic) NSNumber* sad;
@property (nonatomic) NSNumber* cool;
@property (nonatomic) NSNumber* impish;
@property (nonatomic) NSNumber* oho;
@property (nonatomic) NSString* Typetag;
@property (nonatomic, strong) NSData * imagedate;
@end
