IF OBJECT_ID('dbo.fact_trips') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE fact_trips
END

CREATE EXTERNAL TABLE fact_trips
WITH (
    LOCATION = 'fact_trips',
    DATA_SOURCE = [jp-system-name_jpaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT tr.trip_id, tr.rideable_type, tr.rider_id, 
CAST(DATEDIFF(DAY, ri.birthday, CAST(tr.started_at AS DATE)) / 365 AS INT) AS rider_age,
tr.start_station AS start_station_id, tr.end_station AS end_station_id,
da_start.date_id AS start_date_id, da_end.date_id AS end_date_id,
DATEDIFF(SECOND, tr.started_at, tr.ended_at) AS trip_duration_seconds
FROM [dbo].[trips] AS tr
JOIN [dbo].[riders] AS ri
ON tr.rider_id = ri.rider_id
JOIN [dbo].[dim_date] AS da_start
ON (YEAR(started_at) = da_start.date_year AND DATEPART(QUARTER, [ended_at]) = da_start.date_quarter AND
MONTH(started_at) = da_start.date_month AND DAY(started_at) = da_start.date_day AND
DATEPART(HOUR, [started_at]) = da_start.date_hour AND DATEPART(MINUTE, [started_at]) = da_start.date_minute AND 
DATEPART(SECOND, [started_at]) = da_start.date_second AND DATEPART(DW, [started_at]) = da_start.date_day_of_week)
JOIN [dbo].[dim_date] AS da_end
ON (YEAR(ended_at) = da_end.date_year AND DATEPART(QUARTER, [ended_at]) = da_end.date_quarter AND
MONTH(ended_at) = da_end.date_month AND DAY(ended_at) = da_end.date_day AND
DATEPART(HOUR, [ended_at]) = da_end.date_hour AND DATEPART(MINUTE, [ended_at]) = da_end.date_minute AND 
DATEPART(SECOND, [ended_at]) = da_end.date_second AND DATEPART(DW, [ended_at]) = da_end.date_day_of_week)
GO

SELECT TOP 100 * FROM fact_trips
GO