---
title: "CodeBook"
author: "Ronit Rudra"
date: "Saturday, April 25, 2015"
---

####This codebook contains information about the [run_analysis.R](https://github.com/RonitRudra/Getting-and-Cleaning-Data/blob/master/run_analysis.R) script file:
<ul>
<li>Script_Walkthrough</li>
<li>Variables</li>
</ul>

####__*Script Walkthrough*__####
1. Step 1: The training and test datasets (data,labels,subjects) are read separately
using the `read.table()` function. The folllowing tables are created:
    + `data_test`(2947x561) read from `X_test.txt`
    + `label_test`(2947x1) read from `y_test.txt`
    + `subject_test`(2947x1) read from `subject_test.txt`
    + `data_train`(7352x561) read from `X_train.txt`
    + `label_train`(7352x1) read from `y_train.txt`
    + `subject_train`(7352x1) read from `subject_train.txt`

2. Step 2: The corresponding training and test tables are merged using `rbind()` function to create the following merged datasets:
    + `data`(10299x561)
    + `labels`(10299x1)
    + `subjects`(10299x1)
    
3. Step 3: Extract columns of `data` which have Mean and Standard Deviation in the `features.txt` file. `grep()` is used to extract rows of `data` by matching the pattern `mean()` or `std()` from `features`

```{r}
features <- read.table("features.txt")
data <- data[,grep(pattern="(mean|std)\\(\\)",features$V2)]
```

4. Step 4: The datasets, namely `data`,`labels` and `subjects` are given easily recognizable column names. Given below is a sample:

```{r}
> names(data)
 [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"          
 [3] "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"           
 [5] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"           
 [7] "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
 [9] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"
```
```{r} 
> names(labels)
[1] "Activity.Performed"
```
```{r}
> names(subjects)
[1] "Subject"
```

5. Step 5: The above datasets are merged into a single dataset using the `cbind()` function. The columns are appended to create a single data frame.

```{r}
> final_data <- cbind(subjects,labels,data)
> str(final_data)
'data.frame':  10299 obs. of  68 variables:
 $ Subject                    : int  2 2 2 2 2 2 2 2 2 2 ...
 $ Activity.Performed         : Factor w/ 6 levels "LAYING","SITTING",..: 3 3 3 3 3 3 3 3 3 3 ...
 $ tBodyAcc-mean()-X          : num  0.257 0.286 0.275 0.27 0.275 ...
 $ tBodyAcc-mean()-Y          : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
 $ tBodyAcc-mean()-Z          : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
```

6. Step 6: A separate tidy dataset is created using the above dataset which has all the values data values averaged according to the subject as well as activity. The `ddply()` function of `plyr` package is used to apply `mean()` to each column after splitting the dataset by `Subject` then by `Activity.Performed`.
The output is a text file `Avg_Tidy_Data.txt`.

```{r}
> str(avg_tidy_data)
'data.frame':  180 obs. of  68 variables:
 $ Subject                    : int  1 1 1 1 1 1 2 2 2 2 ...
 $ Activity.Performed         : Factor w/ 6 levels "LAYING","SITTING",..: 1 2 3 4 5 6 1 2 3 4 ...
 $ tBodyAcc-mean()-X          : num  0.222 0.261 0.279 0.277 0.289 ...
 $ tBodyAcc-mean()-Y          : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
 $ tBodyAcc-mean()-Z          : num  -0.113 -0.105 -0.111 -0.111 -0.108 ...
```

####__*Variables*__#####
This section tabulates the data objects and column variables used in the script.

The table below describes the objects in the script:

Object Name | Dimensions | Class | Description
------------- | ---------- | ----- | -----------
`data_test` | 2947 x 561 | data.frame | Data of testing set
`label_test` | 2947 x 1 | data.frame | Labels of testing set
`subject_test` | 2947 x 1 | data.frame | Subjects of testing set
`data_train` | 7352 x 561 | data.frame | Data of training set
`label_train` | 7352 x 1 | data.frame | Labels of training set
`subject_train` | 7352 x 1 | data.frame | Subjects of training set
`data` | 10299 x 561 | data.frame | merged data of training and testing set
`labels` | 10299 x 1 | data.frame | merged labels of training and testing set
`subjects` | 10299 x 1 | data.frame | merged subjects of training and testing set
`features` | 561 X 2 | data.frame | data frame maps columns of `data` to recognizable names
`data` | 10299 x 66 | data.frame | New data frame after subsetting only mean and SD columns
`final_data` | 10299 x 68 | data.frame | Single table of data, labels and subjects
`avg_tidy_data` | 180 x 68 | data.frame | tidy dataset after performing average of data

The tables below describe the column variables of the tidy data set:

  * Column 1-__Subject__ : A numeric identifier from 1-30 which corresponds to the subject whose data has been recorded for different activities
  * Column 2-__Activity.Performed__ : A string identifying one of the six activities performed by the subjects. It has 6 levels namely:
    + WALKING
    + WALKING_UPSTAIRS
    + WALKING_DOWNSTAIRS
    + SITTING
    + STANDING
    + LAYING
  
  * Column 3 to 68 : These columns contain mean of the numeric data for each of the initially measured sensor data. The mean is calculated per subject per activity. The nomenclature is defined as below:
    + Leading lowercase letter defines `t` for time domain and `f` for frequency domain
    + Subsequently `BodyAcc` defines acceleration of the body after subtracting gravity and `GravityAcc` defines total acceleration of the sensor whose units are in metres/second squared. `Gyro` defines angular velocity of sensor in radians/sec.
    + `X`, `Y`, `Z` define vector in cartesian coordinates.

  
