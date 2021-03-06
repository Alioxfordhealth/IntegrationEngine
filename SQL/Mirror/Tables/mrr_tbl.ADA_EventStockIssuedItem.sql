SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_EventStockIssuedItem](
	[EventStockIssuedItemRef] [uniqueidentifier] NOT NULL,
	[EventStockIssuedRef] [uniqueidentifier] NULL,
	[StockItemRef] [uniqueidentifier] NULL,
	[IssueType] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BatchNo] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExpiryDate] [datetime] NULL
) ON [PRIMARY]

GO
