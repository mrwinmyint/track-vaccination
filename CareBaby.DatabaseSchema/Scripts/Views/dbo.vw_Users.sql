--
-- View of Users (students, trainers, corporates, administrators).
-- * OData 4 does not support DateTime. These have been cast to DateTimeOffset.
--

if object_id('vw_Users', 'V') is not null
begin
	drop view vw_Users
	print 'Dropped view vw_Users'	
end
go

create view [dbo].[vw_Users]
as
--	-- create a temporary table in a View and drop it after select
---- https://stackoverflow.com/questions/8256466/is-it-possible-to-create-a-temporary-table-in-a-view-and-drop-it-after-select
---- SQL SELECT TOP 1 FOR EACH GROUP
---- https://stackoverflow.com/questions/28722276/sql-select-top-1-for-each-group/28727802
---- multiple entries for Updates (actiontypeid = 3) and want to retrieve the last entry for each unique EntityUniqueId and ActionTypeId
--WITH TempAction (Id, EntityId, EntityUniqueId, ActionTypeId, Email, SignedInRole, Actioned, ActionedById, ActionedByName)
--      AS
--      (SELECT TOP 1 WITH TIES 
--		actLog.Id, 
--		actLog.EntityId, 
--		actLog.EntityUniqueId, 
--		actLog.ActionTypeId,
--		actLog.Email, 
--		actLog.SignedInRole, 
--		actLog.ActionDateTime, 
--		actLog.ActionedBy, 
--		COALESCE(actLog.Email, u.FirstName + ' ' + u.LastName)		
--		FROM ActionLog actLog INNER JOIN
--		CustomEntity custEntity on actLog.EntityId = custEntity.Id LEFT JOIN
--		[User] u on actLog.ActionedBy = u.Id
--		WHERE 
--		custEntity.DefaultEntityName = 'user'
--		ORDER BY
--		ROW_NUMBER() OVER(PARTITION BY actLog.EntityUniqueId, actLog.ActionTypeId ORDER BY actLog.[ActionDateTime] DESC)
--	  )


select distinct
		Id = u.Id
		, Email = aspu.Email
		, EmailConfirmed = aspu.EmailConfirmed
		, Username = aspu.UserName
		, Title = u.Title
		, FirstName = u.FirstName
		, LastName = u.LastName
		, MiddleNames = u.MiddleNames
		, FirstNameAndLastName = u.FirstNameAndLastName
		, Gender = u.Gender
		, DOB = u.DOB
		, [Type] = u.[Type]
		, Mobile = uaddress.Mobile
		, Address1 = uaddress.Address1
		, Address2 = uaddress.Address2
		, Suburb = uaddress.Suburb
		, [State] = uaddress.[State]
		, Postcode = uaddress.Postcode
		, Country = uaddress.Country
		, IsPostalSameAsStreetAddress = uaddress.IsPostalSameAsStreetAddress
		, PostalAddress1 = uaddress.PostalAddress1
		, PostalAddress2 = uaddress.PostalAddress2
		, PostalSuburb = uaddress.PostalSuburb
		, PostalState = uaddress.PostalState
		, PostalPostcode = uaddress.PostalPostcode
		, PostalCountry = uaddress.PostalCountry
		, IsActive = u.IsActive
		, IsDeleted = u.IsDeleted
		, [Created] = u.Created
		, [CreatedById] = u.CreatedById
		, [CreatedByName] = u.CreatedByName
		, [LastModified] = u.LastModified
		, [LastModifiedById] = u.LastModifiedById
		, [LastModifiedByName] = u.LastModifiedByName
		, HasAdministratorRole = 
			cast (
				case when exists (
						select top 1 uir.RoleId 
						from dbo.[AspNetUserRoles] uir 
						inner join dbo.[AspNetRoles] r on r.Id = uir.RoleId and uir.UserId = u.Id
						where r.NormalizedName = 'ADMINISTRATOR') 
					then 1 
					else 0
				end
			as bit)	
		, HasCorporateRole = 
			cast (
				case when exists (
						select top 1 uir.RoleId 
						from dbo.[AspNetUserRoles] uir 
						inner join dbo.[AspNetRoles] r on r.Id = uir.RoleId and uir.UserId = u.Id
						where r.NormalizedName = 'CORPORATE') 
					then 1 
					else 0
				end
			as bit)		
		, HasStudentRole = 
			cast (
				case when exists (
						select top 1 uir.RoleId 
						from dbo.[AspNetUserRoles] uir 
						inner join dbo.[AspNetRoles] r on r.Id = uir.RoleId and uir.UserId = u.Id
						where r.NormalizedName = 'STUDENT') 
					then 1 
					else 0
				end
			as bit)
		, HasTrainerRole = 
			cast (
				case when exists (
						select top 1 uir.RoleId 
						from dbo.[AspNetUserRoles] uir 
						inner join dbo.[AspNetRoles] r on r.Id = uir.RoleId and uir.UserId = u.Id
						where r.NormalizedName = 'TRAINER') 
					then 1 
					else 0
				end
			as bit)	
		--, ProfileImageUrl = (select top 1 sw.RelativePath 
		--				from dbo.[StorageAccessByUser] sau 
		--				inner join dbo.[StorageAndWebResource] sw on sau.StorageId = sw.Id and sau.UserId = u.Id
		--				inner join dbo.[StorageAndWebResourceType] swt on swt.Id = sw.TypeId
		--				where swt.[Name] = 'UserProfileImage')

	from dbo.[User] u 
	inner join dbo.[AspNetUsers] aspu on aspu.Id = u.Id 
	inner join dbo.[AspNetUserRoles] uir on uir.UserId = aspu.Id
	inner join dbo.[AspNetRoles] roles on roles.Id = uir.RoleId
	left join dbo.[UserAddress] uaddress on u.Id = uaddress.UserId
	--left join [TempAction] createAct on (u.Id = createAct.EntityUniqueId and			-- actionTypeId = 1 (create)
	--							createAct.ActionTypeId = 1) 
	--left join [TempAction] updateAct on (u.Id = updateAct.EntityUniqueId and
	--							updateAct.ActionTypeId in (3, 4))						-- actionTypeId = 3 (update), actionTypeId = 4 (delete)

	where
		--coalesce(u.IsDeleted, 0) = 0 and
		roles.[Name] not in ('Superuser') and
		aspu.UserName <> 'Administrator'
go
print 'Created view vw_Users'