--
-- CustomEntity 
-- CustomEntity lookup available in the system to store table name of all tables
--

declare @CreatedBy as [nvarchar](128)
set @CreatedBy = 'e7134470-9950-4e8f-a13f-789789a16a37'  -- default guid value, needs to use same hardcoded GUID value for all CreatedBy

-- create temp table and insert lookup values
declare @Values table (
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Alias] [nvarchar](100) NULL,
	[Description] [nvarchar](1000) NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSystemEntity] [bit] NOT NULL,
	[IsStrictEntity] [bit] NOT NULL
)
set nocount on

insert into @Values([Id], [Name], [Alias], [Description], [IsActive], [IsDeleted], [IsSystemEntity], [IsStrictEntity])
values 
	 (LOWER(NEWID()), 'ActionLog', 'ActionLog', 'ActionLog is a log table to keep track CUD actions.', 1, 0, 1, 0)		
	,(LOWER(NEWID()), 'AspNetRoleClaims', 'AspNetRoleClaims', '', 1, 0, 1, 0)
	,(LOWER(NEWID()), 'AspNetRoles', 'AspNetRoles', 'AspNetRoles table stores user roles in the system.', 1, 0, 1, 0)
	,(LOWER(NEWID()), 'AspNetUserClaims', 'AspNetUserClaims', '', 1, 0, 1, 0)
	,(LOWER(NEWID()), 'AspNetUserRoles', 'AspNetUserRoles', 'AspNetUserRoles table is an index table to build relationship between users and roles.', 1, 0, 1, 0)
	,(LOWER(NEWID()), 'AspNetUsers', 'AspNetUsers', 'AspNetUsers table stores AspNet Identity user details.', 1, 0, 1, 0)		
	,(LOWER(NEWID()), 'CustomEntity', 'CustomEntity', 'CustomEntity stores all entity/tables names.', 1, 0, 1, 0)	
	,(LOWER(NEWID()), 'DataType', 'DataType', 'DataType table stores datatypes used in system for custom fields.', 1, 0, 1, 0)	
	,(LOWER(NEWID()), 'RefreshToken', 'RefreshToken', 'To store refresh token value.', 1, 0, 1, 0)
	,(LOWER(NEWID()), 'SettingEmail', 'SettingEmail', 'SettingEmail stores email settings required for email threads.', 1, 0, 1, 0)
	,(LOWER(NEWID()), 'SettingSecurityToken', 'SettingSecurityToken', 'SettingSecurityToken is a settings table to store security tokens.', 1, 0, 1, 0)	
	,(LOWER(NEWID()), 'User', 'User', 'User table stores all kind of user details.', 1, 0, 1, 0)	
	,(LOWER(NEWID()), 'DatabaseVersion', 'DatabaseVersion', 'Version table stores version history of the system/software.', 1, 0, 1, 0)
	,(LOWER(NEWID()), 'SignIn', 'SignIn', 'SignIn is not a system entity. SignIn is an action and this action (signed in email) must be logged in the system.', 1, 0, 0, 0)
	,(LOWER(NEWID()), 'SignUp', 'SignUp', 'SignUp is not a system entity. SignUp is an action and this action (email) must be logged in the system.', 1, 0, 0, 0)
	,(LOWER(NEWID()), 'RoleSelection', 'RoleSelection', 'RoleSelection is not a system entity. RoleSelection is an action and this action (email and selected role) must be logged in the system.', 1, 0, 0, 0)
	,(LOWER(NEWID()), 'EmailConfirmationForSignUp', 'EmailConfirmationForSignUp', 'EmailConfirmationForSignUp is not a system entity. EmailConfirmationForSignUp is an action of the user who confirmed sign up email so this action must be logged in the system.', 1, 0, 0, 0)
	,(LOWER(NEWID()), 'ForgotPassword', 'ForgotPassword', 'ForgotPassword is not a system entity. ForgotPassword is an action of the user who starts this action when he/she forgot his/her password so this action must be logged in the system.', 1, 0, 0, 0)
	,(LOWER(NEWID()), 'ResetPassword', 'ResetPassword', 'ResetPassword is not a system entity. ResetPassword is an action of the user who takes this action when he/she is able to set a new password for their account so this action must be logged in the system.', 1, 0, 0, 0)
	,(LOWER(NEWID()), 'SignOut', 'SignOut', 'SignOut is not a system entity. SignOut is an action of the user who signs out from the system so this action must be logged in the system.', 1, 0, 0, 0)
set nocount off


-- add non-existing values
insert into CustomEntity ([Id], [DefaultEntityName], [DisplayEntityName], [Description], [IsActive], [IsDeleted], [IsSystemEntity], [IsStrictEntity], [Created])  
select distinct [Id], [Name], [Alias], [Description], [IsActive], [IsDeleted], [IsSystemEntity], [IsStrictEntity], SYSDATETIMEOFFSET()
from @Values newValues
where
	not exists (
		select [DefaultEntityName]
		from CustomEntity existingValues
        where existingValues.[DefaultEntityName] = newValues.[Name])


-- delete legacy records
delete from ActionLog where 
CustomEntityId in 
(select Id from CustomEntity where
DefaultEntityName in ('CurriculumQuestion', 
'CurriculumQuestionsGroup', 
'QuestionsGroup', 
'QuestionsGroupQuestion', 
'UserAssignedQuestionsGroup',
'UserProfile'))

delete from CustomEntity 
where DefaultEntityName in ('CurriculumQuestion', 
'CurriculumQuestionsGroup', 
'QuestionsGroup', 
'QuestionsGroupQuestion', 
'UserAssignedQuestionsGroup',
'EntityAssignment', 
'UserProfile')

UPDATE CustomEntity SET [Id] = LOWER([Id])

-- ** Leave this section commented because this can create duplicate log records and these system default values not required to be logged **
-- log the above create new values in the ActionLog table
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'ActionLog'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Activity'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'ArchiveUsers'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'AspNetRoleClaims'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'AspNetRoles'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'AspNetUserClaims'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'AspNetUserLogins'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'AspNetUserRoles'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'AspNetUsers'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'AspNetUserTokens'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Attendance'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Category'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Certificate'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'CertificateItem'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Currency'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Curriculum'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'CurriculumCategory'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'CurriculumDelivery'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'CurriculumEnrolment'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'CurriculumHierarchy'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'CurriculumQuestion'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'CurriculumQuestionsGroup'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'CurriculumType'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'CustomEntity'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'CustomField'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'CustomFieldValidator'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'DataType'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Discount'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'ElearningProgress'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'EmailLog'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'EmailLogEntityType'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Enquire'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Enrolment'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'EnrolmentWithdraw'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Feedback'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'FeedbackPriority'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'FeedbackProgress'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'FeedbackType'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Invoice'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'InvoiceEnrolment'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'InvoiceItem'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'InvoiceItemStandard'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'InvoicePayment'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'InvoiceStatus'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Location'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'LookupTitle'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Mode'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'PriceType'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Question'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'QuestionAnswer'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'QuestionResponse'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'QuestionsGroup'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'QuestionsGroupQuestion'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'QuestionType'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Resource'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'ResourceType'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Schedule'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'SettingEmail'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'SettingSecurityToken'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Status'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'StorageAccessByCurriculum'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'StorageAccessByRole'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'StorageAccessByUser'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'StorageAndWebResource'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'StorageAndWebResourceType'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Template'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'TemplateType'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'TrainingPlan'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'TrainingPlanItem'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'TrainingPlanTrainingMethod'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'User'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'UserAssignedQuestionsGroup'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'UserProfile'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)
--insert into ActionLog (Id, EntityId, ActionTypeId, ActionDateTime, ActionedBy, ActionReason, IsActive, IsDeleted)
--values (LOWER(NEWID()), (select top(1) Id from CustomEntity where DefaultEntityName = 'Version'), 1, GETDATE(), @CreatedBy, 'lookup data is created for the first time.', 1, 0)