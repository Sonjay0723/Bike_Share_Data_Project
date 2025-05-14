IF OBJECT_ID('dbo.fact_payments') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE fact_payments
END

CREATE EXTERNAL TABLE fact_payments
WITH (
    LOCATION = 'fact_payments',
    DATA_SOURCE = [jp-system-name_jpaccount_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)
AS
SELECT pa.payment_id, pa.rider_id, da.date_id, pa.amount
FROM [dbo].[payments] AS pa
JOIN [dbo].[dim_date] AS da
ON (YEAR(payment_date) = da.date_year AND DATEPART(QUARTER, [payment_date]) = da.date_quarter AND
MONTH(payment_date) = da.date_month AND DAY(payment_date) = da.date_day AND
0 = da.date_hour AND 0 = da.date_minute AND 
0 = da.date_second AND DATEPART(DW, [payment_date]) = da.date_day_of_week)
GO

SELECT TOP 100 * FROM fact_payments
GO