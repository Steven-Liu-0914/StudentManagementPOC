USE [StudentDB]
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateStudent]    Script Date: 26/10/2025 3:56:41 pm ******/
DROP PROCEDURE [dbo].[sp_UpdateStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetStudents]    Script Date: 26/10/2025 3:56:41 pm ******/
DROP PROCEDURE [dbo].[sp_GetStudents]
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteStudent]    Script Date: 26/10/2025 3:56:41 pm ******/
DROP PROCEDURE [dbo].[sp_DeleteStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateStudent]    Script Date: 26/10/2025 3:56:41 pm ******/
DROP PROCEDURE [dbo].[sp_CreateStudent]
GO
/****** Object:  StoredProcedure [dbo].[sp_CheckEmailExists]    Script Date: 26/10/2025 3:56:41 pm ******/
DROP PROCEDURE [dbo].[sp_CheckEmailExists]
GO
ALTER TABLE [dbo].[Students] DROP CONSTRAINT [DF__Students__Update__34C8D9D1]
GO
ALTER TABLE [dbo].[Students] DROP CONSTRAINT [DF__Students__Create__33D4B598]
GO
/****** Object:  Table [dbo].[Students]    Script Date: 26/10/2025 3:56:41 pm ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Students]') AND type in (N'U'))
DROP TABLE [dbo].[Students]
GO
/****** Object:  Table [dbo].[Students]    Script Date: 26/10/2025 3:56:41 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[StudentID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](255) NOT NULL,
	[LastName] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Students_Email] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Students] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Students] ADD  DEFAULT (sysutcdatetime()) FOR [UpdatedAt]
GO
/****** Object:  StoredProcedure [dbo].[sp_CheckEmailExists]    Script Date: 26/10/2025 3:56:41 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CheckEmailExists]
    @Email NVARCHAR(255),
    @StudentID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @StudentID IS NULL
    BEGIN
        SELECT CASE WHEN EXISTS (
            SELECT 1 FROM dbo.Students WHERE Email = @Email
        ) THEN 1 ELSE 0 END AS ExistsFlag;
    END
    ELSE
    BEGIN
        SELECT CASE WHEN EXISTS (
            SELECT 1 FROM dbo.Students WHERE Email = @Email AND StudentID <> @StudentID
        ) THEN 1 ELSE 0 END AS ExistsFlag;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateStudent]    Script Date: 26/10/2025 3:56:41 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CreateStudent]
    @FirstName NVARCHAR(255),
    @LastName NVARCHAR(255),
    @Email NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Students (FirstName, LastName, Email, CreatedAt, UpdatedAt)
    VALUES (@FirstName, @LastName, @Email, GETDATE(), GETDATE());
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteStudent]    Script Date: 26/10/2025 3:56:41 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteStudent]
    @StudentID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Students WHERE StudentID = @StudentID;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetStudents]    Script Date: 26/10/2025 3:56:41 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetStudents]
    @StudentID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @StudentID IS NULL
    BEGIN
        SELECT StudentID, FirstName, LastName, Email, CreatedAt, UpdatedAt
        FROM dbo.Students;
    END
    ELSE
    BEGIN
        SELECT StudentID, FirstName, LastName, Email, CreatedAt, UpdatedAt
        FROM dbo.Students
        WHERE StudentID = @StudentID;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateStudent]    Script Date: 26/10/2025 3:56:41 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateStudent]
    @StudentID INT,
    @FirstName NVARCHAR(255),
    @LastName NVARCHAR(255),
    @Email NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Students
    SET FirstName = @FirstName,
        LastName = @LastName,
        Email = @Email,
        UpdatedAt = GETDATE()
    WHERE StudentID = @StudentID;
END
GO
