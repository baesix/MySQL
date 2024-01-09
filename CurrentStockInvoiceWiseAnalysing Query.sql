SELECT 
ii.Item_ID,
    ii. Item_Name,
    ii.ItemCategory,
    ii.CostPriceOfOneItem,
    ii.Price,
    (((ii.Price- ii.CostPriceOfOneItem) / ii.Price) * 100) AS PROFIT_MARGIN,
    ii.GenuinePartCode,
    ii.Sold_Qty,
    i.ItemQty,
    i.Warehouse,
    IFNULL(g.Supp_Name,"Manual Supplier") AS Supp_Name,
    MAX(IFNULL(g.Date,"Manual Stock")) AS GRN_Date,
    IFNULL(sri.TotReturnQty,0) AS Return_Qty
FROM 
    items i
LEFT JOIN 
  (SELECT SUM(IFNULL(Qty,0)) As Sold_Qty,
  Inv_ID,
  Item_ID,
  Eng_Name AS Item_Name,
  ItemCategory,
  CostPriceOfOneItem,
  SalesPriceOriginal as Price,(((SalesPriceOriginal - CostPriceOfOneItem) / SalesPriceOriginal) * 100) AS PROFIT_MARGIN,
  GenuinePartCode 
  FROM invoice_items GROUP BY Item_ID) ii ON ii.Item_ID = i.Item_ID 
LEFT JOIN 
    grn_Items gi ON gi.Item_ID = ii.Item_ID
LEFT JOIN 
    grn g ON g.GRN_CustomID = gi.GRN_CustomID
LEFT JOIN 
    invoice inv ON inv.Inv_ID = ii.Inv_ID
LEFT JOIN 
    (SELECT SUM(IFNULL(Return_Qty,0)) As TotReturnQty, Item_ID FROM sales_return_items GROUP BY Item_ID) sri ON sri.Item_ID = ii.Item_ID 
--  WHERE inv.date between $P{FromDate} AND  $P{ToDate}
where ii.Item_ID = "B6301G50"
GROUP BY 
    ii.Item_ID, 
    ii.Item_Name 
    -- if they ask you have to remove some of groups 
ORDER BY 
    ii.Item_ID