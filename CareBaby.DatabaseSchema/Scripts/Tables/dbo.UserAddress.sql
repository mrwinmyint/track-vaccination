/****** Object:  Table [dbo].[UserAddress]    Script Date: 7/11/2020 9:18:39 PM ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserAddress]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserAddress](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,	
	[Mobile] [nvarchar](50) NULL,
	[Address1] [nvarchar](500) NULL,
	[Address2] [nvarchar](500) NULL,
	[Suburb] [nvarchar](250) NULL,
	[State] [nvarchar](100) NULL,
	[Postcode] [nvarchar](10) NULL,
	[Country] [nvarchar](100) NULL,
	[IsPostalSameAsStreetAddress] [bit] NOT NULL,
	[PostalAddress1] [nvarchar](500) NULL,
	[PostalAddress2] [nvarchar](500) NULL,
	[PostalSuburb] [nvarchar](250) NULL,
	[PostalState] [nvarchar](100) NULL,
	[PostalPostcode] [nvarchar](10) NULL,
	[PostalCountry] [nvarchar](100) NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[Created] [DateTimeOffset] NOT NULL,
	[CreatedById] [uniqueidentifier] NULL,
	[CreatedByName] [nvarchar](256) NULL,
	[LastModified] [DateTimeOffset] NULL,
	[LastModifiedById] [uniqueidentifier] NULL,
	[LastModifiedByName] [nvarchar](256) NULL,
 CONSTRAINT [PK_UserAddress] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
