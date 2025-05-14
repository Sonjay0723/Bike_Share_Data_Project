IF OBJECT_ID('dbo.dim_station') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE dim_station
END

CREATE EXTERNAL TABLE dim_station
WITH (
    LOCATION = 'dim_station',
    DATA_SOURCE = [jp-system-name_jpaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT [station_id], [name], [latitude], [longitude]
FROM [dbo].[stations]
GO

SELECT TOP 100 * FROM dim_station
GO