SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[ADA_Address] AS SELECT [AddressRef], [Building], [BuildingExtension], [Street], [Locality], [Town], [County], [Postcode], [AddressType], [Directions], [Country], [CountryRef], [Longitude], [Latitude], [MapReference], [StatusRef], [UPRN] FROM [Mirror].[mrr_tbl].[ADA_Address];

GO
