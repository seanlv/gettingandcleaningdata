library("dplyr")

# 1. 整合培训和测试集，创建一个数据集。
subject_train <- read.table("data/train/subject_train.txt")
x_train <- read.table("data/train/X_train.txt")
y_train <- read.table("data/train/y_train.txt")
train_set <- cbind(subject_train, y_train, x_train)

subject_test <- read.table("data/test/subject_test.txt")
x_test <- read.table("data/test/X_test.txt")
y_test <- read.table("data/test/y_test.txt")
test_set <- cbind(subject_test, y_test, x_test)

combined_set <- rbind(train_set, test_set)

# 2. 仅提取测量的平均值以及每次测量的标准差。
feature_names <- read.table("data/features.txt", stringsAsFactors = F)
mean_std_column_idx <- grep("(mean|std)\\(", feature_names$V2)
combined_mean_std_set <- combined_set[, c(1, 2, mean_std_column_idx + 2)]

# 3. 使用描述性活动名称命名数据集中的活动。
activity_labels <- read.table("data/activity_labels.txt")
combined_mean_std_set$V1.1 <- activity_labels$V2[combined_mean_std_set$V1.1]

# 4. 使用描述性变量名称恰当标记数据集。
colnames(combined_mean_std_set) <- c("Subject", "Activity", feature_names$V2[mean_std_column_idx])

# 5. 从第4步的数据集中，针对每个活动和每个主题使用每个表里的平均值建立第2个独立的整洁数据集。
tidy <- combined_mean_std_set %>% group_by(Subject, Activity) %>% summarise_each(funs(mean))
colnames(tidy)<-c("Subject", "Activity", paste("Mean of", feature_names$V2[mean_std_column_idx]))

# 生成文件
write.table(tidy, "tidy.txt", sep = ",", row.name = F)