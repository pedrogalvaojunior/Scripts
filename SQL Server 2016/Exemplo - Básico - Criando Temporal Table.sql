CREATE TABLE [dbo].[Orders](
                             [OrdersID] int PRIMARY KEY CLUSTERED,
                             [Quantity] int NOT NULL,
                             [UnitPrice] money not null,
                             [OrderDate] datetime2 NOT NULL,
                             [SysStartTime] datetime2(0) GENERATED ALWAYS AS ROW START NOT NULL,
                             [SysEndTime] datetime2(0) GENERATED ALWAYS AS ROW END NOT NULL,
                             PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime])
)
WITH (SYSTEM_VERSIONING = ON );

