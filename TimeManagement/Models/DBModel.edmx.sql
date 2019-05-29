
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, and Azure
-- --------------------------------------------------
-- Date Created: 10/05/2013 18:25:02
-- Generated from EDMX file: C:\Atit\MTS\Projects\MTS\MTS Portal\V1\TimeManagement\Models\DBModel.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [MTS-PORTAL];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_LocationEmployee]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Employees] DROP CONSTRAINT [FK_LocationEmployee];
GO
IF OBJECT_ID(N'[dbo].[FK_WorkCodeTask]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Tasks] DROP CONSTRAINT [FK_WorkCodeTask];
GO
IF OBJECT_ID(N'[dbo].[FK_ProjectTask]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Tasks] DROP CONSTRAINT [FK_ProjectTask];
GO
IF OBJECT_ID(N'[dbo].[FK_EmployeeTask]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Tasks] DROP CONSTRAINT [FK_EmployeeTask];
GO
IF OBJECT_ID(N'[dbo].[FK_LoginEmployee]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Logins] DROP CONSTRAINT [FK_LoginEmployee];
GO
IF OBJECT_ID(N'[dbo].[FK_EmployeeEmployeeRole]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[EmployeeRoles] DROP CONSTRAINT [FK_EmployeeEmployeeRole];
GO
IF OBJECT_ID(N'[dbo].[FK_RoleEmployeeRole]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[EmployeeRoles] DROP CONSTRAINT [FK_RoleEmployeeRole];
GO
IF OBJECT_ID(N'[dbo].[FK_EmployeeEmployeeProject]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[EmployeeProjects] DROP CONSTRAINT [FK_EmployeeEmployeeProject];
GO
IF OBJECT_ID(N'[dbo].[FK_ProjectEmployeeProject]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[EmployeeProjects] DROP CONSTRAINT [FK_ProjectEmployeeProject];
GO
IF OBJECT_ID(N'[dbo].[FK_EmployeeWeeklyReport]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[WeeklyReports] DROP CONSTRAINT [FK_EmployeeWeeklyReport];
GO
IF OBJECT_ID(N'[dbo].[FK_ProjectWeeklyReport]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[WeeklyReports] DROP CONSTRAINT [FK_ProjectWeeklyReport];
GO
IF OBJECT_ID(N'[dbo].[FK_WeeklyReportNote]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Notes] DROP CONSTRAINT [FK_WeeklyReportNote];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[Locations]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Locations];
GO
IF OBJECT_ID(N'[dbo].[Employees]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Employees];
GO
IF OBJECT_ID(N'[dbo].[Tasks]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Tasks];
GO
IF OBJECT_ID(N'[dbo].[Projects]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Projects];
GO
IF OBJECT_ID(N'[dbo].[WorkCodes]', 'U') IS NOT NULL
    DROP TABLE [dbo].[WorkCodes];
GO
IF OBJECT_ID(N'[dbo].[Logins]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Logins];
GO
IF OBJECT_ID(N'[dbo].[Roles]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Roles];
GO
IF OBJECT_ID(N'[dbo].[EmployeeRoles]', 'U') IS NOT NULL
    DROP TABLE [dbo].[EmployeeRoles];
GO
IF OBJECT_ID(N'[dbo].[EmployeeProjects]', 'U') IS NOT NULL
    DROP TABLE [dbo].[EmployeeProjects];
GO
IF OBJECT_ID(N'[dbo].[WeeklyReports]', 'U') IS NOT NULL
    DROP TABLE [dbo].[WeeklyReports];
GO
IF OBJECT_ID(N'[dbo].[Notes]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Notes];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'Locations'
CREATE TABLE [dbo].[Locations] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(100)  NOT NULL
);
GO

-- Creating table 'Employees'
CREATE TABLE [dbo].[Employees] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [LocationId] int  NOT NULL,
    [Prefix] nvarchar(25)  NULL,
    [FirstName] nvarchar(50)  NOT NULL,
    [MiddleName] nvarchar(50)  NULL,
    [LastName] nvarchar(50)  NOT NULL,
    [Suffix] nvarchar(25)  NULL,
    [BillRate] decimal(10,2)  NULL
);
GO

-- Creating table 'Tasks'
CREATE TABLE [dbo].[Tasks] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [WorkCodeId] int  NOT NULL,
    [ProjectId] int  NOT NULL,
    [EmployeeId] int  NOT NULL,
    [Description] nvarchar(max)  NOT NULL,
    [ExecutionDate] datetime  NOT NULL,
    [Hours] decimal(10,2)  NOT NULL,
    [CreatedOn] datetime  NOT NULL,
    [Charge] decimal(10,2)  NOT NULL
);
GO

-- Creating table 'Projects'
CREATE TABLE [dbo].[Projects] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(150)  NOT NULL,
    [Number] nvarchar(10)  NULL,
    [EstStartDate] datetime  NULL,
    [EstEndDate] datetime  NULL,
    [IsCommon] bit  NULL
);
GO

-- Creating table 'WorkCodes'
CREATE TABLE [dbo].[WorkCodes] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(70)  NOT NULL,
    [Number] nvarchar(10)  NULL,
    [Billable] bit  NOT NULL
);
GO

-- Creating table 'Logins'
CREATE TABLE [dbo].[Logins] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [UserId] nvarchar(25)  NOT NULL,
    [Password] nvarchar(255)  NOT NULL,
    [Status] int  NULL,
    [Employee_Id] int  NOT NULL
);
GO

-- Creating table 'Roles'
CREATE TABLE [dbo].[Roles] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(15)  NOT NULL
);
GO

-- Creating table 'EmployeeRoles'
CREATE TABLE [dbo].[EmployeeRoles] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [EmployeeId] int  NOT NULL,
    [RoleId] int  NOT NULL
);
GO

-- Creating table 'EmployeeProjects'
CREATE TABLE [dbo].[EmployeeProjects] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [EmployeeId] int  NOT NULL,
    [ProjectId] int  NOT NULL
);
GO

-- Creating table 'WeeklyReports'
CREATE TABLE [dbo].[WeeklyReports] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [EmployeeId] int  NOT NULL,
    [ProjectId] int  NOT NULL,
    [Scope] int  NOT NULL,
    [Schedule] int  NOT NULL,
    [Quality] int  NOT NULL,
    [ClientSatisfaction] int  NOT NULL,
    [ProjectStatus] nvarchar(max)  NOT NULL,
    [Risk] nvarchar(max)  NULL,
    [CreatedOn] datetime  NOT NULL,
    [From] datetime  NOT NULL,
    [To] datetime  NOT NULL
);
GO

-- Creating table 'Notes'
CREATE TABLE [dbo].[Notes] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Text] nvarchar(max)  NOT NULL,
    [UserId] nvarchar(25)  NOT NULL,
    [CreatedOn] datetime  NOT NULL,
    [WeeklyReportId] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'Locations'
ALTER TABLE [dbo].[Locations]
ADD CONSTRAINT [PK_Locations]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Employees'
ALTER TABLE [dbo].[Employees]
ADD CONSTRAINT [PK_Employees]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Tasks'
ALTER TABLE [dbo].[Tasks]
ADD CONSTRAINT [PK_Tasks]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Projects'
ALTER TABLE [dbo].[Projects]
ADD CONSTRAINT [PK_Projects]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'WorkCodes'
ALTER TABLE [dbo].[WorkCodes]
ADD CONSTRAINT [PK_WorkCodes]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Logins'
ALTER TABLE [dbo].[Logins]
ADD CONSTRAINT [PK_Logins]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Roles'
ALTER TABLE [dbo].[Roles]
ADD CONSTRAINT [PK_Roles]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'EmployeeRoles'
ALTER TABLE [dbo].[EmployeeRoles]
ADD CONSTRAINT [PK_EmployeeRoles]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'EmployeeProjects'
ALTER TABLE [dbo].[EmployeeProjects]
ADD CONSTRAINT [PK_EmployeeProjects]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'WeeklyReports'
ALTER TABLE [dbo].[WeeklyReports]
ADD CONSTRAINT [PK_WeeklyReports]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Notes'
ALTER TABLE [dbo].[Notes]
ADD CONSTRAINT [PK_Notes]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [LocationId] in table 'Employees'
ALTER TABLE [dbo].[Employees]
ADD CONSTRAINT [FK_LocationEmployee]
    FOREIGN KEY ([LocationId])
    REFERENCES [dbo].[Locations]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_LocationEmployee'
CREATE INDEX [IX_FK_LocationEmployee]
ON [dbo].[Employees]
    ([LocationId]);
GO

-- Creating foreign key on [WorkCodeId] in table 'Tasks'
ALTER TABLE [dbo].[Tasks]
ADD CONSTRAINT [FK_WorkCodeTask]
    FOREIGN KEY ([WorkCodeId])
    REFERENCES [dbo].[WorkCodes]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_WorkCodeTask'
CREATE INDEX [IX_FK_WorkCodeTask]
ON [dbo].[Tasks]
    ([WorkCodeId]);
GO

-- Creating foreign key on [ProjectId] in table 'Tasks'
ALTER TABLE [dbo].[Tasks]
ADD CONSTRAINT [FK_ProjectTask]
    FOREIGN KEY ([ProjectId])
    REFERENCES [dbo].[Projects]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_ProjectTask'
CREATE INDEX [IX_FK_ProjectTask]
ON [dbo].[Tasks]
    ([ProjectId]);
GO

-- Creating foreign key on [EmployeeId] in table 'Tasks'
ALTER TABLE [dbo].[Tasks]
ADD CONSTRAINT [FK_EmployeeTask]
    FOREIGN KEY ([EmployeeId])
    REFERENCES [dbo].[Employees]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_EmployeeTask'
CREATE INDEX [IX_FK_EmployeeTask]
ON [dbo].[Tasks]
    ([EmployeeId]);
GO

-- Creating foreign key on [Employee_Id] in table 'Logins'
ALTER TABLE [dbo].[Logins]
ADD CONSTRAINT [FK_LoginEmployee]
    FOREIGN KEY ([Employee_Id])
    REFERENCES [dbo].[Employees]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_LoginEmployee'
CREATE INDEX [IX_FK_LoginEmployee]
ON [dbo].[Logins]
    ([Employee_Id]);
GO

-- Creating foreign key on [EmployeeId] in table 'EmployeeRoles'
ALTER TABLE [dbo].[EmployeeRoles]
ADD CONSTRAINT [FK_EmployeeEmployeeRole]
    FOREIGN KEY ([EmployeeId])
    REFERENCES [dbo].[Employees]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_EmployeeEmployeeRole'
CREATE INDEX [IX_FK_EmployeeEmployeeRole]
ON [dbo].[EmployeeRoles]
    ([EmployeeId]);
GO

-- Creating foreign key on [RoleId] in table 'EmployeeRoles'
ALTER TABLE [dbo].[EmployeeRoles]
ADD CONSTRAINT [FK_RoleEmployeeRole]
    FOREIGN KEY ([RoleId])
    REFERENCES [dbo].[Roles]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_RoleEmployeeRole'
CREATE INDEX [IX_FK_RoleEmployeeRole]
ON [dbo].[EmployeeRoles]
    ([RoleId]);
GO

-- Creating foreign key on [EmployeeId] in table 'EmployeeProjects'
ALTER TABLE [dbo].[EmployeeProjects]
ADD CONSTRAINT [FK_EmployeeEmployeeProject]
    FOREIGN KEY ([EmployeeId])
    REFERENCES [dbo].[Employees]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_EmployeeEmployeeProject'
CREATE INDEX [IX_FK_EmployeeEmployeeProject]
ON [dbo].[EmployeeProjects]
    ([EmployeeId]);
GO

-- Creating foreign key on [ProjectId] in table 'EmployeeProjects'
ALTER TABLE [dbo].[EmployeeProjects]
ADD CONSTRAINT [FK_ProjectEmployeeProject]
    FOREIGN KEY ([ProjectId])
    REFERENCES [dbo].[Projects]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_ProjectEmployeeProject'
CREATE INDEX [IX_FK_ProjectEmployeeProject]
ON [dbo].[EmployeeProjects]
    ([ProjectId]);
GO

-- Creating foreign key on [EmployeeId] in table 'WeeklyReports'
ALTER TABLE [dbo].[WeeklyReports]
ADD CONSTRAINT [FK_EmployeeWeeklyReport]
    FOREIGN KEY ([EmployeeId])
    REFERENCES [dbo].[Employees]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_EmployeeWeeklyReport'
CREATE INDEX [IX_FK_EmployeeWeeklyReport]
ON [dbo].[WeeklyReports]
    ([EmployeeId]);
GO

-- Creating foreign key on [ProjectId] in table 'WeeklyReports'
ALTER TABLE [dbo].[WeeklyReports]
ADD CONSTRAINT [FK_ProjectWeeklyReport]
    FOREIGN KEY ([ProjectId])
    REFERENCES [dbo].[Projects]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_ProjectWeeklyReport'
CREATE INDEX [IX_FK_ProjectWeeklyReport]
ON [dbo].[WeeklyReports]
    ([ProjectId]);
GO

-- Creating foreign key on [WeeklyReportId] in table 'Notes'
ALTER TABLE [dbo].[Notes]
ADD CONSTRAINT [FK_WeeklyReportNote]
    FOREIGN KEY ([WeeklyReportId])
    REFERENCES [dbo].[WeeklyReports]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_WeeklyReportNote'
CREATE INDEX [IX_FK_WeeklyReportNote]
ON [dbo].[Notes]
    ([WeeklyReportId]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------