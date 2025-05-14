IF OBJECT_ID('dbo.dim_rider') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE dim_rider
END

CREATE EXTERNAL TABLE dim_rider
WITH (
    LOCATION = 'dim_rider',
    DATA_SOURCE = [jp-system-name_jpaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT [rider_id], [first], [last], [address], [birthday], [is_member], [account_start], [account_end]
FROM [dbo].[riders]
GO

SELECT TOP 100 * FROM dim_rider
GO