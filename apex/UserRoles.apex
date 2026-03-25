UserRole president = new UserRole(Name='President');
insert president;
User adminUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
adminUser.UserRoleId = president.Id;
update adminUser;