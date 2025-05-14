IF OBJECT_ID('dbo.dim_date_start') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE dim_date_start
END

CREATE EXTERNAL TABLE dim_date_start
WITH (
    LOCATION = 'dim_date_start',
    DATA_SOURCE = [jp-system-name_jpaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT ROW_NUMBER() OVER (ORDER BY started_at) AS date_id,
YEAR([started_at]) as date_year, DATEPART(QUARTER, [started_at]) as date_quarter, MONTH([started_at]) as date_month, DAY([started_at]) as date_day,
DATEPART(HOUR, [started_at]) as date_hour, DATEPART(MINUTE, [started_at]) as date_minute, DATEPART(SECOND, [started_at]) as date_second, DATEPART(DW, [started_at]) as date_day_of_week
FROM [dbo].[trips] GROUP BY started_at
GO

IF OBJECT_ID('dbo.dim_date_end') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE dim_date_end
END

CREATE EXTERNAL TABLE dim_date_end
WITH (
    LOCATION = 'dim_date_end',
    DATA_SOURCE = [jp-system-name_jpaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT (ROW_NUMBER() OVER (ORDER BY ended_at) + 5000000) AS date_id,
YEAR([ended_at]) as date_year, DATEPART(QUARTER, [ended_at]) as date_quarter, MONTH([ended_at]) as date_month, DAY([ended_at]) as date_day,
DATEPART(HOUR, [ended_at]) as date_hour, DATEPART(MINUTE, [ended_at]) as date_minute, DATEPART(SECOND, [ended_at]) as date_second, DATEPART(DW, [ended_at]) as date_day_of_week
FROM [dbo].[trips] GROUP BY ended_at
GO

IF OBJECT_ID('dbo.dim_date_payment') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE dim_date_payment
END

CREATE EXTERNAL TABLE dim_date_payment
WITH (
    LOCATION = 'dim_date_payment',
    DATA_SOURCE = [jp-system-name_jpaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT (ROW_NUMBER() OVER (ORDER BY payment_date) + 10000000) AS date_id,
YEAR([payment_date]) as date_year, DATEPART(QUARTER, [payment_date]) as date_quarter, MONTH([payment_date]) as date_month, DAY([payment_date]) as date_day,
0 as date_hour, 0 as date_minute, 0 as date_second, DATEPART(DW, [payment_date]) as date_day_of_week
FROM [dbo].[payments] GROUP BY payment_date
GO

-- Create a new table to store combined data
IF OBJECT_ID('dbo.dim_date') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE dim_date
END

CREATE EXTERNAL TABLE dim_date
WITH (
    LOCATION = 'dim_date',
    DATA_SOURCE = [jp-system-name_jpaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT * FROM [dbo].[dim_date_start]
UNION ALL
SELECT * FROM [dbo].[dim_date_end]
UNION ALL
SELECT * FROM [dbo].[dim_date_payment]

IF OBJECT_ID('dbo.dim_date_start') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE dim_date_start
END
IF OBJECT_ID('dbo.dim_date_end') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE dim_date_end
END
IF OBJECT_ID('dbo.dim_date_payment') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE dim_date_payment
END

SELECT TOP 100 * FROM dim_date
GO